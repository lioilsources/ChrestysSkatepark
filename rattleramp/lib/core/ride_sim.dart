/// Deterministic ride simulation. Pure Dart, fixed timestep.
///
/// Same config + same [ReleaseInput]s ⇒ same ride, so a replay is just the
/// input log (see [RideSim.inputs]).
///
/// A ride is a sequence of segments. Each segment rolls from one coping to
/// the other (`segStart → tEdge`), then airs (`tEdge → tLand`). Both times
/// are known as soon as the segment starts, so a release is judged purely by
/// its timestamp against the current segment's edge.
library;

import 'dart:math' as math;

import 'ramp.dart';
import 'ride_config.dart';
import 'scoring.dart';
import 'trick_defs.dart';
import 'trick_parser.dart';

/// One finished swipe: node path and the moment the finger lifted, in ride
/// seconds (before latency compensation).
class ReleaseInput {
  final double t;
  final List<int> nodes;
  const ReleaseInput(this.t, this.nodes);

  Map<String, dynamic> toJson() => {'t': t, 'n': nodes};
  factory ReleaseInput.fromJson(Map<String, dynamic> j) =>
      ReleaseInput((j['t'] as num).toDouble(), (j['n'] as List).cast<int>());
}

enum RidePhase { dropIn, rolling, air, bail, rollout, finished }

enum BailReason { timingMiss, badPattern, trickTooLong }

enum RideEventType { judged, tooEarly, landed, emptyAir, bail, outOfSpeed, finished }

class RideEvent {
  final RideEventType type;
  final double t;
  final Timing? timing;
  final ParsedTrick? trick;
  final ScoreBreakdown? score;
  final BailReason? bailReason;
  final ParseError? parseError;

  /// Judged releases: seconds relative to the edge (− early, + late).
  final double? delta;

  const RideEvent(
    this.type,
    this.t, {
    this.timing,
    this.trick,
    this.score,
    this.bailReason,
    this.parseError,
    this.delta,
  });
}

class _Attempt {
  final Timing timing;
  final ParseResult parse;
  final double tStart;
  _Attempt(this.timing, this.parse, this.tStart);

  bool get fatal => timing == Timing.miss || !parse.ok;
}

/// Everything the renderer needs for one frame.
class SkaterPose {
  /// Board-centre contact point in world metres.
  final double x;
  final double y;

  /// Rotation of the skater's local frame; local +y is "up" for the skater.
  final double angle;

  /// −1…1 horizontal scale: sign = facing, |value| < 1 = mid-spin.
  final double facing;

  /// Board rotation in full turns: roll = long axis, shove = vertical axis,
  /// tumble = short axis (in the drawing plane).
  final double roll;
  final double shove;
  final double tumble;

  /// 0…1 how far the feet lift off the board for a flip.
  final double flip;

  /// 0…1 how far the hand reaches for the board.
  final double grab;

  /// Which hand, where and with what body shape.
  final GrabLook grabLook;
  final double crouch;

  /// 0…1 progress of a bail fall, 0 when riding.
  final double bail;

  const SkaterPose({
    required this.x,
    required this.y,
    required this.angle,
    required this.facing,
    this.roll = 0,
    this.shove = 0,
    this.tumble = 0,
    this.flip = 0,
    this.grab = 0,
    this.grabLook = const GrabLook(),
    this.crouch = 0,
    this.bail = 0,
  });
}

class RideStats {
  int score = 0;
  int landed = 0;
  int streak = 0;
  int maxStreak = 0;
  String? bestTrick;
  int bestTrickPoints = 0;
  double timingSum = 0;
  final Map<String, int> trickCounts = {};

  /// 0…1 — perfect = 1, good = ⅔, late = ⅓.
  double get averageTiming => landed == 0 ? 0 : timingSum / landed;
}

class RideSim {
  final RideConfig config;
  final TrickParser parser;
  final Ramp ramp;
  final bool proMode;
  final String? dailyTokenId;

  final List<ReleaseInput> inputs = [];
  final RideStats stats = RideStats();

  double time = 0;
  RidePhase phase = RidePhase.dropIn;
  double speed;

  /// +1 rolling towards the right coping, −1 towards the left.
  int dir = 1;

  /// Visual stance: −1 after an odd number of half spins (riding fakie).
  int stance = 1;
  BailReason? bailReason;

  late double segStart;
  late double tEdge;
  late double tLand;
  late double _vLaunch;
  late List<double> _distTable;
  static const double _tableDt = 1 / 240;

  _Attempt? _attempt;
  int _nextInput = 0;
  double _phaseStart = 0;
  double _bailS = 0;
  int _bailDir = 1;

