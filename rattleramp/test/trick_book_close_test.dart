import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/ui/app.dart';
import 'package:rattleramp/ui/trick_book_screen.dart';

import 'helpers.dart';

void main() {
  // Phones in landscape and small tablets: the header must not push the
  // close button out of its hit area.
  for (final size in const [Size(1280, 800), Size(1024, 768), Size(844, 390), Size(740, 360)]) {
    testWidgets('trick book closes back to attract at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(RattleApp(book: book));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('TRICK BOOK'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(TrickBookScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      // AnimatedSwitcher drops the old screen a frame after the fade ends.
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 16));
      expect(find.byType(TrickBookScreen), findsNothing);
      expect(find.text('TAPNI A JEĎ'), findsOneWidget);
    });
  }
}
