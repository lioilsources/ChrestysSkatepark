import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../core/ride_sim.dart';
import '../ui/theme.dart';
import 'rattle_game.dart';

/// Skater root: placed at the board contact point and rotated to the pose
/// angle. Board and body are separate layers so spin (horizontal squash of
/// the whole rig), flip (board roll) and grab (body pose) compose freely —
/// the same split the sprite version will use in M2.
class SkaterComponent extends PositionComponent {
  final RattleGame game;
  SkaterComponent(this.game) {
    addAll([_BoardLayer(this), _BodyLayer(this)]);
  }

  SkaterPose pose = const SkaterPose(x: 0, y: 0, angle: 0, facing: 1);

  @override
  void update(double dt) {
    pose = game.sim.pose;
    position = Vector2(pose.x, pose.y);
    angle = pose.angle;
  }
}

const double _boardY = 0.1;

class _BoardLayer extends Component {
  final SkaterComponent rig;
  _BoardLayer(this.rig);

  @override
  void render(Canvas canvas) {
    final p = rig.pose;
    canvas.save();
    canvas.scale(p.facing == 0 ? 0.001 : p.facing, 1);
    if (p.bail > 0) {
      canvas.translate(-p.bail * 1.1, 0);
      canvas.rotate(p.bail * 0.5);
    }
    canvas.translate(0, _boardY);
    canvas.scale(1, math.cos(2 * math.pi * p.flipTurns));
    final deck = RRect.fromRectAndRadius(const Rect.fromLTRB(-0.42, -0.03, 0.42, 0.03), const Radius.circular(0.03));
    canvas.drawRRect(deck, Paint()..color = Palette.board);
    final wheel = Paint()..color = Palette.skater;
    canvas.drawCircle(const Offset(-0.27, -0.065), 0.04, wheel);
    canvas.drawCircle(const Offset(0.27, -0.065), 0.04, wheel);
    canvas.restore();
  }
}

class _BodyLayer extends Component {
  final SkaterComponent rig;
  _BodyLayer(this.rig);

  @override
  void render(Canvas canvas) {
    final p = rig.pose;
    canvas.save();
    canvas.scale(p.facing == 0 ? 0.001 : p.facing, 1);
    if (p.bail > 0) {
      canvas.translate(0.2 * p.bail, 0.1);
      canvas.rotate(-1.45 * p.bail);
    }

    final stroke = Paint()
      ..color = Palette.skater
      ..strokeWidth = 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final crouch = p.crouch.clamp(0.0, 1.0);
    const footY = _boardY + 0.04;
    final hipY = footY + 0.85 * (1 - 0.45 * crouch);
    final hip = Offset(-0.02, hipY);
    final kneeOut = 0.12 + 0.2 * crouch;
    final shoulder = Offset(0.04 + 0.16 * crouch, hipY + 0.58 * (1 - 0.2 * crouch));

    for (final fx in [-0.2, 0.2]) {
      final foot = Offset(fx, footY);
      final knee = Offset((fx + hip.dx) / 2 + kneeOut, (footY + hipY) / 2);
      canvas.drawPath(
        Path()
          ..moveTo(foot.dx, foot.dy)
          ..lineTo(knee.dx, knee.dy)
          ..lineTo(hip.dx, hip.dy),
        stroke,
      );
    }
    canvas.drawLine(hip, shoulder, stroke);
    canvas.drawCircle(shoulder + const Offset(0.03, 0.2), 0.13, Paint()..color = Palette.skater);

    // Arms: rest pose, front hand blends towards the board when grabbing.
    final restFront = shoulder + const Offset(0.32, -0.25);
    final restBack = shoulder + const Offset(-0.3, -0.18);
    final grabTarget = Offset(p.grabAt * 0.33, _boardY + 0.05);
    final front = Offset.lerp(restFront, grabTarget, p.grab)!;
    for (final hand in [front, restBack]) {
      final elbow = Offset.lerp(shoulder, hand, 0.5)! + const Offset(0, 0.08);
      canvas.drawPath(
        Path()
          ..moveTo(shoulder.dx, shoulder.dy)
          ..lineTo(elbow.dx, elbow.dy)
          ..lineTo(hand.dx, hand.dy),
        stroke..strokeWidth = 0.07,
      );
    }
    canvas.restore();
  }
}
