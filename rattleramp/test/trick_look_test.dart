import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'helpers.dart';

void main() {
  test('every grab and flip has its own look', () {
    final j = jsonDecode(File('assets/tricks.json').readAsStringSync()) as Map<String, dynamic>;
    for (final key in ['grabs', 'flips']) {
      for (final t in (j[key] as List).cast<Map<String, dynamic>>()) {
        expect(t['look'], isNotNull, reason: '${t['id']} has no look');
      }
    }
    // Same look twice would make two grabs indistinguishable on screen.
    final grabs = {for (final g in book.grabs) (g.grabLook.hand, g.grabLook.at, g.grabLook.style, g.grabLook.tilt)};
    expect(grabs.length, book.grabs.length);
    final flips = {for (final f in book.flips) (f.flipLook.roll, f.flipLook.shove, f.flipLook.tumble)};
    expect(flips.length, book.flips.length);
  });
}
