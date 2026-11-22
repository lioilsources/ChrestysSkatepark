// Store screenshots (App Store / Google Play): ride in all three art styles, avatar picker, trick book,
// stat card and the attract screen. Run by tool/store_screenshots.sh (flutter drive on a simulator);
// test_driver/screenshot_driver.dart writes the PNGs to SCREENSHOT_DIR.
//
// The app UI is Czech only, so one set is shot and the script copies it to every store locale.
// Rides are driven through RideSim with perfectly timed releases, so every shot shows landed tricks.

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:rattleramp/core/ride_sim.dart';
import 'package:rattleramp/core/trick_defs.dart';
import 'package:rattleramp/game/avatar_sprites.dart';
import 'package:rattleramp/game/rattle_game.dart';
import 'package:rattleramp/ui/app.dart';
import 'package:rattleramp/ui/avatar_screen.dart';
import 'package:rattleramp/ui/stat_card.dart';
import 'package:rattleramp/ui/theme.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Flame runs its own loop: frames have to flow in real time, not only on pump.
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('store screenshots', (tester) async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final book = TrickBook.fromJson(await rootBundle.loadString('assets/tricks.json'));
    final sprites = await AvatarSprites.load(rootBundle);

    Future<void> shot(String name) async {
      await _wait(tester, 0.3);
      await binding.takeScreenshot(name);
    }

    Future<void> open(ArtStyle style) async {
      Palette.style = style;
      await tester.pumpWidget(RattleApp(key: ValueKey(style), book: book, sprites: sprites));
      await _wait(tester, 2.5); // orientation settles, demo rider drops in
    }

    Future<RattleGame> startRide(String preset, {String? shotName}) async {
      await tester.tapAt(tester.getCenter(find.byType(MaterialApp)));
      await _wait(tester, 0.6);
      expect(find.byType(AvatarScreen), findsOneWidget);
      await tester.tap(find.byKey(ValueKey('preset-$preset')));
      await _wait(tester, 0.6);
      if (shotName != null) await shot(shotName);
      await tester.tap(find.textContaining('JEĎ!'));
      await _wait(tester, 0.6);
      return tester.widget<GameWidget<RattleGame>>(find.byType(GameWidget<RattleGame>).last).game!;
    }

    // Neon: attract, trick book, avatar picker, hero ride, stat card.
    await open(ArtStyle.neon);
    await shot('7_attract');
    await tester.tap(find.text('TRICK BOOK'));
    await _wait(tester, 0.6);
    await tester.tap(find.text('FLIPY'));
    await _wait(tester, 1.2); // pattern animations draw in
    await shot('5_trickbook');
    await tester.tap(find.byIcon(Icons.close));
    await _wait(tester, 0.6);

    var game = await startRide('chrestys', shotName: '2_avatar');
    await _ride(tester, game, book, landings: 2, then: 'Kickflip Melon');
    await shot('1_ride');
    await _ride(tester, game, book, landings: 6);
    await _finish(tester, game);
    await shot('6_stats');

    // Comic and pixel: one ride each, mid-air.
    await open(ArtStyle.comic);
    game = await startRide('punk');
    await _ride(tester, game, book, landings: 3, then: 'Stalefish');
    await shot('3_ride_comic');

    await open(ArtStyle.pixel);
    game = await startRide('dreads');
    await _ride(tester, game, book, landings: 2, then: '360 Flip');
    await shot('4_ride_pixel');

    await tester.pumpWidget(const SizedBox());
    Palette.style = ArtStyle.neon;
    await _wait(tester, 0.5);
  });
}

/// Feeds perfectly timed releases until [landings] more tricks have landed. With [then], releases that trick
/// next (or the nearest one that fits the speed) and returns when the rider is in the middle of its air.
Future<void> _ride(WidgetTester tester, RattleGame game, TrickBook book, {required int landings, String? then}) async {
  final sim = game.sim;
  final target = sim.stats.landed + landings;
  var lastSeg = -1.0;
  var released = false;
  final end = DateTime.now().add(const Duration(seconds: 60));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 16));
    if (sim.finished) throw StateError('ride ended early (${sim.bailReason})');
    final waiting = sim.stats.landed < target;
    if (!waiting && then == null) return;
    if (released && sim.phase == RidePhase.air && sim.time > sim.tEdge + 0.45 * sim.airDuration) return;
    if ((sim.phase == RidePhase.rolling || sim.phase == RidePhase.dropIn) && sim.segStart != lastSeg) {
      lastSeg = sim.segStart;
      final path = _pick(game, book, waiting ? null : then);
      if (path == null) continue;
      sim.addInput(ReleaseInput(sim.tEdge, path));
      released = !waiting;
    }
  }
  throw StateError('ride did not reach the shot in time');
}

/// No more tricks: the rider loses speed and rolls out, then the stat card shows.
Future<void> _finish(WidgetTester tester, RattleGame game) async {
  final end = DateTime.now().add(const Duration(seconds: 60));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 16));
    if (find.byType(StatCard).evaluate().isNotEmpty) {
      await _wait(tester, 2.5); // "tap to continue" fades in
      return;
    }
  }
  throw StateError('ride did not finish');
}

/// [name] if it fits the current speed, else the trick with the most points that does.
List<int>? _pick(RattleGame game, TrickBook book, String? name) {
  final all = <(String, List<int>)>[
    for (final t in book.allTokens) (t.name, t.path),
    for (final c in book.combos)
      if (book.comboPath(c) case final p?) (c.name, p),
  ];
  final fits = [
    for (final (n, p) in all)
      if (game.sim.speedNeeded(game.parser.parse(p).trick!) <= game.sim.speed - 0.05) (n, p),
  ];
  if (fits.isEmpty) return null;
  for (final (n, p) in fits) {
    if (n == name) return p;
  }
  // Mid-ride: vary the tricks so the score and combo look like a real run.
  return fits[(game.sim.stats.landed * 7) % fits.length].$2;
}

Future<void> _wait(WidgetTester tester, double seconds) async {
  final end = DateTime.now().add(Duration(milliseconds: (seconds * 1000).round()));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}
