// Feature shorts, Flutter client (DevConventions plan 06, ch. 5a: one video per feature, W = web, F = this app).
// One scenario per run, picked by --dart-define=SHORT=<id>; ids match babylon/src/rules/demo.ts and
// babylon/PORT.md "Funkce". Recorded by Store/shorts/tools/run_it.sh on a simulator:
//
//   tools/run_it.sh <repo>/rattleramp integration_test/shorts_test.dart raw-f/<id>.mov --dart-define=SHORT=<id>
//
// Unlike the store screenshots (which feed RideSim directly), the rider here swipes the real SwipeGrid with a
// test gesture, so the pad lights up as on a phone. Tricks and timing follow the web DemoPlayer (same pools and
// options), seeded by SEED; the finger lifts at the edge (± jitter). Prints `MARK <epoch ms> <label>` lines
// for tools/marks.py.

import 'dart:math' as math;

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
import 'package:rattleramp/ui/pattern_painter.dart';
import 'package:rattleramp/ui/ride_screen.dart';
import 'package:rattleramp/ui/stat_card.dart';
import 'package:rattleramp/ui/swipe_grid.dart';
import 'package:rattleramp/ui/theme.dart';

const _short = String.fromEnvironment('SHORT', defaultValue: 'ride');
const _seed = int.fromEnvironment('SEED', defaultValue: 7);

void mark(String label) => debugPrint('MARK ${DateTime.now().millisecondsSinceEpoch} $label');

/// Same knobs as DemoOptions in babylon/src/rules/demo.ts.
class Demo {
  final Set<TokenKind> kinds;
  final String combos; // none | also | only
  final bool perfect;
  final int? bailAfter;
  final bool preferDaily;
  final bool fromHints;
  final double drawSeconds;
  final bool showEnd;
  final bool pro;
  final double seconds; // ride length when not ending on the stat card
  const Demo({
    this.kinds = const {TokenKind.grab, TokenKind.flip, TokenKind.spin},
    this.combos = 'also',
    this.perfect = false,
    this.bailAfter,
    this.preferDaily = false,
    this.fromHints = false,
    this.drawSeconds = 0.45,
    this.showEnd = false,
    this.pro = false,
    this.seconds = 24,
  });
}

const _demos = <String, Demo>{
  'ride': Demo(),
  'timing': Demo(kinds: {TokenKind.grab}, combos: 'none', perfect: true),
  'swipe-grid': Demo(kinds: {TokenKind.grab, TokenKind.flip}, combos: 'none', drawSeconds: 0.9),
  'spins': Demo(kinds: {TokenKind.spin}, combos: 'none'),
  'grabs': Demo(kinds: {TokenKind.grab}, combos: 'none'),
  'flips': Demo(kinds: {TokenKind.flip}, combos: 'none'),
  'combos': Demo(kinds: {}, combos: 'only', drawSeconds: 0.7),
  'bail': Demo(bailAfter: 3, showEnd: true),
  'scoring': Demo(preferDaily: true),
  'trick-of-day': Demo(kinds: {TokenKind.grab, TokenKind.flip}, combos: 'none', preferDaily: true),
  'pro-mode': Demo(pro: true),
  'hints': Demo(fromHints: true, drawSeconds: 0.7),
  'stat-card': Demo(bailAfter: 4, showEnd: true),
};

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  testWidgets('short $_short', (tester) async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    final book = TrickBook.fromJson(await rootBundle.loadString('assets/tricks.json'));
    final sprites = await AvatarSprites.load(rootBundle);
    Palette.style = ArtStyle.neon;
    await tester.pumpWidget(RattleApp(book: book, sprites: sprites));
    await _wait(tester, 2.5); // orientation settles, attract rider drops in
    mark('start');

    final demo = _demos[_short];
    if (demo != null) {
      await _rideShort(tester, book, demo);
    } else {
      switch (_short) {
        case 'attract':
          await _wait(tester, 20);
        case 'trick-book':
          await tester.tap(find.text('TRICK BOOK'));
          await _wait(tester, 2.5);
          for (final tab in ['FLIPY', 'SPINY', 'KOMBA', 'GRABY']) {
            await tester.tap(find.text(tab));
            mark('tab $tab');
            await _wait(tester, 3.5);
          }
        case 'avatars':
          await tester.tapAt(tester.getCenter(find.byType(MaterialApp)));
          await _wait(tester, 1.5);
          mark('avatars');
          for (final id in ['punk', 'beanie', 'dreads', 'helmet', 'oldschool', 'kid', 'afro', 'chrestys']) {
            await tester.tap(find.byKey(ValueKey('preset-$id')));
            mark('preset $id');
            await _wait(tester, 1.6);
          }
        case 'art-styles':
          for (var i = 0; i < 3; i++) {
            await _wait(tester, 3);
            await tester.tap(find.textContaining('STYL: '));
            mark('style ${Palette.style.name}');
          }
          await _wait(tester, 3);
        default:
          throw ArgumentError('unknown SHORT=$_short');
      }
    }
    mark('end');
    await _wait(tester, 0.5);
  });
}

