import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/ui/app.dart';
import 'package:rattleramp/ui/theme.dart';

import 'helpers.dart';

void main() {
  testWidgets('STYL button cycles neon → comic → pixel → neon', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    addTearDown(() => Palette.style = ArtStyle.neon);

    await tester.pumpWidget(RattleApp(book: book));
    await tester.pump(const Duration(milliseconds: 300));
    for (final expected in [ArtStyle.comic, ArtStyle.pixel, ArtStyle.neon]) {
      await tester.tap(find.textContaining('STYL:'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));
      expect(Palette.style, expected);
      expect(find.text('STYL: ${expected.label}'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
