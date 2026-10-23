import 'package:flutter/material.dart';

/// Neon-on-night palette. Placeholder until the bar branding is decided
/// (open question 2 in the plan).
abstract final class Palette {
  static const night = Color(0xFF0E1018);
  static const rampFill = Color(0xFF1C2133);
  static const rampEdge = Color(0xFF3EF0FF);
  static const coping = Color(0xFFFF4FD8);
  static const skater = Color(0xFFF4F1E8);
  static const board = Color(0xFFFFB238);
  static const grip = Color(0xFF3A3F55);
  static const perfect = Color(0xFF5CFF8A);
  static const good = Color(0xFFFFE15C);
  static const late = Color(0xFFFF9A3C);
  static const miss = Color(0xFFFF4D5E);
  static const dim = Color(0x99F4F1E8);
}

const TextStyle hudStyle = TextStyle(
  color: Palette.skater,
  fontWeight: FontWeight.w900,
  letterSpacing: 1.2,
  shadows: [Shadow(color: Colors.black, blurRadius: 6)],
);
