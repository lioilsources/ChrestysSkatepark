/// Side-view U-ramp profile. World units are metres, y up, x = 0 at the
/// middle of the flat. Path parameter s runs from the left coping (s = 0)
/// down the left wall, across the flat and up to the right coping (s = length).
library;

import 'dart:math' as math;

class Vec {
  final double x;
  final double y;
  const Vec(this.x, this.y);
}

class Ramp {
  final double radius;
  final double flat;
  final double vert;

  const Ramp({required this.radius, required this.flat, required this.vert});

  double get arc => radius * math.pi / 2;
  double get length => 2 * vert + 2 * arc + flat;
  double get copingHeight => radius + vert;
  double get copingX => flat / 2 + radius;

  /// Coping position; [side] is -1 for left, +1 for right.
  Vec coping(int side) => Vec(side * copingX, copingHeight);

  Vec point(double s) {
    final hf = flat / 2;
    if (s <= vert) return Vec(-copingX, copingHeight - s);
    s -= vert;
    if (s <= arc) {
      final u = s / radius;
      return Vec(-hf - radius * math.cos(u), radius - radius * math.sin(u));
    }
    s -= arc;
    if (s <= flat) return Vec(-hf + s, 0);
    s -= flat;
    if (s <= arc) {
      final u = s / radius;
      return Vec(hf + radius * math.sin(u), radius - radius * math.cos(u));
    }
    s -= arc;
    return Vec(copingX, radius + s);
  }

  /// Tangent angle (radians) in the direction of increasing s.
  double tangent(double s) {
    if (s <= vert) return -math.pi / 2;
    s -= vert;
    if (s <= arc) return -math.pi / 2 + s / radius;
    s -= arc;
    if (s <= flat) return 0;
    s -= flat;
    if (s <= arc) return s / radius;
    return math.pi / 2;
  }

  double height(double s) => point(s).y;
}
