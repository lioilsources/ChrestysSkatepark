import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/grid.dart';
import 'package:rattleramp/core/trick_defs.dart';
import 'package:rattleramp/core/trick_parser.dart';

import 'helpers.dart';

/// Every concrete way a token can be drawn: grabs/flips have one path,
/// spins can start on any outer node.
List<List<int>> drawings(TrickToken t) => t.kind == TokenKind.spin
    ? [for (final n in ringOrder) TrickBook.ringPath(n, t.degrees ~/ 45, clockwise: t.frontside)]
    : [t.path];

/// Two neighbouring tokens that legitimately merge into one run.
bool merges(TrickToken a, TrickToken b) =>
    (a.kind == TokenKind.flip && b.kind == TokenKind.flip) ||
    (a.kind == TokenKind.spin && b.kind == TokenKind.spin && a.frontside == b.frontside);

/// All chained patterns for a token sequence (each token starts where the
/// previous one ended).
Iterable<List<int>> chains(List<TrickToken> seq, [List<int>? prefix]) sync* {
  if (seq.isEmpty) {
    yield prefix!;
    return;
  }
  for (final d in drawings(seq.first)) {
    if (prefix != null && prefix.last != d.first) continue;
    yield* chains(seq.sublist(1), prefix == null ? d : [...prefix, ...d.sublist(1)]);
  }
}

void main() {
  test('trick book is well formed', () {
    final grabEnds = <String>{};
    for (final g in book.grabs) {
      expect(g.path, hasLength(3), reason: g.id);
      expect(g.path[1], centerNode, reason: g.id);
      expect(grabEnds.add('${g.path.first}-${g.path.last}'), isTrue, reason: 'duplicate ${g.id}');
    }
    final flipPaths = <String>{};
    for (final f in book.flips) {
      for (var i = 1; i < f.path.length; i++) {
        expect(classifyMove(f.path[i - 1], f.path[i]), MoveClass.diamond, reason: f.id);
      }
      expect(flipPaths.add(f.path.join(',')), isTrue, reason: 'duplicate ${f.id}');
    }
    final ids = book.allTokens.map((t) => t.id).toList();
    expect(ids.toSet(), hasLength(ids.length));
    expect(book.grabs.length, greaterThanOrEqualTo(10));
    expect(book.flips.length, greaterThanOrEqualTo(8));
    expect(book.spins.length, 12);
  });

  test('every single token parses back to itself from every drawing', () {
    for (final t in book.allTokens) {
      for (final d in drawings(t)) {
        final r = parser.parse(d);
        expect(r.ok, isTrue, reason: '${t.id} $d → ${r.error}');
        expect(r.trick!.tokens.map((x) => x.id), [t.id], reason: '${t.id} $d');
      }
    }
  });

  test('collision test: all chainable sequences of up to 3 tokens parse uniquely', () {
    final all = book.allTokens;
    var checked = 0;
    void check(List<TrickToken> seq) {
      for (final p in chains(seq)) {
        final r = parser.parse(p);
        expect(r.ok, isTrue, reason: '$seq $p → ${r.error}');
        expect(r.trick!.tokens.map((t) => t.id).toList(), seq.map((t) => t.id).toList(), reason: '$p');
        checked++;
      }
    }

    for (final a in all) {
      for (final b in all) {
        if (merges(a, b)) continue;
        check([a, b]);
        for (final c in all) {
          if (merges(b, c)) continue;
          check([a, b, c]);
        }
      }
    }
    expect(checked, greaterThan(10000));
  });

  test('named combos are drawable and recognised', () {
    for (final c in book.combos) {
      final seq = c.tokens.map((id) => book.token(id)!).toList();
      final patterns = chains(seq).toList();
      expect(patterns, isNotEmpty, reason: '${c.id} cannot be drawn in one swipe');
      for (final p in patterns) {
        final r = parser.parse(p);
        expect(r.trick?.combo?.id, c.id, reason: '$p');
        expect(r.trick!.name, c.name);
      }
    }
  });

  test('spin length is tolerant to a sloppy finger', () {
    // 4k-1 … 4k+2 ring steps count as k half turns.
    expect(parser.parse(TrickBook.ringPath(1, 7, clockwise: true)).trick!.tokens.single.id, 'fs360');
    expect(parser.parse(TrickBook.ringPath(1, 10, clockwise: true)).trick!.tokens.single.id, 'fs360');
    expect(parser.parse(TrickBook.ringPath(1, 3, clockwise: false)).trick!.tokens.single.id, 'bs180');
    expect(parser.parse(TrickBook.ringPath(1, 30, clockwise: true)).trick!.tokens.single.id, 'fs1080');
    expect(parser.parse(TrickBook.ringPath(1, 2, clockwise: true)).error, ParseError.spinTooShort);
  });

  test('720 needs nodes to repeat (two loops)', () {
    final p = TrickBook.ringPath(0, 16, clockwise: true);
    expect(p.where((n) => n == 0), hasLength(3));
    expect(parser.parse(p).trick!.name, 'FS 720');
  });

  test('generated names', () {
    expect(parser.parse([3, 4, 5, 8, 7, 6, 3, 0, 1, 2, 5]).trick!.name, 'Indy FS 360');
    expect(parser.parse([0, 4, 2, 1, 0, 3, 6, 7, 8, 5, 2, 1, 0, 3, 6, 7]).trick!.name, 'McTwist');
  });

  test('invalid patterns', () {
    expect(parser.parse([0, 1]).error, ParseError.tooShort);
    expect(parser.parse([0, 4, 0]).error, ParseError.unknownGrab);
    expect(parser.parse([0, 1, 4]).error, ParseError.spinTooShort);
    expect(parser.parse([3, 4, 5, 4]).error, ParseError.danglingCenter);
    expect(parser.parse([4, 3, 0, 1]).error, ParseError.danglingCenter);
    expect(parser.parse([1, 3, 1]).error, ParseError.unknownFlip);
    expect(parser.parse([0, 2, 5]).error, ParseError.notContinuous);
  });
}
