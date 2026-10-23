import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/grid.dart';

void main() {
  test('every grid edge belongs to exactly one move class', () {
    final counts = <MoveClass, int>{};
    for (var a = 0; a < 9; a++) {
      for (var b = a + 1; b < 9; b++) {
        if (!areAdjacent(a, b)) continue;
        final c = classifyMove(a, b);
        expect(classifyMove(b, a), c);
        counts[c] = (counts[c] ?? 0) + 1;
      }
    }
    expect(counts, {MoveClass.ring: 8, MoveClass.center: 8, MoveClass.diamond: 4});
  });

  test('ring direction', () {
    expect(ringDirection(0, 1), 1);
    expect(ringDirection(3, 0), 1);
    expect(ringDirection(1, 0), -1);
  });

  test('midpoint fills skipped nodes on straight lines only', () {
    expect(midpointNode(0, 2), 1);
    expect(midpointNode(0, 8), 4);
    expect(midpointNode(3, 5), 4);
    expect(midpointNode(0, 5), isNull);
  });
}