  final List<RideEvent> _events = [];

  RideSim({required this.config, required this.parser, this.proMode = false, this.dailyTokenId})
    : ramp = Ramp(radius: config.rampRadius, flat: config.flatWidth, vert: config.vertHeight),
      speed = config.startSpeed {
    _startSegment(config.dropInDelay);
  }

  bool get finished => phase == RidePhase.finished;

  /// Side of the coping the current segment is heading to.
  int get edgeSide => dir;

  /// Remaining time to the edge (negative once airborne).
  double get timeToEdge => tEdge - time;

  /// Effective timing windows for the current speed.
  double get perfectWindow => config.perfectWindow * config.windowFactor(speed);
  double get goodWindow => config.goodWindow * config.windowFactor(speed);
  double get lateWindow => config.lateWindow * config.windowFactor(speed);

  bool get hasAttempt => _attempt != null;

  /// The trick being performed in the current air, if any.
  ParsedTrick? get currentTrick => _attempt?.parse.trick;

  /// Queue a release. Timestamps must be non-decreasing.
  void addInput(ReleaseInput input) {
    assert(inputs.isEmpty || input.t >= inputs.last.t);
    inputs.add(input);
  }

  /// Events produced since the last call.
  List<RideEvent> drainEvents() {
    final out = List<RideEvent>.of(_events);
    _events.clear();
    return out;
  }

  /// Advance exactly one fixed tick.
  void step() {
    final target = time + config.dt;
    while (true) {
      final boundary = _nextBoundary();
      final until = math.min(boundary, target);
      _processInputs(until);
      if (boundary <= target) {
        time = boundary;
        _transition();
        if (phase == RidePhase.finished) return;
      } else {
        time = target;
        return;
      }
    }
  }

  /// Run until finished (or [maxSeconds]); used by tests and replays.
  void runToEnd({double maxSeconds = 600}) {
    while (!finished && time < maxSeconds) {
      step();
    }
  }

  // ── Segment physics ───────────────────────────────────────────────────

  void _startSegment(double start) {
    segStart = start;
    _vLaunch = config.launchVelocity(speed);
    _distTable = _buildDistanceTable(_vLaunch);
    tEdge = segStart + (_distTable.length - 1) * _tableDt;
    tLand = tEdge + 2 * _vLaunch / config.gravity;
    _attempt = null;
  }

  /// Distance travelled along the path, sampled every [_tableDt], from one
  /// coping to the other. Last sample is exactly [Ramp.length].
  List<double> _buildDistanceTable(double v0) {
    final g = config.gravity;
    final h = ramp.copingHeight;
    final len = ramp.length;
    double v(double s) => math.sqrt(v0 * v0 + 2 * g * (h - ramp.height(s)));
    const sub = 8;
    const hdt = _tableDt / sub;
    final table = <double>[0];
    var s = 0.0;
    while (true) {
      for (var k = 0; k < sub; k++) {
        final mid = s + v(s) * hdt / 2;
        s += v(mid) * hdt;
      }
      if (s >= len) {
        // Stretch the final sample so the table ends exactly at the coping.
        table.add(len);
        return table;
      }
      table.add(s);
    }
  }

  double _distanceAt(double t) {
    final f = (t - segStart) / _tableDt;
    if (f <= 0) return 0;
    final i = f.floor();
    if (i >= _distTable.length - 1) return _distTable.last;
    final a = _distTable[i];
    return a + (_distTable[i + 1] - a) * (f - i);
  }

  /// Path parameter for the current rolling segment.
  double get pathS {
    final d = _distanceAt(time);
    return dir > 0 ? d : ramp.length - d;
  }

  double get airHeight {
    if (phase != RidePhase.air) return 0;
    final tau = time - tEdge;
    return _vLaunch * tau - config.gravity * tau * tau / 2;
  }

  double get maxAirHeight => _vLaunch * _vLaunch / (2 * config.gravity);

  double get airDuration => tLand - tEdge;

  // ── State machine ─────────────────────────────────────────────────────

  double _nextBoundary() => switch (phase) {
    RidePhase.dropIn => segStart,
    RidePhase.rolling => tEdge,
    RidePhase.air => tLand,
    RidePhase.bail => _phaseStart + config.bailDuration,
    RidePhase.rollout => _phaseStart + _rolloutDuration,
    RidePhase.finished => double.infinity,
  };

  static const double _rolloutDuration = 3.0;

