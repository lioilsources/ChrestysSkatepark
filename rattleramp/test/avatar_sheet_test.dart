import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/avatar.dart';
import 'package:rattleramp/core/ride_sim.dart';
import 'package:rattleramp/core/trick_defs.dart';
import 'package:rattleramp/game/avatar_sprites.dart';
import 'package:rattleramp/game/skater_component.dart';
import 'package:rattleramp/ui/theme.dart';

void main() {
  // Every preset in a few poses, per art style:
  //   SNAP_DIR=/some/dir flutter test test/avatar_sheet_test.dart
  final out = Platform.environment['SNAP_DIR'];
  testWidgets('avatar sheet', skip: out == null, (tester) async {
    final sprites = (await tester.runAsync(() => AvatarSprites.load(rootBundle)))!;
    const poses = [
      SkaterPose(x: 0, y: 0, angle: 0, facing: 1, crouch: 0.2),
      SkaterPose(x: 0, y: 0, angle: 0, facing: 1, crouch: 0.65, grab: 1, grabLook: GrabLook(hand: GrabHand.back)),
      SkaterPose(x: 0, y: 0, angle: 0, facing: 1, crouch: 0.6, grab: 1, grabLook: GrabLook(style: GrabStyle.spread)),
      SkaterPose(x: 0, y: 0, angle: 0, facing: 1, crouch: 0.5, roll: 0.62, flip: 1),
    ];
    const cell = 240.0;
    for (final style in [ArtStyle.neon, ArtStyle.comic]) {
      Palette.style = style;
      final rec = ui.PictureRecorder();
      final c = ui.Canvas(rec);
      c.drawRect(Rect.fromLTWH(0, 0, cell * poses.length, cell * presets.length), Paint()..color = Palette.night);
      for (var r = 0; r < presets.length; r++) {
        for (var k = 0; k < poses.length; k++) {
          c.save();
          c.translate(k * cell + cell / 2, r * cell + cell * 0.85);
          c.scale(cell / 2.6, -cell / 2.6);
          paintSkater(c, poses[k], Avatar.of(presets[r]), sprites);
          c.restore();
        }
      }
      final img = await tester.runAsync(
        () => rec.endRecording().toImage((cell * poses.length).toInt(), (cell * presets.length).toInt()),
      );
      final bytes = await tester.runAsync(() => img!.toByteData(format: ui.ImageByteFormat.png));
      File('$out/avatars_${style.name}.png').writeAsBytesSync(bytes!.buffer.asUint8List());
    }
    Palette.style = ArtStyle.neon;
  });
}
