import 'package:flutter/material.dart';

/// The three switchable looks. Same game, different paint: colours, outline
/// ink, glow and a pixelation factor for the whole game layer.
enum ArtStyle {
  neon('NEON'),
  comic('KOMIKS'),
  pixel('PIXEL');

  final String label;
  const ArtStyle(this.label);

  ArtStyle get next => values[(index + 1) % values.length];
}

class StyleSpec {
  final Color night;
  final Color rampFill;
  final Color rampEdge;
  final Color coping;
  final Color skater;
  final Color board;
  final Color grip;
  final Color perfect;
  final Color good;
  final Color late;
  final Color miss;
  final Color dim;

  /// Outline colour drawn under every game shape (comic), or null.
  final Color? ink;

  /// Soft blurred halo under lines (neon).
  final bool glow;

  /// Game layer renders at 1/[pixel] resolution and is scaled up without
  /// smoothing. 1 = off.
  final int pixel;

  final TextStyle hud;

  const StyleSpec({
    required this.night,
    required this.rampFill,
    required this.rampEdge,
    required this.coping,
    required this.skater,
    required this.board,
    required this.grip,
    required this.perfect,
    required this.good,
    required this.late,
    required this.miss,
    required this.dim,
    required this.hud,
    this.ink,
    this.glow = false,
    this.pixel = 1,
  });
}

const _ink = Color(0xFF1B1B1B);

/// Four hard offsets read as an outline around the glyphs.
List<Shadow> _outline(Color c, double w) => [
  for (final o in [Offset(-w, -w), Offset(w, -w), Offset(-w, w), Offset(w, w)]) Shadow(color: c, offset: o),
];

final Map<ArtStyle, StyleSpec> styleSpecs = {
  ArtStyle.neon: const StyleSpec(
    night: Color(0xFF0E1018),
    rampFill: Color(0xFF1C2133),
    rampEdge: Color(0xFF3EF0FF),
    coping: Color(0xFFFF4FD8),
    skater: Color(0xFFF4F1E8),
    board: Color(0xFFFFB238),
    grip: Color(0xFF3A3F55),
    perfect: Color(0xFF5CFF8A),
    good: Color(0xFFFFE15C),
    late: Color(0xFFFF9A3C),
    miss: Color(0xFFFF4D5E),
    dim: Color(0x99F4F1E8),
    glow: true,
    hud: TextStyle(
      color: Color(0xFFF4F1E8),
      fontWeight: FontWeight.w900,
      letterSpacing: 1.2,
      shadows: [Shadow(color: Colors.black, blurRadius: 6)],
    ),
  ),
  ArtStyle.comic: StyleSpec(
    night: const Color(0xFFFFF1CF),
    rampFill: const Color(0xFF4AA3DF),
    rampEdge: const Color(0xFF2B6FD6),
    coping: const Color(0xFFE8322B),
    skater: Colors.white,
    board: const Color(0xFFFFC21A),
    grip: _ink,
    perfect: const Color(0xFF2DB84B),
    good: const Color(0xFFF2A900),
    late: const Color(0xFFF07A1A),
    miss: const Color(0xFFE8322B),
    dim: const Color(0xCC1B1B1B),
    ink: _ink,
    hud: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w900,
      fontStyle: FontStyle.italic,
      letterSpacing: 1.0,
      shadows: _outline(_ink, 1.6),
    ),
  ),
  ArtStyle.pixel: const StyleSpec(
    // PICO-8 palette.
    night: Color(0xFF1D2B53),
    rampFill: Color(0xFF5F574F),
    rampEdge: Color(0xFF29ADFF),
    coping: Color(0xFFFF004D),
    skater: Color(0xFFFFF1E8),
    board: Color(0xFFFFA300),
    grip: Color(0xFF000000),
    perfect: Color(0xFF00E436),
    good: Color(0xFFFFEC27),
    late: Color(0xFFFFA300),
    miss: Color(0xFFFF004D),
    dim: Color(0xB3FFF1E8),
    pixel: 4,
    hud: TextStyle(
      color: Color(0xFFFFF1E8),
      fontFamily: 'monospace',
      fontFamilyFallback: ['Courier', 'Menlo'],
      fontWeight: FontWeight.w900,
      letterSpacing: 2,
      shadows: [Shadow(color: Color(0xFF000000), offset: Offset(3, 3))],
    ),
  ),
};

/// Colours of the active [ArtStyle]. Read at paint time, so switching the
/// style restyles everything on the next frame / rebuild.
abstract final class Palette {
  static ArtStyle style = ArtStyle.neon;
  static StyleSpec get spec => styleSpecs[style]!;

  static Color get night => spec.night;
  static Color get rampFill => spec.rampFill;
  static Color get rampEdge => spec.rampEdge;
  static Color get coping => spec.coping;
  static Color get skater => spec.skater;
  static Color get board => spec.board;
  static Color get grip => spec.grip;
  static Color get perfect => spec.perfect;
  static Color get good => spec.good;
  static Color get late => spec.late;
  static Color get miss => spec.miss;
  static Color get dim => spec.dim;
}

TextStyle get hudStyle => Palette.spec.hud;
