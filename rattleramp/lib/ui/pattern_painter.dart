import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'theme.dart';

/// Draws a 3×3 grid with a node path. [progress] 0…1 animates a finger dot
/// along the path (trick book); null draws the whole path statically.
class PatternPainter extends CustomPainter {
  final List<int> path;
  final double? progress;
  final Color color;
  final double strokeScale;

  const PatternPainter(this.path, {this.progress, this.color = Palette.rampEdge, this.strokeScale = 1});

  static Offset nodeCenter(int n, Size size) {
    final cw = size.width / 3;
    final ch = size.height / 3;
    return Offset((n % 3 + 0.5) * cw, (n ~/ 3 + 0.5) * ch);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final unit = math.min(size.width, size.height) / 3;
    final dot = Paint()..color = Palette.dim.withValues(alpha: 0.35);
    for (var n = 0; n < 9; n++) {
      canvas.drawCircle(nodeCenter(n, size), unit * 0.08, dot);
    }
    if (path.length < 2) return;

    final pts = [for (final n in path) nodeCenter(n, size)];
    final segs = pts.length - 1;
    final shown = (progress ?? 1) * segs;

    final line = Paint()
      ..color = color
      ..strokeWidth = unit * 0.11 * strokeScale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final p = Path()..moveTo(pts[0].dx, pts[0].dy);
    var tip = pts[0];
    for (var i = 0; i < segs; i++) {
      final k = (shown - i).clamp(0.0, 1.0);
      if (k <= 0) break;
      tip = Offset.lerp(pts[i], pts[i + 1], k)!;
      p.lineTo(tip.dx, tip.dy);
    }
    canvas.drawPath(p, line);

    // Start marker and, when static, an arrow head showing direction.
    canvas.drawCircle(pts[0], unit * 0.16 * strokeScale, Paint()..color = color);
    if (progress == null) {
      final a = pts[segs - 1];
      final b = pts[segs];
      final ang = math.atan2(b.dy - a.dy, b.dx - a.dx);
      final l = unit * 0.28 * strokeScale;
      final head = Path()
        ..moveTo(b.dx, b.dy)
        ..lineTo(b.dx - l * math.cos(ang - 0.5), b.dy - l * math.sin(ang - 0.5))
        ..moveTo(b.dx, b.dy)
        ..lineTo(b.dx - l * math.cos(ang + 0.5), b.dy - l * math.sin(ang + 0.5));
      canvas.drawPath(head, line);
    } else {
      canvas.drawCircle(tip, unit * 0.2, Paint()..color = Palette.skater.withValues(alpha: 0.85));
    }
  }

  @override
  bool shouldRepaint(PatternPainter old) => old.progress != progress || old.path != path || old.color != color;
}
