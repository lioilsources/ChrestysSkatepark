/// Trick definitions loaded from `assets/tricks.json`. Pure Dart.
library;

import 'dart:convert';

enum TokenKind { spin, grab, flip }

/// Which hand reaches for the board during a grab.
enum GrabHand { front, back, both }

/// Body shape held during a grab. Each style moves the board and the feet
/// differently, so grabs read apart even as silhouettes.
enum GrabStyle {
  /// Knees up, board under the feet.
  tuck,

  /// Board pulled up behind the back (method, japan).
  tweak,

  /// Legs straight, board stood up on its tail (rocket, nosegrab).
  stiff,

  /// Feet off, scissor walk in the air (airwalk).
  split,

  /// Back foot kicked off and down (benihana).
  kick,

  /// Board held out to the side, arms spread (christ air).
  spread,
}

/// How a grab looks: hand, spot on the board and body shape.
class GrabLook {
  final GrabHand hand;

  /// −1 tail … +1 nose.
  final double at;
  final GrabStyle style;

  /// Extra board tilt on top of the style's (rad, + = nose up), so grabs
  /// sharing a style still read apart.
  final double tilt;

  const GrabLook({this.hand = GrabHand.front, this.at = 0, this.style = GrabStyle.tuck, this.tilt = 0});

  factory GrabLook.fromJson(Map<String, dynamic> j) => GrabLook(
    hand: GrabHand.values.byName(j['hand'] as String? ?? 'front'),
    at: (j['at'] as num? ?? 0).toDouble(),
    style: GrabStyle.values.byName(j['style'] as String? ?? 'tuck'),
    tilt: (j['tilt'] as num? ?? 0).toDouble(),
  );
}

/// How a flip rotates the board, in full turns per axis. Signs pick the
/// direction (roll + = kickflip, shove + = backside).
class FlipLook {
  /// Around the long axis (kickflip / heelflip).
  final double roll;

  /// Around the vertical axis (shove-it, varial).
  final double shove;

  /// End over end around the short axis (impossible).
  final double tumble;

  const FlipLook({this.roll = 0, this.shove = 0, this.tumble = 0});

  factory FlipLook.fromJson(Map<String, dynamic> j) => FlipLook(
    roll: (j['roll'] as num? ?? 0).toDouble(),
    shove: (j['shove'] as num? ?? 0).toDouble(),
    tumble: (j['tumble'] as num? ?? 0).toDouble(),
  );
}

/// One building block of a trick. Grabs and flips have a fixed node path;
/// spins are matched by direction + length along the outer ring, so
/// [path] holds a canonical example (starting at node 1) for the trick book.
class TrickToken {
  final String id;
  final String name;
  final TokenKind kind;
  final int base;
  final List<int> path;

  /// Spins only: degrees and direction (true = frontside / clockwise).
  final int degrees;
  final bool frontside;

  /// Grabs / flips only: how the trick is drawn.
  final GrabLook grabLook;
  final FlipLook flipLook;

  const TrickToken({
    required this.id,
    required this.name,
    required this.kind,
    required this.base,
    required this.path,
    this.degrees = 0,
    this.frontside = true,
    this.grabLook = const GrabLook(),
    this.flipLook = const FlipLook(roll: 1),
  });

  int get moves => path.length - 1;

  @override
  String toString() => id;
}

/// A named combination with its own trick-book entry and bonus points.
class NamedCombo {
  final String id;
  final String name;
  final List<String> tokens;
  final int bonus;

  const NamedCombo({required this.id, required this.name, required this.tokens, required this.bonus});
}

class TrickBook {
  final List<TrickToken> spins;
  final List<TrickToken> grabs;
  final List<TrickToken> flips;
  final List<NamedCombo> combos;

  final Map<String, TrickToken> _byId;

  TrickBook({required this.spins, required this.grabs, required this.flips, required this.combos})
    : _byId = {
        for (final t in [...spins, ...grabs, ...flips]) t.id: t,
      };

  List<TrickToken> get allTokens => [...grabs, ...flips, ...spins];

  TrickToken? token(String id) => _byId[id];

  /// Clockwise ring path of [steps] moves starting at [start].
  static List<int> ringPath(int start, int steps, {required bool clockwise}) {
    const ring = [0, 1, 2, 5, 8, 7, 6, 3];
    var i = ring.indexOf(start);
    final out = [start];
    for (var k = 0; k < steps; k++) {
      i = (i + (clockwise ? 1 : -1)) % 8;
      out.add(ring[i]);
    }
    return out;
  }

  /// One drawable node path for a named combo: spins start wherever the
  /// previous token ended. Null when the tokens don't chain.
  List<int>? comboPath(NamedCombo c) {
    List<int>? path;
    for (final id in c.tokens) {
      final t = token(id)!;
      final p = t.kind == TokenKind.spin ? ringPath(path?.last ?? 1, t.degrees ~/ 45, clockwise: t.frontside) : t.path;
      if (path != null && path.last != p.first) return null;
      path = path == null ? p : [...path, ...p.skip(1)];
    }
    return path;
  }

  factory TrickBook.fromJson(String source) {
    final j = jsonDecode(source) as Map<String, dynamic>;

    final spins = <TrickToken>[];
    for (final s in (j['spins'] as List).cast<Map<String, dynamic>>()) {
      final deg = s['deg'] as int;
      final base = s['base'] as int;
      final steps = deg ~/ 45;
      for (final fs in [true, false]) {
        spins.add(
          TrickToken(
            id: '${fs ? 'fs' : 'bs'}$deg',
            name: '${fs ? 'FS' : 'BS'} $deg',
            kind: TokenKind.spin,
            base: base,
            path: ringPath(1, steps, clockwise: fs),
            degrees: deg,
            frontside: fs,
          ),
        );
      }
    }

    List<TrickToken> fixed(String key, TokenKind kind) => [
      for (final g in (j[key] as List).cast<Map<String, dynamic>>())
        TrickToken(
          id: g['id'] as String,
          name: g['name'] as String,
          kind: kind,
          base: g['base'] as int,
          path: (g['path'] as List).cast<int>(),
          grabLook: g['look'] != null && kind == TokenKind.grab
              ? GrabLook.fromJson(g['look'] as Map<String, dynamic>)
              : const GrabLook(),
          flipLook: g['look'] != null && kind == TokenKind.flip
              ? FlipLook.fromJson(g['look'] as Map<String, dynamic>)
              : const FlipLook(roll: 1),
        ),
    ];

    return TrickBook(
      spins: spins,
      grabs: fixed('grabs', TokenKind.grab),
      flips: fixed('flips', TokenKind.flip),
      combos: [
        for (final c in (j['combos'] as List).cast<Map<String, dynamic>>())
          NamedCombo(
            id: c['id'] as String,
            name: c['name'] as String,
            tokens: (c['tokens'] as List).cast<String>(),
            bonus: c['bonus'] as int,
          ),
      ],
    );
  }
}

/// Trick "stupeň" 1–5 from pattern length; roughly the speed it needs.
int trickGrade(int moves) {
  if (moves <= 2) return 1;
  if (moves <= 5) return 2;
  if (moves <= 9) return 3;
  if (moves <= 15) return 4;
  return 5;
}

/// "Trik dne": one grab or flip, ×2 points, changes at local midnight.
/// Deterministic per calendar day so every tablet agrees.
TrickToken dailyToken(TrickBook book, DateTime now) {
  final pool = [...book.grabs, ...book.flips];
  final day = DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 86400000;
  final h = (day * 2654435761) & 0x7fffffff;
  return pool[h % pool.length];
}
