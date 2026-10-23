import 'package:flutter_test/flutter_test.dart';
import 'package:rattleramp/core/scoring.dart';

import 'helpers.dart';

void main() {
  final indy = parser.parse([3, 4, 5]).trick!;

  test('formula', () {
    final s = scoreTrick(trick: indy, timing: Timing.perfect, speed: 0.5, streak: 2, previousCount: 0, airHeight: 0.5);
    // 100 × 1.5 × 1.5 × 1.2 × 1.0
    expect(s.total, 270);
  });

  test('variety halves repeats, then quarters', () {
    int pts(int prev) =>
        scoreTrick(trick: indy, timing: Timing.good, speed: 0, streak: 0, previousCount: prev, airHeight: 0).total;
    expect([pts(0), pts(1), pts(2), pts(5)], [100, 50, 25, 25]);
  });

  test('pro mode, daily trick and air bonus', () {
    final s = scoreTrick(
      trick: indy,
      timing: Timing.good,
      speed: 0,
      streak: 0,
      previousCount: 0,
      airHeight: 1.8,
      proMode: true,
      dailyTokenId: 'indy',
    );
    expect(s.airBonus, 150);
    expect(s.total, ((200 + 150) * 1.5).round());
  });
}
