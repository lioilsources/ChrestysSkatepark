import 'dart:io';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/ride_config.dart';
import 'package:rattleramp/core/ride_sim.dart';
import 'package:rattleramp/game/rattle_game.dart';

import 'helpers.dart';

void main() {
  // Visual check of the Flame layer without a device:
  //   SNAP_DIR=/some/dir flutter test test/snapshot_test.dart
  final out = Platform.environment['SNAP_DIR'];
  testWidgets('snapshots', skip: out == null, (tester) async {
    final game = RattleGame(book: book, config: const RideConfig());
    game.onGameResize(Vector2(1280, 800));
    await game.onLoad();
    game.view.fit(const ui.Rect.fromLTWH(12, 64, 860, 620));
    game.startRide();
    final sim = game.sim;
    sim.addInput(ReleaseInput(sim.tEdge, [0, 4, 2, 1, 0, 3, 6, 7, 8, 5, 2, 1, 0, 3, 6, 7]));
    final times = [
      0.3,
      1.2,
      sim.tEdge - 0.5,
      sim.tEdge + 0.15,
      sim.tEdge + 0.3,
      sim.tEdge + 0.5,
      sim.tLand - 0.05,
      sim.tLand + 0.6,
    ];
    var i = 0;
    for (final t in times) {
      while (game.sim.time < t) {
        game.update(1 / 120);
      }
      final rec = ui.PictureRecorder();
      final c = ui.Canvas(rec);
      game.render(c);
      final img = await tester.runAsync(() => rec.endRecording().toImage(1280, 800));
      final bytes = await tester.runAsync(() => img!.toByteData(format: ui.ImageByteFormat.png));
      File('$out/f${i++}_${game.sim.phase.name}.png').writeAsBytesSync(bytes!.buffer.asUint8List());
    }
    // ignore: avoid_print
    print('speed ${sim.speed} tEdge ${sim.tEdge} air ${sim.airDuration} score ${sim.stats.score}');
  });
}
