/// Turns a swiped node sequence into a trick. Pure Dart.
///
/// The pattern is split into maximal runs of one [MoveClass] (grid.dart).
/// Because each grid edge has exactly one class, that split is unique:
///   * ring run    → one spin per same-direction stretch; length is tolerant
///                   (4k-1 … 4k+2 steps count as k half-turns)
///   * center run  → consecutive grabs, two moves each (a→4→b)
///   * diamond run → exactly one flip, matched by full path
library;

import 'grid.dart';
import 'trick_defs.dart';

enum ParseError { tooShort, notContinuous, unknownGrab, unknownFlip, spinTooShort, danglingCenter }

class ParsedTrick {
  final List<TrickToken> tokens;
  final NamedCombo? combo;
  final int moves;

  const ParsedTrick(this.tokens, this.combo, this.moves);

  /// Stable key for variety tracking ("same trick again").
  String get key => combo?.id ?? tokens.map((t) => t.id).join('+');

  String get name => combo?.name ?? tokens.map((t) => t.name).join(' ');

  int get grade => trickGrade(moves);

  int get baseSum => tokens.fold(0, (s, t) => s + t.base) + (combo?.bonus ?? 0);
}

class ParseResult {
  final ParsedTrick? trick;
  final ParseError? error;

  const ParseResult.ok(ParsedTrick this.trick) : error = null;
  const ParseResult.fail(ParseError this.error) : trick = null;

  bool get ok => trick != null;
}

/// Spins longer than this are capped (1080 is the top of the trick book).
const int maxSpinDegrees = 1080;

class TrickParser {
  final TrickBook book;
  final Map<String, TrickToken> _grabByEnds;
  final Map<String, TrickToken> _flipByPath;
  final Map<String, TrickToken> _spinByKey;
  final Map<String, NamedCombo> _comboByTokens;

  TrickParser(this.book)
    : _grabByEnds = {for (final g in book.grabs) '${g.path.first}-${g.path.last}': g},
      _flipByPath = {for (final f in book.flips) f.path.join(','): f},
      _spinByKey = {for (final s in book.spins) '${s.frontside}-${s.degrees}': s},
      _comboByTokens = {for (final c in book.combos) c.tokens.join('+'): c};

  ParseResult parse(List<int> nodes) {
    if (nodes.length < 3) return const ParseResult.fail(ParseError.tooShort);
    for (var i = 1; i < nodes.length; i++) {
      if (!areAdjacent(nodes[i - 1], nodes[i])) {
        return const ParseResult.fail(ParseError.notContinuous);
      }
    }

    final tokens = <TrickToken>[];
    var i = 0; // index of the run's first node
    while (i < nodes.length - 1) {
      final cls = classifyMove(nodes[i], nodes[i + 1]);
      final dir = cls == MoveClass.ring ? ringDirection(nodes[i], nodes[i + 1]) : 0;
      var j = i + 1; // run end node index
      while (j < nodes.length - 1 &&
          classifyMove(nodes[j], nodes[j + 1]) == cls &&
          (cls != MoveClass.ring || ringDirection(nodes[j], nodes[j + 1]) == dir)) {
        j++;
      }
      final run = nodes.sublist(i, j + 1);
      final err = _tokenize(cls, dir, run, tokens);
      if (err != null) return ParseResult.fail(err);
      i = j;
    }

    final combo = _comboByTokens[tokens.map((t) => t.id).join('+')];
    return ParseResult.ok(ParsedTrick(tokens, combo, nodes.length - 1));
  }

  ParseError? _tokenize(MoveClass cls, int dir, List<int> run, List<TrickToken> out) {
    final moves = run.length - 1;
    switch (cls) {
      case MoveClass.ring:
        final halfTurns = (moves + 1) ~/ 4;
        if (halfTurns == 0) return ParseError.spinTooShort;
        final deg = (halfTurns * 180).clamp(180, maxSpinDegrees);
        out.add(_spinByKey['${dir > 0}-$deg']!);
      case MoveClass.center:
        if (moves.isOdd || run.first == centerNode) return ParseError.danglingCenter;
        for (var k = 0; k < moves; k += 2) {
          final g = _grabByEnds['${run[k]}-${run[k + 2]}'];
          if (g == null) return ParseError.unknownGrab;
          out.add(g);
        }
      case MoveClass.diamond:
        final f = _flipByPath[run.join(',')];
        if (f == null) return ParseError.unknownFlip;
        out.add(f);
    }
    return null;
  }
}