  void _transition() {
    switch (phase) {
      case RidePhase.dropIn:
        phase = RidePhase.rolling;
      case RidePhase.rolling:
        final a = _attempt;
        if (a != null && a.fatal) {
          _bail(a.parse.ok ? BailReason.timingMiss : BailReason.badPattern, ramp.length * (dir > 0 ? 1 : 0));
        } else {
          phase = RidePhase.air;
        }
      case RidePhase.air:
        _land();
      case RidePhase.bail:
      case RidePhase.rollout:
        phase = RidePhase.finished;
        _events.add(RideEvent(RideEventType.finished, time));
      case RidePhase.finished:
        break;
    }
  }

  void _land() {
    final a = _attempt;
    final edgeS = dir > 0 ? ramp.length : 0.0;
    if (a == null) {
      speed -= config.lossEmptyAir;
      _events.add(RideEvent(RideEventType.emptyAir, time));
      if (speed < 0) {
        speed = 0;
        phase = RidePhase.rollout;
        _phaseStart = time;
        _events.add(RideEvent(RideEventType.outOfSpeed, time));
        return;
      }
    } else if (a.fatal) {
      _bail(a.parse.ok ? BailReason.timingMiss : BailReason.badPattern, edgeS);
      return;
    } else {
      final trick = a.parse.trick!;
      if (a.tStart + trickDuration(trick) > tLand + 1e-9) {
        _bail(BailReason.trickTooLong, edgeS);
        return;
      }
      _score(trick, a.timing);
      if (_halfSpins(trick).isOdd) stance = -stance;
    }
    dir = -dir;
    phase = RidePhase.rolling;
    _startSegment(time);
  }

  void _score(ParsedTrick trick, Timing timing) {
    final prev = stats.trickCounts[trick.key] ?? 0;
    final sb = scoreTrick(
      trick: trick,
      timing: timing,
      speed: speed,
      streak: stats.streak,
      previousCount: prev,
      airHeight: maxAirHeight,
      proMode: proMode,
      dailyTokenId: dailyTokenId,
    );
    stats.trickCounts[trick.key] = prev + 1;
    stats.score += sb.total;
    stats.landed++;
    stats.streak++;
    stats.maxStreak = math.max(stats.maxStreak, stats.streak);
    stats.timingSum += switch (timing) {
      Timing.perfect => 1.0,
      Timing.good => 2 / 3,
      _ => 1 / 3,
    };
    if (sb.total > stats.bestTrickPoints) {
      stats.bestTrickPoints = sb.total;
      stats.bestTrick = trick.name;
    }

    speed += switch (timing) {
      Timing.perfect => config.gainPerfect,
      Timing.good => config.gainGood,
      _ => -config.lossLate,
    };
    speed += config.gainPerGrade * trick.grade;
    speed = speed.clamp(0.0, 1.0);

    _events.add(RideEvent(RideEventType.landed, time, timing: timing, trick: trick, score: sb));
  }

  void _bail(BailReason reason, double atS) {
    bailReason = reason;
    stats.streak = 0;
    phase = RidePhase.bail;
    _phaseStart = time;
    _bailS = atS;
    _bailDir = atS > ramp.length / 2 ? -1 : 1;
    _events.add(RideEvent(RideEventType.bail, time, bailReason: reason));
  }

  // ── Input judgement ───────────────────────────────────────────────────

  void _processInputs(double until) {
    while (_nextInput < inputs.length && inputs[_nextInput].t <= until) {
      _judge(inputs[_nextInput++]);
    }
  }

  void _judge(ReleaseInput input) {
    if (phase != RidePhase.rolling && phase != RidePhase.air && phase != RidePhase.dropIn) {
      return;
    }
    if (_attempt != null) return;
    final parse = parser.parse(input.nodes);
    if (parse.error == ParseError.tooShort) return; // stray tap / palm
    final t = input.t - config.inputLatency;
    final d = t - tEdge;
    if (d < -config.cueLead) {
      _events.add(RideEvent(RideEventType.tooEarly, time));
      return;
    }
    final Timing timing;
    if (d.abs() <= perfectWindow) {
      timing = Timing.perfect;
    } else if (d.abs() <= goodWindow) {
      timing = Timing.good;
    } else if (d > 0 && d <= lateWindow) {
      timing = Timing.late;
    } else {
      timing = Timing.miss;
    }
    _attempt = _Attempt(timing, parse, math.max(t, tEdge));
    _events.add(
      RideEvent(RideEventType.judged, time, timing: timing, trick: parse.trick, parseError: parse.error, delta: d),
    );
  }

  // ── Trick playback ────────────────────────────────────────────────────

  double tokenDuration(TrickToken t) => t.moves * config.secondsPerMove + config.secondsPerToken;

  double trickDuration(ParsedTrick trick) => trick.tokens.fold(0.0, (s, t) => s + tokenDuration(t));

