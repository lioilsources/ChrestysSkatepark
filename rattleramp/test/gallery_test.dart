import 'dart:io';
import 'dart:ui' as ui;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/ride_config.dart';
import 'package:rattleramp/core/ride_sim.dart';
import 'package:rattleramp/core/trick_defs.dart';
import 'package:rattleramp/game/rattle_game.dart';
import 'package:rattleramp/ui/theme.dart';

import 'helpers.dart';

void main() {
  // Contact sheet of every grab and flip, zoomed on the skater:
  //   SNAP_DIR=/some/dir flutter test test/gallery_test.dart
  final out = Platform.environment['SNAP_DIR'];
  testWidgets('trick gallery', skip: out == null, (tester) async {
    const cell = 220.0;
    const fracs = [0.2, 0.4, 0.6, 0.8];
    final rows = [
      for (final t in book.grabs) (t, const [0.5]),
      for (final t in book.flips) (t, fracs),
    ];
    final w = (cell * fracs.length).toInt(), h = (cell * rows.length).toInt();

    final rec = ui.PictureRecorder();
    final canvas = ui.Canvas(rec)
      ..drawRect(Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()), Paint()..color = Palette.night);
    for (var row = 0; row < rows.length; row++) {
      final (TrickToken token, List<double> at) = rows[row];
      for (var col = 0; col < at.length; col++) {
        final game = RattleGame(book: book, config: const RideConfig(startSpeed: 1));
        game.onGameResize(Vector2(cell, cell));
        await game.onLoad();
        game.startRide();
        final sim = game.sim;
        sim.addInput(ReleaseInput(sim.tEdge, token.path));
        final target = sim.tEdge + at[col] * sim.tokenDuration(token);
        while (sim.time < target) {
          game.update(1 / 120);
        }
        final pose = sim.pose;
        const k = 70.0;
        game.view
          ..scale = Vector2(k, -k)
          ..position = Vector2(-pose.x * k, pose.y * k);
        // Upright: undo the air rotation so poses compare side by side.
        canvas.save();
        canvas.translate(col * cell, row * cell);
        canvas.clipRect(const Rect.fromLTWH(0, 0, cell, cell));
        canvas.translate(cell / 2, cell * 0.7);
        canvas.rotate(pose.angle);
        game.render(canvas);
        canvas.restore();
      }
      final label = TextPainter(
        text: TextSpan(text: token.name, style: hudStyle.copyWith(fontSize: 16)),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(canvas, Offset(8, row * cell + 6));
    }
    final img = await tester.runAsync(() => rec.endRecording().toImage(w, h));
    final bytes = await tester.runAsync(() => img!.toByteData(format: ui.ImageByteFormat.png));
    File('$out/gallery.png').writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}
