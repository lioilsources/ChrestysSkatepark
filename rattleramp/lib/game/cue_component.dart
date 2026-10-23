import 'dart:ui';

import 'package:flame/components.dart';

import '../core/ride_sim.dart';
import '../ui/theme.dart';
import 'rattle_game.dart';
import 'style_paint.dart';

/// Rhythm-game cue: a ring that shrinks onto the coping and meets the
/// target ring exactly when the skater leaves the edge. Readable without
/// sound.
class CueComponent extends Component {
  final RattleGame game;
  CueComponent(this.game);

  static const double _target = 0.34;
  static const double _spread = 1.9;

  @override
  void render(Canvas canvas) {
    final sim = game.sim;
    if (game.autopilot) return;
    if (sim.phase != RidePhase.rolling && sim.phase != RidePhase.dropIn) return;
    final tte = sim.timeToEdge;
    final lead = sim.config.cueLead;
    if (tte > lead || sim.hasAttempt) return;

    final c = sim.ramp.coping(sim.edgeSide);
    final at = Offset(c.x, c.y);
    final k = (tte / lead).clamp(0.0, 1.0);
    final fade = (1 - k) * 0.8 + 0.2;

    final color = tte.abs() <= sim.perfectWindow
        ? Palette.perfect
        : tte.abs() <= sim.goodWindow
        ? Palette.good
        : Palette.skater;

    drawStyled(canvas, [
      (
        path: circlePath(at, _target),
        paint: Paint()
          ..color = Palette.coping.withValues(alpha: 0.9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.06,
      ),
      (
        path: circlePath(at, _target + _spread * k),
        paint: Paint()
          ..color = color.withValues(alpha: fade)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.08 + 0.06 * (1 - k),
      ),
    ]);
  }
}
