import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/l10n/app_localizations.dart';
import 'package:rattleramp/ui/app.dart';
import 'package:rattleramp/ui/theme.dart';
import 'package:rattleramp/ui/trick_book_screen.dart';

import 'helpers.dart';

void main() {
  final arbs = Directory('lib/l10n').listSync().whereType<File>().where((f) => f.path.endsWith('.arb')).toList();
  Map<String, dynamic> read(File f) => jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  final template = read(File('lib/l10n/app_cs.arb'));
  final keys = template.keys.where((k) => !k.startsWith('@')).toSet();

  test('every ARB has every key with the same placeholders', () {
    final ph = RegExp(r'\{(\w+)\}');
    for (final f in arbs) {
      final arb = read(f);
      expect(arb.keys.where((k) => !k.startsWith('@')).toSet(), keys, reason: f.path);
      for (final k in keys) {
        final want = ph.allMatches(template[k] as String).map((m) => m[1]).toSet();
        final got = ph.allMatches(arb[k] as String).map((m) => m[1]).toSet();
        expect(got, want, reason: '${f.path} $k');
      }
    }
  });

  test('resolver maps region-only Chinese and legacy codes', () {
    const s = L10n.supportedLocales;
    expect(resolveLocale([const Locale('zh', 'TW')], s), Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'));
    expect(resolveLocale([const Locale('zh', 'CN')], s), Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'));
    expect(resolveLocale([const Locale('pt', 'BR')], s), const Locale('pt', 'BR'));
    expect(resolveLocale([const Locale('no')], s), const Locale('nb'));
    expect(resolveLocale([const Locale('iw')], s), const Locale('he'));
    expect(resolveLocale([const Locale('xx')], s), const Locale('en'));
  });

  // Attract and trick book are the screens guests read; long translations
  // must not overflow on a small Android tablet.
  for (final locale in L10n.supportedLocales) {
    testWidgets('attract and trick book render in $locale', (tester) async {
      tester.view.physicalSize = const Size(740, 360);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      addTearDown(() => Palette.tightLetters = false);

      await tester.pumpWidget(RattleApp(book: book, locale: locale));
      await tester.pump(const Duration(milliseconds: 300));
      expect(tester.takeException(), isNull);
      final l = L10n.of(tester.element(find.byType(Scaffold).first));
      expect(find.text(l.tapToRide), findsOneWidget);

      await tester.tap(find.text('TRICK BOOK'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(TrickBookScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
