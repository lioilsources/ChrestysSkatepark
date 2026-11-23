// Golden vectors for the Babylon.js web client (../babylon/).
//
// Runs the pure Dart rules (lib/core/) over fixed inputs and writes what they
// produce to ../babylon/test/golden/. Vitest replays the same inputs through
// the TypeScript port and expects the same output (plan 06, phase F1).
//
//   cd rattleramp && dart run tool/dump_vectors.dart
//
// Deterministic: no clock, no Random() without a seed. Rerunning on unchanged
// Dart code must give byte-identical files.
import 'dart:convert';
import 'dart:io';

import 'package:rattleramp/core/grid.dart';
import 'package:rattleramp/core/ride_config.dart';
import 'package:rattleramp/core/ride_sim.dart';
import 'package:rattleramp/core/scoring.dart';
import 'package:rattleramp/core/trick_defs.dart';
import 'package:rattleramp/core/trick_parser.dart';

final TrickBook book = TrickBook.fromJson(File('assets/tricks.json').readAsStringSync());
final TrickParser parser = TrickParser(book);
const outDir = '../babylon/test/golden';

/// Small seeded LCG so the vectors don't depend on dart:math Random internals.
class Lcg {
  int _s;
  Lcg(int seed) : _s = seed & 0x7fffffff;
  int next(int n) {
    _s = (_s * 1103515245 + 12345) & 0x7fffffff;
    return _s % n;
  }

  T pick<T>(List<T> l) => l[next(l.length)];
  double unit() => next(1 << 30) / (1 << 30);
}

void write(String name, Object json) {
  final f = File('$outDir/$name');
  f.parent.createSync(recursive: true);
  f.writeAsStringSync('${const JsonEncoder.withIndent(null).convert(json)}\n');
  stdout.writeln('wrote ${f.path} (${f.lengthSync()} B)');
}

/// "fs180+indy", "fs180+indy#combo" or "!errorName".
String parseCode(List<int> nodes) {
  final r = parser.parse(nodes);
  if (!r.ok) return '!${r.error!.name}';
  final t = r.trick!;
  final ids = t.tokens.map((x) => x.id).join('+');
  return t.combo == null ? ids : '$ids#${t.combo!.id}';
}

// ── Parser ──────────────────────────────────────────────────────────────

List<List<int>> drawings(TrickToken t) => t.kind == TokenKind.spin
    ? [for (final n in ringOrder) TrickBook.ringPath(n, t.degrees ~/ 45, clockwise: t.frontside)]
    : [t.path];

bool merges(TrickToken a, TrickToken b) =>
    (a.kind == TokenKind.flip && b.kind == TokenKind.flip) ||
    (a.kind == TokenKind.spin && b.kind == TokenKind.spin && a.frontside == b.frontside);

Iterable<List<int>> chains(List<TrickToken> seq, [List<int>? prefix]) sync* {
  if (seq.isEmpty) {
    yield prefix!;
    return;
  }
  for (final d in drawings(seq.first)) {
    if (prefix != null && prefix.last != d.first) continue;
    yield* chains(seq.sublist(1), prefix == null ? d : [...prefix, ...d.sublist(1)]);
  }
}

List<int> neighbours(int n) => [
  for (var m = 0; m < 9; m++)
    if (areAdjacent(n, m)) m,
];

Map<String, String> parserVectors() {
  final out = <String, String>{};
  void add(List<int> p) => out[p.join()] = parseCode(p);

  // Every walk on the grid graph with 0…5 moves (all error kinds, all short tricks).
  void walk(List<int> p) {
    add(p);
    if (p.length == 6) return;
    for (final m in neighbours(p.last)) {
      walk([...p, m]);
    }
  }

  for (var n = 0; n < 9; n++) {
    walk([n]);
  }

  // Every chainable sequence of up to 3 tokens (as in test/trick_parser_test.dart).
  final all = book.allTokens;
  for (final a in all) {
    chains([a]).forEach(add);
    for (final b in all) {
      if (merges(a, b)) continue;
      chains([a, b]).forEach(add);
      for (final c in all) {
        if (merges(b, c)) continue;
        chains([a, b, c]).forEach(add);
      }
    }
  }
  for (final c in book.combos) {
    chains([for (final id in c.tokens) book.token(id)!]).forEach(add);
  }

  // Long random walks (sloppy fingers, spins past 1080) and a few broken ones.
  final rng = Lcg(6);
  for (var k = 0; k < 3000; k++) {
    final p = [rng.next(9)];
    final len = 7 + rng.next(30);
    while (p.length < len) {
      p.add(rng.pick(neighbours(p.last)));
    }
    if (k % 10 == 0) p[rng.next(p.length)] = rng.next(9); // may break continuity or repeat a node
    add(p);
  }
  return out;
}

// ── Scoring ─────────────────────────────────────────────────────────────

