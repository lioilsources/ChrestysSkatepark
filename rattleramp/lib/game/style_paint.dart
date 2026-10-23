import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../ui/theme.dart';
import 'rattle_game.dart';

/// One shape of a drawing that follows the active [ArtStyle].
typedef StyledShape = ({Path path, Paint paint});

/// Draws [shapes] in two passes: first every comic ink outline or neon
/// halo, then the shapes themselves — so one limb's outline never cuts
/// across another limb. [ink] is the outline width in canvas units.
void drawStyled(Canvas canvas, List<StyledShape> shapes, {double ink = 0.06}) {
  final spec = Palette.spec;
  if (spec.ink != null) {
    for (final s in shapes) {
      final fill = s.paint.style == PaintingStyle.fill;
      canvas.drawPath(
        s.path,
        Paint()
          ..color = spec.ink!
          ..style = PaintingStyle.stroke
          ..strokeWidth = fill ? ink : s.paint.strokeWidth + ink
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  } else if (spec.glow) {
    for (final s in shapes) {
      final w = s.paint.style == PaintingStyle.fill ? ink : s.paint.strokeWidth;
      canvas.drawPath(
        s.path,
        Paint()
          ..color = s.paint.color.withValues(alpha: 0.45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = w * 2.2
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, w * 1.2),
      );
    }
  }
  for (final s in shapes) {
    canvas.drawPath(s.path, s.paint);
  }
}

Path circlePath(Offset c, double r) => Path()..addOval(Rect.fromCircle(center: c, radius: r));

/// Screen-space backdrop behind the world, one per style.
class BackdropComponent extends Component {
  final RattleGame game;
  BackdropComponent(this.game);

  @override
  void render(Canvas canvas) {
    final size = game.size;
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    canvas.drawRect(rect, Paint()..color = Palette.night);
    switch (Palette.style) {
      case ArtStyle.neon:
        // Faint perspective floor grid.
        final p = Paint()
          ..color = Palette.rampEdge.withValues(alpha: 0.07)
          ..strokeWidth = 1;
        for (var i = 1; i < 12; i++) {
          final y = size.y * (0.55 + 0.45 * math.pow(i / 12, 1.8));
          canvas.drawLine(Offset(0, y), Offset(size.x, y), p);
        }
        for (var i = -10; i <= 10; i++) {
          canvas.drawLine(
            Offset(size.x / 2 + i * size.x * 0.02, size.y * 0.55),
            Offset(size.x / 2 + i * size.x * 0.12, size.y),
            p,
          );
        }
      case ArtStyle.comic:
        // Sunburst rays + halftone dots, the classic panel background.
        final c = Offset(size.x / 2, size.y * 0.45);
        final ray = Paint()..color = const Color(0xFFFFE08A);
        const n = 18;
        for (var i = 0; i < n; i += 2) {
          final a0 = 2 * math.pi * i / n, a1 = 2 * math.pi * (i + 1) / n;
          final r = size.x + size.y;
          canvas.drawPath(
            Path()
              ..moveTo(c.dx, c.dy)
              ..lineTo(c.dx + r * math.cos(a0), c.dy + r * math.sin(a0))
              ..lineTo(c.dx + r * math.cos(a1), c.dy + r * math.sin(a1))
              ..close(),
            ray,
          );
        }
        final dot = Paint()..color = const Color(0x22E8322B);
        const step = 22.0;
        for (var y = 0.0; y < size.y; y += step) {
          final row = (y / step).round();
          for (var x = (row.isOdd ? step / 2 : 0.0); x < size.x; x += step) {
            final k = (x / size.x - 0.5).abs() * 2;
            canvas.drawCircle(Offset(x, y), 2 + 4 * k, dot);
          }
        }
      case ArtStyle.pixel:
        // Banded sunset sky and a few stars; pixelation does the rest.
        const bands = [Color(0xFF1D2B53), Color(0xFF2B2F6B), Color(0xFF7E2553), Color(0xFFAB3B61)];
        for (var i = 0; i < bands.length; i++) {
          canvas.drawRect(Rect.fromLTWH(0, size.y * (0.12 * i), size.x, size.y), Paint()..color = bands[i]);
        }
        final star = Paint()..color = const Color(0xFFFFF1E8);
        final rng = math.Random(7);
        for (var i = 0; i < 40; i++) {
          canvas.drawRect(Rect.fromLTWH(rng.nextDouble() * size.x, rng.nextDouble() * size.y * 0.3, 4, 4), star);
        }
    }
  }
}
