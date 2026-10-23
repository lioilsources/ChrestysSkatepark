import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextPainter, TextSpan, TextStyle, TextDirection, FontWeight;

import '../ui/theme.dart';
import 'rattle_game.dart';

/// Static U-ramp with decks. Path is rebuilt only when geometry changes.
class RampComponent extends Component {
  final RattleGame game;
  RampComponent(this.game);

  Path? _surface;
  Path? _fill;
  TextPainter? _logo;

  void _build() {
    final ramp = game.sim.ramp;
    final deck = game.sim.ramp.copingX + 1.6;
    final h = ramp.copingHeight;
    final surface = Path()..moveTo(-deck, h);
    const samples = 160;
    for (var i = 0; i <= samples; i++) {
      final p = ramp.point(ramp.length * i / samples);
      surface.lineTo(p.x, p.y);
    }
    surface.lineTo(deck, h);
    _surface = surface;
    _fill = Path.from(surface)
      ..lineTo(deck, -2)
      ..lineTo(-deck, -2)
      ..close();
    _logo = TextPainter(
      text: const TextSpan(
        text: 'U CHŘESTÝŠE',
        style: TextStyle(color: Palette.coping, fontSize: 0.42, fontWeight: FontWeight.w900, letterSpacing: 0.08),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  @override
  void render(Canvas canvas) {
    if (_surface == null) _build();
    canvas.drawPath(_fill!, Paint()..color = Palette.rampFill);
    canvas.drawPath(
      _surface!,
      Paint()
        ..color = Palette.rampEdge
        ..style = PaintingStyle.stroke
        ..strokeWidth = 0.07
        ..strokeJoin = StrokeJoin.round,
    );
    final cop = Paint()..color = Palette.coping;
    for (final side in [-1, 1]) {
      final c = game.sim.ramp.coping(side);
      canvas.drawCircle(Offset(c.x, c.y), 0.09, cop);
    }
    // Logo on the flat face; text needs y flipped back.
    final logo = _logo!;
    canvas.save();
    canvas.translate(-logo.width / 2, -0.35);
    canvas.scale(1, -1);
    logo.paint(canvas, Offset.zero);
    canvas.restore();
  }
}
