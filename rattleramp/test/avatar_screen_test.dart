import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/avatar.dart';
import 'package:rattleramp/game/avatar_sprites.dart';
import 'package:rattleramp/ui/avatar_screen.dart';

void main() {
  // A ticker starts counting on its first frame, so time has to advance in
  // small frames, not one big pump.
  Future<void> wait(WidgetTester tester, int ms) async {
    for (var t = 0; t < ms; t += 100) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('countdown starts the ride with the pick; a tap restarts it', (tester) async {
    tester.view.physicalSize = const Size(1024, 768);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    Avatar? went;
    await tester.pumpWidget(
      MaterialApp(
        home: AvatarScreen(initial: Avatar.initial, sprites: AvatarSprites.empty, onGo: (a) => went = a, onBack: () {}),
      ),
    );
    await wait(tester, 3000);
    expect(went, isNull);

    // Pick the third preset — the countdown starts over.
    await tester.tap(find.byKey(ValueKey('preset-${presets[2].id}')));
    await wait(tester, 3000);
    expect(went, isNull);
    await wait(tester, 3000);
    expect(went?.preset.id, presets[2].id);
    expect(went?.deck, presets[2].deck);
  });
}
