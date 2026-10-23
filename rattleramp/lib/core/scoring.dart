/// body = Σ(token.base) × timing × speed × combo × variety + air_height_bonus
library;

import 'trick_parser.dart';

enum Timing { perfect, good, late, miss }

double timingMultiplier(Timing t) => switch (t) {
  Timing.perfect => 1.5,
  Timing.good => 1.0,
  Timing.late => 0.6,
  Timing.miss => 0.0,
};

/// 1.0 for the first time in a ride, 0.5 the second, 0.25 after that.
double varietyMultiplier(int previousCount) => switch (previousCount) {
  0 => 1.0,
  1 => 0.5,
  _ => 0.25,
};

class ScoreBreakdown {
  final int base;
  final double timing;
  final double speed;
  final double combo;
  final double variety;
  final double daily;
  final int airBonus;
  final int total;

  const ScoreBreakdown({
    required this.base,
    required this.timing,
    required this.speed,
    required this.combo,
    required this.variety,
    required this.daily,
    required this.airBonus,
    required this.total,
  });
}

ScoreBreakdown scoreTrick({
  required ParsedTrick trick,
  required Timing timing,
  required double speed,
  required int streak,
  required int previousCount,
  required double airHeight,
  bool proMode = false,
  String? dailyTokenId,
}) {
  final base = trick.baseSum;
  final tm = timingMultiplier(timing);
  final sm = 1.0 + speed.clamp(0.0, 1.0);
  final cm = 1.0 + 0.1 * streak;
  final vm = varietyMultiplier(previousCount);
  final dm = dailyTokenId != null && trick.tokens.any((t) => t.id == dailyTokenId) ? 2.0 : 1.0;
  final air = airHeight > 0.8 ? ((airHeight - 0.8) * 150).round() : 0;
  final raw = base * tm * sm * cm * vm * dm + air;
  return ScoreBreakdown(
    base: base,
    timing: tm,
    speed: sm,
    combo: cm,
    variety: vm,
    daily: dm,
    airBonus: air,
    total: (raw * (proMode ? 1.5 : 1.0)).round(),
  );
}
