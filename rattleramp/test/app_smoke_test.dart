import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/ui/app.dart';
import 'package:rattleramp/ui/avatar_screen.dart';
import 'package:rattleramp/ui/swipe_grid.dart';
import 'package:rattleramp/ui/trick_book_screen.dart';

import 'helpers.dart';

void main() {
  for (final size in const [Size(1280, 800), Size(740, 360)]) {
    testWidgets('attract → ride → swipe, and trick book opens at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(RattleApp(book: book));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('TAPNI A JEĎ'), findsOneWidget);

      await tester.tap(find.text('TRICK BOOK'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(TrickBookScreen), findsOneWidget);
      await tester.tap(find.text('FLIPY'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Kickflip'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tapAt(Offset(size.width / 2, size.height * 0.4));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(AvatarScreen), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('preset-afro')));
      await tester.pump(const Duration(milliseconds: 100));
      await tester.tap(find.textContaining('JEĎ!'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 300));
      final grid = find.byType(SwipeGrid);
      expect(grid, findsOneWidget);

      // Swipe an Indy (3 → 4 → 5) across the middle row.
      final r = tester.getRect(grid);
      final g = await tester.startGesture(Offset(r.left + r.width / 6, r.center.dy));
      await g.moveTo(r.center);
      await g.moveTo(Offset(r.right - r.width / 6, r.center.dy));
      await g.up();
      for (var i = 0; i < 60; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
    });
  }
}
