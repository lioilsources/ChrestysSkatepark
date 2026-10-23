import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/ui/app.dart';
import 'package:rattleramp/ui/swipe_grid.dart';
import 'package:rattleramp/ui/trick_book_screen.dart';

import 'helpers.dart';

void main() {
  testWidgets('attract → ride → swipe, and trick book opens', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
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

    await tester.tapAt(const Offset(640, 300));
    await tester.pump(const Duration(milliseconds: 500));
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