  int _halfSpins(ParsedTrick trick) =>
      trick.tokens.where((t) => t.kind == TokenKind.spin).fold(0, (s, t) => s + t.degrees ~/ 180);

  /// Fastest launch speed (normalised) at which [trick] still fits the air
  /// when started exactly on the edge. > 1 means it never fits.
  double speedNeeded(ParsedTrick trick) {
    final v = trickDuration(trick) * config.gravity / 2;
    return (v - config.vLow) / (config.vHigh - config.vLow);
  }

  // ── Pose ──────────────────────────────────────────────────────────────

  SkaterPose get pose {
    switch (phase) {
      case RidePhase.dropIn:
        final c = ramp.coping(-1);
        final k = ((time - (segStart - 0.25)) / 0.25).clamp(0.0, 1.0);
        return SkaterPose(x: c.x - 0.45 * (1 - k), y: c.y, angle: -k * math.pi / 2, facing: 1, crouch: 0.3 * k);
      case RidePhase.rolling:
        final s = pathS;
        final p = ramp.point(s);
        final h = p.y / ramp.copingHeight;
        return SkaterPose(
          x: p.x,
          y: p.y,
          angle: ramp.tangent(s),
          facing: (dir * stance).toDouble(),
          crouch: 0.15 + 0.35 * (1 - h) * (1 - h),
        );
      case RidePhase.air:
        return _airPose();
      case RidePhase.bail:
        final k = ((time - _phaseStart) / config.bailDuration).clamp(0.0, 1.0);
        final s = (_bailS + _bailDir * 4.0 * (1 - math.exp(-3 * k))).clamp(0.0, ramp.length);
        final p = ramp.point(s);
        return SkaterPose(x: p.x, y: p.y, angle: ramp.tangent(s), facing: _bailDir.toDouble(), bail: k);
      case RidePhase.rollout:
      case RidePhase.finished:
        final tau = time - _phaseStart;
        final half = ramp.length / 2;
        final amp = half * 0.85 * math.exp(-tau / 0.9);
        final edge = dir > 0 ? 1.0 : -1.0;
        final s = half + edge * amp * math.cos(2 * math.pi * tau / 2.4);
        final p = ramp.point(s);
        final moving = -edge * math.sin(2 * math.pi * tau / 2.4);
        return SkaterPose(
          x: p.x,
          y: p.y,
          angle: ramp.tangent(s),
          facing: (moving >= 0 ? 1.0 : -1.0) * stance,
          crouch: 0.1,
        );
    }
  }

  SkaterPose _airPose() {
    final tau = time - tEdge;
    final u = (tau / airDuration).clamp(0.0, 1.0);
    final c = ramp.coping(dir);
    final exit = dir > 0 ? math.pi / 2 : -math.pi / 2;
    final angle = exit - dir * (math.pi / 2) * math.sin(math.pi * u);

    var spin = 0.0;
    var roll = 0.0;
    var shove = 0.0;
    var tumble = 0.0;
    var flip = 0.0;
    var grab = 0.0;
    var look = const GrabLook();
    final a = _attempt;
    if (a != null && a.parse.ok) {
      var t0 = a.tStart;
      for (final tok in a.parse.trick!.tokens) {
        final dur = tokenDuration(tok);
        final k = ((time - t0) / dur).clamp(0.0, 1.0);
        switch (tok.kind) {
          case TokenKind.spin:
            spin += k * tok.degrees * math.pi / 180;
          case TokenKind.flip:
            final f = tok.flipLook;
            final e = _ease(k);
            roll += e * f.roll;
            shove += e * f.shove;
            tumble += e * f.tumble;
            if (k > 0 && k < 1) flip = math.sin(math.pi * k);
          case TokenKind.grab:
            if (k > 0 && k < 1) {
              grab = math.sin(math.pi * k);
              look = tok.grabLook;
            }
        }
        t0 += dur;
      }
    }
    return SkaterPose(
      x: c.x + dir * 0.15 * math.sin(math.pi * u),
      y: c.y + airHeight,
      angle: angle,
      facing: dir * stance * math.cos(math.pi * u + spin),
      roll: roll,
      shove: shove,
      tumble: tumble,
      flip: flip,
      grab: grab,
      grabLook: look,
      crouch: 0.25 + 0.3 * flip + 0.4 * grab,
    );
  }

  /// Smoothstep, so the board snaps out of and back under the feet.
  static double _ease(double k) => k * k * (3 - 2 * k);

  // ── Replay ────────────────────────────────────────────────────────────

  Map<String, dynamic> replayJson() => {
    'v': 1,
    'pro': proMode,
    'daily': dailyTokenId,
    'inputs': [for (final i in inputs) i.toJson()],
  };
}
