import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/ride_config.dart';
import 'package:rattleramp/core/ride_sim.dart';
import 'package:rattleramp/core/scoring.dart';
import 'package:rattleramp/core/trick_defs.dart';

import 'helpers.dart';

const indy = [3, 4, 5];
final fs360 = TrickBook.ringPath(1, 8, clockwise: true);

RideSim newSim() => RideSim(config: const RideConfig(), parser: parser);

/// Steps until the skater lands (or the ride stops), returning events.
List<RideEvent> runUntilLanding(RideSim sim) {
  final out = <RideEvent>[];
  while (!sim.finished) {
    sim.step();
    final ev = sim.drainEvents();
    out.addAll(ev);
    if (ev.any((e) => const {RideEventType.landed, RideEventType.emptyAir, RideEventType.bail}.contains(e.type))) break;
  }
  return out;
}

void main() {
  test('no input: speed bleeds off and the ride ends without a bail', () {
    final sim = newSim()..runToEnd();
    final events = sim.drainEvents();
    expect(events.where((e) => e.type == RideEventType.emptyAir), hasLength(3));
    expect(events.any((e) => e.type == RideEventType.outOfSpeed), isTrue);
    expect(events.any((e) => e.type == RideEventType.bail), isFalse);
    expect(sim.finished, isTrue);
  });

  test('perfect release on the edge lands the trick and adds speed', () {
    final sim = newSim();
    final s0 = sim.speed;
    sim.addInput(ReleaseInput(sim.tEdge, fs360));
    final ev = runUntilLanding(sim);
    final landed = ev.singleWhere((e) => e.type == RideEventType.landed);
    expect(landed.timing, Timing.perfect);
    expect(landed.trick!.name, 'FS 360');
    expect(sim.stats.score, landed.score!.total);
    expect(sim.speed, greaterThan(s0));
    expect(sim.dir, -1);
  });

  test('timing windows: good, late, early miss, late miss', () {
    Timing judge(double offset) {
      final sim = newSim();
      sim.addInput(ReleaseInput(sim.tEdge + offset, indy));
      return runUntilLanding(sim).firstWhere((e) => e.type == RideEventType.judged).timing!;
    }

    expect(judge(0.0), Timing.perfect);
    expect(judge(-0.08), Timing.good);
    expect(judge(0.08), Timing.good);
    expect(judge(0.15), Timing.late);
    expect(judge(-0.3), Timing.miss);
    expect(judge(0.3), Timing.miss);
  });

  test('early miss bails at the edge', () {
    final sim = newSim();
    sim.addInput(ReleaseInput(sim.tEdge - 0.4, indy));
    final ev = runUntilLanding(sim);
    final bail = ev.singleWhere((e) => e.type == RideEventType.bail);
    expect(bail.bailReason, BailReason.timingMiss);
    expect(bail.t, closeTo(sim.tEdge, 1e-9));
  });

  test('releasing before the cue is ignored, a later try still counts', () {
    final sim = newSim();
    sim.addInput(ReleaseInput(sim.tEdge - 1.5, indy));
    sim.addInput(ReleaseInput(sim.tEdge, indy));
    final ev = runUntilLanding(sim);
    expect(ev.first.type, RideEventType.tooEarly);
    expect(ev.any((e) => e.type == RideEventType.landed), isTrue);
  });

  test('wrong pattern bails', () {
    final sim = newSim();
    sim.addInput(ReleaseInput(sim.tEdge, [1, 3, 1]));
    final bail = runUntilLanding(sim).singleWhere((e) => e.type == RideEventType.bail);
    expect(bail.bailReason, BailReason.badPattern);
  });

  test('a trick longer than the air bails on landing', () {
    final sim = newSim();
    final p = TrickBook.ringPath(1, 24, clockwise: true); // 1080 at start speed
    expect(sim.speedNeeded(parser.parse(p).trick!), greaterThan(sim.speed));
    sim.addInput(ReleaseInput(sim.tEdge, p));
    final bail = runUntilLanding(sim).singleWhere((e) => e.type == RideEventType.bail);
    expect(bail.bailReason, BailReason.trickTooLong);
    expect(bail.t, closeTo(sim.tLand, 1e-9));
  });

  test('speed shrinks timing windows', () {
    final sim = newSim();
    final slow = sim.goodWindow;
    sim.speed = 1;
    expect(sim.goodWindow, lessThan(slow));
  });

  test('repeating a trick scores less (variety)', () {
    final sim = newSim();
    final points = <int>[];
    for (var i = 0; i < 3; i++) {
      sim.addInput(ReleaseInput(sim.tEdge, indy));
      points.add(runUntilLanding(sim).singleWhere((e) => e.type == RideEventType.landed).score!.total);
    }
    expect(points[1], lessThan(points[0]));
    expect(points[2], lessThan(points[1]));
    expect(sim.stats.maxStreak, 3);
  });

  test('replay from the input log reproduces the ride exactly', () {
    final sim = newSim();
    final tricks = [
      indy,
      fs360,
      [0, 4, 2],
      [3, 1, 5],
      indy,
    ];
    final offsets = [0.0, 0.03, -0.06, 0.12, 0.01];
    for (var i = 0; i < tricks.length; i++) {
      sim.addInput(ReleaseInput(sim.tEdge + offsets[i], tricks[i]));
      runUntilLanding(sim);
    }
    sim.runToEnd();
    final json = jsonDecode(jsonEncode(sim.replayJson())) as Map<String, dynamic>;

    final replay = RideSim(config: const RideConfig(), parser: parser, proMode: json['pro'] as bool);
    for (final i in (json['inputs'] as List).cast<Map<String, dynamic>>()) {
      replay.addInput(ReleaseInput.fromJson(i));
    }
    replay.runToEnd();
    expect(replay.stats.score, sim.stats.score);
    expect(replay.stats.landed, 5);
    expect(replay.time, sim.time);
    expect(jsonEncode(replay.replayJson()).length, lessThan(600));
  });

  test('pose stays on the ramp surface while rolling', () {
    final sim = newSim();
    while (sim.phase != RidePhase.air) {
      sim.step();
      if (sim.phase == RidePhase.rolling) {
        final p = sim.pose;
        final r = sim.ramp.point(sim.pathS);
        expect(p.x, closeTo(r.x, 1e-9));
        expect(p.y, closeTo(r.y, 1e-9));
      }
    }
  });
}