List<Map<String, dynamic>> scoringVectors() {
  final rng = Lcg(9);
  final patterns = <List<int>>[
    for (final t in book.allTokens) t.path,
    for (final c in book.combos) chains([for (final id in c.tokens) book.token(id)!]).first,
    [3, 4, 5, 8, 7, 6, 3, 0, 1, 2, 5],
    [3, 1, 5, 4, 3],
    TrickBook.ringPath(1, 30, clockwise: true),
  ];
  const speeds = [-0.2, 0.0, 0.1, 1 / 3, 0.4, 0.55, 0.999, 1.0, 1.3];
  const airs = [0.0, 0.5, 0.8, 0.8001, 0.81, 1.0, 1.2345, 2.2, 3.0];
  final dailies = [null, ...book.grabs.take(4).map((t) => t.id), ...book.flips.take(4).map((t) => t.id), 'fs540'];
  final out = <Map<String, dynamic>>[];
  for (var k = 0; k < 1500; k++) {
    final nodes = rng.pick(patterns);
    final trick = parser.parse(nodes).trick!;
    final timing = Timing.values[rng.next(4)];
    final speed = rng.next(3) == 0 ? rng.unit() * 1.2 - 0.1 : rng.pick(speeds);
    final streak = rng.next(25);
    final prev = rng.next(4);
    final air = rng.next(3) == 0 ? rng.unit() * 3 : rng.pick(airs);
    final pro = rng.next(3) == 0;
    final daily = rng.pick(dailies);
    final s = scoreTrick(
      trick: trick,
      timing: timing,
      speed: speed,
      streak: streak,
      previousCount: prev,
      airHeight: air,
      proMode: pro,
      dailyTokenId: daily,
    );
    out.add({
      'in': {
        'n': nodes,
        'timing': timing.name,
        'speed': speed,
        'streak': streak,
        'prev': prev,
        'air': air,
        'pro': pro,
        'daily': daily,
      },
      'out': {
        'base': s.base,
        'timing': s.timing,
        'speed': s.speed,
        'combo': s.combo,
        'variety': s.variety,
        'daily': s.daily,
        'airBonus': s.airBonus,
        'total': s.total,
      },
    });
  }
  return out;
}

// ── Trick book, grades, daily trick ─────────────────────────────────────

Map<String, dynamic> bookVectors() {
  Map<String, dynamic> tok(TrickToken t) => {
    'id': t.id,
    'name': t.name,
    'kind': t.kind.name,
    'base': t.base,
    'path': t.path,
    'degrees': t.degrees,
    'frontside': t.frontside,
    'grab': {
      'hand': t.grabLook.hand.name,
      'at': t.grabLook.at,
      'style': t.grabLook.style.name,
      'tilt': t.grabLook.tilt,
    },
    'flip': {'roll': t.flipLook.roll, 'shove': t.flipLook.shove, 'tumble': t.flipLook.tumble},
  };
  final daily = <String, String>{};
  for (var d = DateTime.utc(2024, 1, 1); d.year < 2034; d = d.add(const Duration(days: 1))) {
    final key = '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    daily[key] = dailyToken(book, DateTime(d.year, d.month, d.day, 13)).id;
  }
  return {
    'tokens': [for (final t in book.allTokens) tok(t)],
    'combos': {for (final c in book.combos) c.id: book.comboPath(c)},
    'grades': [for (var m = 0; m <= 40; m++) trickGrade(m)],
    'daily': daily,
  };
}

// ── Ride simulation ─────────────────────────────────────────────────────

class Scenario {
  final String id;
  final int seed;
  final RideConfig config;
  final bool pro;
  final String? daily;
  final bool poses;
  const Scenario(this.id, this.seed, this.config, {this.pro = false, this.daily, this.poses = false});
}

/// Patterns the scripted player can swipe: tricks of every length, combos,
/// unknown/broken patterns and stray taps.
final List<List<int>> playerPatterns = [
  for (final t in book.allTokens) t.path,
  for (final c in book.combos) chains([for (final id in c.tokens) book.token(id)!]).first,
  [3, 4, 5, 8, 7, 6, 3, 0, 1, 2, 5],
  [3, 1, 5, 4, 3],
  [0, 4, 0],
  [1, 3, 1],
  [0, 1, 4],
  [0, 2, 5],
  [4],
  [3, 4],
  TrickBook.ringPath(1, 30, clockwise: true),
];

/// Release offsets relative to the edge, in seconds.
const List<double> offsets = [
  -1.4,
  -0.9,
  -0.3,
  -0.12,
  -0.06,
  -0.03,
  -0.01,
  0,
  0.01,
  0.04,
  0.07,
  0.1,
  0.13,
  0.18,
  0.25,
  0.4,
];

