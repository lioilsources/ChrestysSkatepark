import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/painting.dart';

import '../core/avatar.dart';
import '../core/ride_config.dart';
import '../core/ride_sim.dart';
import '../core/trick_defs.dart';
import '../core/trick_parser.dart';
import '../ui/theme.dart';
import 'avatar_sprites.dart';
import 'cue_component.dart';
import 'ramp_component.dart';
import 'skater_component.dart';
import 'style_paint.dart';

/// Hosts one [RideSim] and renders it. All gameplay lives in the sim; this
/// class only steps it at a fixed rate, maps wall-clock releases to ride
/// time and draws.
class RattleGame extends FlameGame {
  final TrickBook book;
  final TrickParser parser;
  RideConfig config;

  /// Attract-mode demo rider: releases a random feasible trick on every edge.
  final bool autopilot;

  void Function(RideEvent e)? onEvent;
  void Function(RideSim sim)? onFinished;

  late RideSim sim;
  late final WorldView view;

  double _acc = 0;
  final Stopwatch _clock = Stopwatch()..start();
  int _wallAtUpdate = 0;
  double _lastInputT = 0;
  bool _finishedReported = false;
  double _botSegment = -1;
  final math.Random _rng = math.Random();

  Rect? _worldRect;

  Avatar avatar;
  final AvatarSprites sprites;

  RattleGame({
    required this.book,
    required this.config,
    this.autopilot = false,
    Avatar? avatar,
    this.sprites = AvatarSprites.empty,
  }) : avatar = avatar ?? Avatar.initial,
       parser = TrickParser(book) {
    sim = RideSim(config: config, parser: parser);
  }

  void startRide({bool proMode = false, String? dailyTokenId}) {
    sim = RideSim(config: config, parser: parser, proMode: proMode, dailyTokenId: dailyTokenId);
    _acc = 0;
    _lastInputT = 0;
    _finishedReported = false;
    _botSegment = -1;
  }

  /// Screen rectangle (logical px) the ramp should fit into.
  void setWorldRect(Rect r) {
    _worldRect = r;
    if (isLoaded) view.fit(r);
  }

  @override
  Color backgroundColor() => Palette.night;

  @override
  Future<void> onLoad() async {
    view = WorldView(this);
    view.addAll([RampComponent(this), CueComponent(this), SkaterComponent(this)]);
    add(BackdropComponent(this));
    add(view);
    view.fit(_worldRect ?? Offset.zero & size.toSize());
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isLoaded) view.fit(_worldRect ?? Offset.zero & size.toSize());
  }

  /// Pixel style: draw the whole game at 1/n resolution, then blow it up
  /// with nearest-neighbour sampling.
  @override
  void render(Canvas canvas) {
    final n = Palette.spec.pixel;
    if (n <= 1 || size.x < 1 || size.y < 1) return super.render(canvas);
    final w = (size.x / n).ceil(), h = (size.y / n).ceil();
    final rec = ui.PictureRecorder();
    final low = Canvas(rec)..scale(1 / n);
    super.render(low);
    final img = rec.endRecording().toImageSync(w, h);
    canvas.save();
    canvas.scale(n.toDouble());
    canvas.drawImage(img, Offset.zero, Paint()..filterQuality = FilterQuality.none);
    canvas.restore();
    img.dispose();
  }

  /// Ride time "now", interpolated between fixed ticks with the wall clock.
  double get rideNow => sim.time + _acc + (_clock.elapsedMicroseconds - _wallAtUpdate) / 1e6;

  void release(List<int> nodes) {
    if (autopilot || sim.finished) return;
    final t = math.max(rideNow, math.max(_lastInputT, sim.time));
    _lastInputT = t;
    sim.addInput(ReleaseInput(t, nodes));
  }

  @override
  void update(double dt) {
    super.update(dt);
    _wallAtUpdate = _clock.elapsedMicroseconds;
    _acc += math.min(dt, 0.1);
    while (_acc >= config.dt) {
      _acc -= config.dt;
      if (autopilot) _botTick();
      sim.step();
      for (final e in sim.drainEvents()) {
        onEvent?.call(e);
      }
    }
    if (sim.finished && !_finishedReported) {
      _finishedReported = true;
      if (autopilot) {
        // Attract loop shows off a different character every run.
        avatar = Avatar.of(presets[_rng.nextInt(presets.length)]);
        startRide();
      } else {
        onFinished?.call(sim);
      }
    }
  }

  void _botTick() {
    if (sim.phase != RidePhase.rolling && sim.phase != RidePhase.dropIn) return;
    if (_botSegment == sim.segStart) return;
    _botSegment = sim.segStart;
    final options = <List<int>>[];
    for (final t in book.allTokens) {
      final p = parser.parse(t.path).trick!;
      if (sim.speedNeeded(p) < sim.speed - 0.05) options.add(t.path);
    }
    for (final c in book.combos) {
      final path = book.comboPath(c);
      if (path != null && sim.speedNeeded(parser.parse(path).trick!) < sim.speed - 0.05) options.add(path);
    }
    if (options.isEmpty) return;
    final jitter = (_rng.nextDouble() - 0.5) * 0.07;
    sim.addInput(ReleaseInput(sim.tEdge + jitter, options[_rng.nextInt(options.length)]));
  }
}

/// World container: children draw in metres with y up.
class WorldView extends PositionComponent {
  final RattleGame game;
  WorldView(this.game);

  double get worldWidth => 2 * (game.sim.ramp.copingX + 1.2);
  double get worldBottom => -0.4;
  double get worldTop =>
      game.config.copingHeight + game.config.vHigh * game.config.vHigh / (2 * game.config.gravity) + 0.5;

  void fit(Rect r) {
    final h = worldTop - worldBottom;
    final k = math.min(r.width / worldWidth, r.height / h);
    scale = Vector2(k, -k);
    position = Vector2(r.center.dx, r.center.dy + (h / 2 + worldBottom) * k);
  }
}