Future<void> _rideShort(WidgetTester tester, TrickBook book, Demo demo) async {
  if (demo.pro) {
    await tester.tap(find.text('PRO ×1,5'));
  } else {
    await tester.tapAt(tester.getCenter(find.byType(MaterialApp)));
  }
  await _wait(tester, 1.2);
  await tester.tap(find.byKey(const ValueKey('preset-chrestys')));
  await _wait(tester, 0.6);
  await tester.tap(find.textContaining('JEĎ!'));
  await _wait(tester, 0.4);
  final game = tester.widget<GameWidget<RattleGame>>(find.byType(GameWidget<RattleGame>).last).game!;
  final daily = tester.widget<RideScreen>(find.byType(RideScreen)).daily.id;
  mark('ride');

  final rnd = math.Random(_seed);
  final sim = game.sim;
  final rideStart = DateTime.now();
  var segment = -1.0;
  var bailMarked = false;
  while (true) {
    await tester.pump(const Duration(milliseconds: 16));
    if (sim.bailReason != null && !bailMarked) {
      bailMarked = true;
      mark('bail ${sim.bailReason!.name}');
    }
    if (find.byType(StatCard).evaluate().isNotEmpty) {
      mark('stats');
      await _wait(tester, 5);
      return;
    }
    if (sim.finished && !demo.showEnd) return;
    final elapsed = DateTime.now().difference(rideStart).inMilliseconds / 1000;
    if (!demo.showEnd && elapsed > demo.seconds) return;
    if (elapsed > 90) throw StateError('ride did not end');
    if (sim.phase != RidePhase.rolling && sim.phase != RidePhase.dropIn) continue;
    if (sim.segStart == segment) continue;
    segment = sim.segStart;

    List<int>? nodes;
    if (demo.bailAfter != null && sim.stats.landed >= demo.bailAfter!) {
      nodes = const [0, 4, 0];
    } else {
      final pool = _pool(tester, game, book, demo, daily, rnd);
      if (pool.isNotEmpty) nodes = pool[rnd.nextInt(pool.length)];
    }
    if (nodes == null) continue;
    final jitter = demo.perfect ? 0.0 : (rnd.nextDouble() - 0.5) * 0.07;
    final release = sim.tEdge + jitter;
    if (release - demo.drawSeconds < sim.time) continue; // too late to draw it this edge
    await _swipe(tester, game, nodes, drawStart: release - demo.drawSeconds, release: release);
    mark('release ${nodes.join()} edge ${((game.rideNow - sim.tEdge) * 1000).round()} ms');
  }
}

/// Trick pool of DemoPlayer.pool (demo.ts): what fits the current speed, filtered by the demo's options.
List<List<int>> _pool(WidgetTester tester, RattleGame game, TrickBook book, Demo demo, String daily, math.Random rnd) {
  final sim = game.sim;
  bool fits(List<int> p) {
    final r = game.parser.parse(p);
    return r.ok && sim.speedNeeded(r.trick!) < sim.speed - 0.05;
  }

  if (demo.fromHints) {
    // The hint strip draws each hint with a PatternPainter; copy what it shows.
    return [
      for (final w in tester.widgetList<CustomPaint>(
        find.descendant(of: find.byType(RideScreen), matching: find.byType(CustomPaint)),
      ))
        if (w.painter case final PatternPainter p when p.path.isNotEmpty && fits(p.path)) p.path,
    ];
  }
  final out = <List<int>>[];
  if (demo.combos != 'only') {
    for (final t in book.allTokens) {
      if (demo.kinds.contains(t.kind) && fits(t.path)) out.add(t.path);
    }
  }
  if (demo.combos != 'none') {
    for (final c in book.combos) {
      final p = book.comboPath(c);
      if (p != null && fits(p)) out.add(p);
    }
    for (final g in book.grabs) {
      for (final s in book.spins) {
        if (s.degrees > 360) continue;
        final p = [...g.path, ...TrickBook.ringPath(g.path.last, s.degrees ~/ 45, clockwise: s.frontside).skip(1)];
        if (fits(p)) out.add(p);
      }
    }
  }
  if (demo.preferDaily) {
    final d = [
      for (final p in out)
        if (game.parser.parse(p).trick!.tokens.any((t) => t.id == daily)) p,
    ];
    if (d.isNotEmpty && rnd.nextDouble() < 0.6) return d;
  }
  return out;
}

/// Draws [nodes] on the real SwipeGrid: finger down at drawStart, through every node evenly, up at release
/// (ride time of the sim).
Future<void> _swipe(
  WidgetTester tester,
  RattleGame game,
  List<int> nodes, {
  required double drawStart,
  required double release,
}) async {
  final grid = find.byType(SwipeGrid);
  final origin = tester.getTopLeft(grid);
  final size = tester.getSize(grid);
  Offset at(int n) => origin + PatternPainter.nodeCenter(n, size);

  while (game.rideNow < drawStart) {
    await tester.pump(const Duration(milliseconds: 8));
  }
  final g = await tester.startGesture(at(nodes.first));
  final t0 = game.rideNow;
  final span = math.max(0.05, release - t0 - 0.04);
  var passed = 0; // nodes already reached
  while (true) {
    await tester.pump(const Duration(milliseconds: 8));
    final u = ((game.rideNow - t0) / span).clamp(0.0, 1.0) * (nodes.length - 1);
    final seg = math.min(u.floor(), nodes.length - 2);
    // A slow frame can jump several nodes ahead; go through each corner, or the straight move would cut it.
    while (passed < seg) {
      passed++;
      await g.moveTo(at(nodes[passed]));
    }
    await g.moveTo(Offset.lerp(at(nodes[seg]), at(nodes[seg + 1]), u - seg)!);
    if (u >= nodes.length - 1) break;
  }
  // Lift as close to the release time as frames allow.
  while (game.rideNow < release - 0.004) {
    await Future<void>.delayed(const Duration(milliseconds: 2));
  }
  await g.up();
}

Future<void> _wait(WidgetTester tester, double seconds) async {
  final end = DateTime.now().add(Duration(milliseconds: (seconds * 1000).round()));
  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 16));
  }
}
