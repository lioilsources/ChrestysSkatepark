/// 3×3 swipe grid geometry. Pure Dart — no Flutter imports.
///
/// Node indices (screen orientation, row 0 at the top):
///
///     0 1 2
///     3 4 5
///     6 7 8
///
/// Every edge of the 8-neighbour graph belongs to exactly one [MoveClass],
/// which is what makes trick tokenisation unambiguous (see trick_parser.dart):
///   * ring    — orthogonal step between two outer nodes (corner ↔ edge-mid)
///   * center  — any step into or out of the centre node 4
///   * diamond — diagonal step between two edge-mid nodes (1,3,5,7)
library;

const int centerNode = 4;

/// Outer ring in clockwise screen order.
const List<int> ringOrder = [0, 1, 2, 5, 8, 7, 6, 3];

/// Edge-mid nodes forming the inner diamond.
const Set<int> diamondNodes = {1, 3, 5, 7};

enum MoveClass { ring, center, diamond }

int nodeRow(int n) => n ~/ 3;
int nodeCol(int n) => n % 3;

bool isValidNode(int n) => n >= 0 && n < 9;

/// True when [a] and [b] are distinct 8-neighbours.
bool areAdjacent(int a, int b) {
  if (!isValidNode(a) || !isValidNode(b) || a == b) return false;
  final dr = (nodeRow(a) - nodeRow(b)).abs();
  final dc = (nodeCol(a) - nodeCol(b)).abs();
  return dr <= 1 && dc <= 1;
}

/// Classifies a step between adjacent nodes. Throws on non-adjacent input.
MoveClass classifyMove(int a, int b) {
  if (!areAdjacent(a, b)) {
    throw ArgumentError('Nodes $a and $b are not adjacent');
  }
  if (a == centerNode || b == centerNode) return MoveClass.center;
  if (diamondNodes.contains(a) && diamondNodes.contains(b)) {
    return MoveClass.diamond;
  }
  return MoveClass.ring;
}

/// +1 for a clockwise ring step, -1 for counter-clockwise.
/// Only valid for [MoveClass.ring] moves.
int ringDirection(int a, int b) {
  final ia = ringOrder.indexOf(a);
  final ib = ringOrder.indexOf(b);
  return (ib - ia) % 8 == 1 ? 1 : -1;
}

/// The node that lies exactly between [a] and [b] on a straight line
/// (e.g. 0→2 gives 1, 0→8 gives 4), or null when there is none.
/// Used by the touch layer to fill in a node the finger skipped over.
int? midpointNode(int a, int b) {
  final r = nodeRow(a) + nodeRow(b);
  final c = nodeCol(a) + nodeCol(b);
  if (r.isOdd || c.isOdd) return null;
  final m = (r ~/ 2) * 3 + c ~/ 2;
  return (m == a || m == b) ? null : m;
}