/// Plays a scripted ride: on each new rolling segment maybe swipe something,
/// sometimes twice, sometimes in the air. Returns the recorded input log.
List<ReleaseInput> scriptedInputs(Scenario s) {
  final rng = Lcg(s.seed);
  final sim = RideSim(config: s.config, parser: parser, proMode: s.pro, dailyTokenId: s.daily);
  var seg = -1.0;
  var last = 0.0;
  void release(double t, List<int> n) {
    t = t < last ? last : t;
    last = t;
    sim.addInput(ReleaseInput(t, n));
  }

  while (!sim.finished && sim.time < 300) {
    if ((sim.phase == RidePhase.rolling || sim.phase == RidePhase.dropIn) && sim.segStart != seg) {
      seg = sim.segStart;
      final roll = rng.next(20);
      if (roll >= 2) {
        // Mostly good players: bias towards the timing windows.
        final off = rng.next(3) == 0 ? rng.pick(offsets) : (rng.unit() - 0.5) * 0.12;
        final n = rng.next(4) == 0
            ? rng.pick(playerPatterns)
            : rng.pick(playerPatterns.take(book.allTokens.length).toList());
        release(sim.tEdge + off + s.config.inputLatency, n);
        if (roll == 19) release(sim.tEdge + off + 0.05, rng.pick(playerPatterns)); // second swipe, ignored
      }
    }
    sim.step();
    sim.drainEvents();
  }
  return List.of(sim.inputs);
}

Map<String, dynamic> eventJson(RideEvent e) => {
  'type': e.type.name,
  't': e.t,
  if (e.timing != null) 'timing': e.timing!.name,
  if (e.trick != null) 'trick': e.trick!.key,
  if (e.score != null) 'score': e.score!.total,
  if (e.bailReason != null) 'bail': e.bailReason!.name,
  if (e.parseError != null) 'parseError': e.parseError!.name,
  if (e.delta != null) 'delta': e.delta,
};

Map<String, dynamic> rideVector(Scenario s) {
  final inputs = scriptedInputs(s);
  final sim = RideSim(config: s.config, parser: parser, proMode: s.pro, dailyTokenId: s.daily);
  inputs.forEach(sim.addInput);
  final events = <Map<String, dynamic>>[];
  final segments = <Map<String, dynamic>>[];
  final poses = <List<double>>[];
  var seg = double.nan;
  var tick = 0;
  void snapSegment() {
    if (sim.segStart == seg) return;
    seg = sim.segStart;
    segments.add({
      'time': sim.time,
      'segStart': sim.segStart,
      'tEdge': sim.tEdge,
      'tLand': sim.tLand,
      'speed': sim.speed,
      'dir': sim.dir,
      'stance': sim.stance,
      'maxAir': sim.maxAirHeight,
    });
  }

  snapSegment();
  while (!sim.finished && sim.time < 300) {
    sim.step();
    tick++;
    events.addAll(sim.drainEvents().map(eventJson));
    snapSegment();
    if (s.poses && tick % 5 == 0) {
      final p = sim.pose;
      poses.add([sim.time, p.x, p.y, p.angle, p.facing, p.roll, p.shove, p.tumble, p.flip, p.grab, p.crouch, p.bail]);
    }
  }
  final st = sim.stats;
  return {
    'id': s.id,
    'config': {
      'startSpeed': s.config.startSpeed,
      'windowScale': s.config.windowScale,
      'inputLatency': s.config.inputLatency,
      'cueLead': s.config.cueLead,
    },
    'replay': sim.replayJson(),
    'ticks': tick,
    'events': events,
    'segments': segments,
    'stats': {
      'score': st.score,
      'landed': st.landed,
      'streak': st.streak,
      'maxStreak': st.maxStreak,
      'bestTrick': st.bestTrick,
      'bestTrickPoints': st.bestTrickPoints,
      'averageTiming': st.averageTiming,
      'trickCounts': st.trickCounts,
      'bailReason': sim.bailReason?.name,
    },
    if (s.poses) 'poses': poses,
  };
}

List<Map<String, dynamic>> rideVectors() {
  const c = RideConfig();
  final scenarios = <Scenario>[
    const Scenario('empty', 1, c, poses: true),
    for (var i = 0; i < 24; i++)
      Scenario(
        'seed$i',
        100 + i,
        c.copyWith(
          startSpeed: const [0.4, 0.0, 0.25, 0.7, 1.0][i % 5],
          windowScale: const [1.0, 1.0, 1.4, 0.8][i % 4],
          inputLatency: i % 6 == 5 ? 0.03 : 0.0,
          cueLead: i % 7 == 6 ? 0.6 : 1.0,
        ),
        pro: i % 3 == 2,
        daily: i % 4 == 1
            ? book.grabs[i % book.grabs.length].id
            : (i % 4 == 3 ? book.flips[i % book.flips.length].id : null),
        poses: i < 6,
      ),
  ];
  return [for (final s in scenarios) rideVector(s)];
}

void main() {
  write('book.json', bookVectors());
  write('parser.json', parserVectors());
  write('scoring.json', scoringVectors());
  write('rides.json', rideVectors());
}
