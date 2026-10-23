import 'dart:math' as math;
import 'dart:ui';

import 'package:flame/components.dart';

import '../core/ride_sim.dart';
import '../core/trick_defs.dart';
import '../ui/theme.dart';
import 'rattle_game.dart';

/// Skater root: placed at the board contact point and rotated to the pose
/// angle. Board and body are separate layers so spin (horizontal squash of
/// the whole rig), flip (board rotation) and grab (body shape) compose
/// freely — the same split the sprite version will use in M2.
///
/// Every frame [update] solves one [_Rig] in skater-local metres (y up,
/// +x = facing forward); both layers draw from it.
class SkaterComponent extends PositionComponent {
  final RattleGame game;
  SkaterComponent(this.game) {
    addAll([_BoardLayer(this), _BodyLayer(this)]);
  }

  SkaterPose pose = const SkaterPose(x: 0, y: 0, angle: 0, facing: 1);
  late _Rig _rig = _Rig.solve(const SkaterPose(x: 0, y: 0, angle: 0, facing: 1));

  @override
  void update(double dt) {
    pose = game.sim.pose;
    _rig = _Rig.solve(pose);
    position = Vector2(pose.x, pose.y);
    angle = pose.angle;
  }
}

const double _boardY = 0.1;
const double _footY = _boardY + 0.04;
const double _thigh = 0.46;
const double _shin = 0.46;
const double _upperArm = 0.3;
const double _forearm = 0.3;

/// Target shape of each grab style at full grab; blended in by `pose.grab`.
class _StyleShape {
  /// Board centre offset and tilt (rad, + = nose up).
  final Offset board;
  final double tilt;
  final double crouch;

  /// Feet in board-local coordinates, or null = foot leaves the board and
  /// goes to the matching skater-local position in [freeFeet].
  final List<Offset?> feetOnBoard;
  final List<Offset> freeFeet;

  /// Where the free (non-grabbing) back hand goes, relative to the shoulder.
  final Offset backArm;

  const _StyleShape({
    required this.board,
    this.tilt = 0,
    required this.crouch,
    this.feetOnBoard = const [Offset(-0.2, 0.04), Offset(0.2, 0.04)],
    this.freeFeet = const [Offset.zero, Offset.zero],
    this.backArm = const Offset(-0.3, -0.18),
  });
}

const Map<GrabStyle, _StyleShape> _shapes = {
  GrabStyle.tuck: _StyleShape(board: Offset(0, 0.22), crouch: 0.9),
  GrabStyle.tweak: _StyleShape(board: Offset(-0.32, 0.42), tilt: 0.75, crouch: 0.75, backArm: Offset(-0.15, 0.3)),
  GrabStyle.stiff: _StyleShape(
    board: Offset(0.22, 0.3),
    tilt: 1.0,
    crouch: 0.35,
    feetOnBoard: [Offset(-0.36, 0.04), Offset(-0.14, 0.04)],
    backArm: Offset(-0.45, 0.05),
  ),
  GrabStyle.split: _StyleShape(
    board: Offset(0.42, 0.35),
    tilt: 0.35,
    crouch: 0.1,
    feetOnBoard: [null, null],
    freeFeet: [Offset(-0.45, 0.12), Offset(0.38, -0.02)],
    backArm: Offset(-0.5, 0.2),
  ),
  GrabStyle.kick: _StyleShape(
    board: Offset(0.12, 0.2),
    tilt: -0.15,
    crouch: 0.45,
    feetOnBoard: [null, Offset(0.2, 0.04)],
    freeFeet: [Offset(-0.25, -0.42), Offset.zero],
    backArm: Offset(-0.5, 0.25),
  ),
  GrabStyle.spread: _StyleShape(
    board: Offset(0.55, 0.95),
    tilt: 1.45,
    crouch: 0,
    feetOnBoard: [null, null],
    freeFeet: [Offset(-0.06, -0.08), Offset(0.06, -0.06)],
    backArm: Offset(-0.62, 0.12),
  ),
};

/// Solved skeleton for one frame.
class _Rig {
  final Offset boardCentre;
  final double boardTilt;
  final Offset hip;
  final Offset shoulder;
  final List<Offset> feet;
  final List<Offset> hands; // [front, back]

  const _Rig(this.boardCentre, this.boardTilt, this.hip, this.shoulder, this.feet, this.hands);

  factory _Rig.solve(SkaterPose p) {
    final g = p.grab.clamp(0.0, 1.0);
    final look = p.grabLook;
    final shape = _shapes[look.style]!;

    // Board: lifted towards the body by a grab, dropped below the feet by a flip.
    final boardCentre = Offset(shape.board.dx * g, _boardY + shape.board.dy * g - 0.08 * p.flip);
    final tilt = (shape.tilt + look.tilt) * g;
    Offset onBoard(Offset local) {
      final c = math.cos(tilt), s = math.sin(tilt);
      return boardCentre + Offset(local.dx * c - local.dy * s, local.dx * s + local.dy * c) - const Offset(0, _boardY);
    }

    final crouch = (p.crouch + (shape.crouch - p.crouch) * g).clamp(0.0, 1.0);
    final hipY = _footY + 0.85 * (1 - 0.45 * crouch) + 0.1 * p.flip;
    final hip = Offset(-0.02, hipY);
    final shoulder = Offset(0.04 + 0.16 * crouch, hipY + 0.58 * (1 - 0.2 * crouch));

    // Feet ride on the board unless the style kicks them off. A flip tucks
    // them up off the deck.
    final feet = <Offset>[];
    for (var i = 0; i < 2; i++) {
      final rest = Offset(i == 0 ? -0.2 : 0.2, _footY + 0.1 * p.flip);
      final anchor = shape.feetOnBoard[i];
      final target = anchor != null ? onBoard(anchor) + Offset(0, 0.1 * p.flip) : shape.freeFeet[i];
      feet.add(Offset.lerp(rest, target, g)!);
    }

    // Hands: grabbing hand(s) go to the grab spot on the board.
    final spot = onBoard(Offset(look.at * 0.36, _boardY + 0.04));
    final restFront = shoulder + const Offset(0.32, -0.25);
    final restBack = shoulder + Offset.lerp(const Offset(-0.3, -0.18), shape.backArm, g)!;
    final front = look.hand == GrabHand.back ? restFront : Offset.lerp(restFront, spot, g)!;
    final back = switch (look.hand) {
      GrabHand.front => restBack,
      GrabHand.back => Offset.lerp(restBack, spot, g)!,
      GrabHand.both => Offset.lerp(restBack, spot - const Offset(0.12, 0), g)!,
    };

    return _Rig(boardCentre, tilt, hip, shoulder, feet, [front, back]);
  }
}

/// Two-bone IK: middle joint for a limb from [a] to [b], bent towards [bend].
Offset _joint(Offset a, Offset b, double l1, double l2, Offset bend) {
  final d = (b - a).distance.clamp(0.001, l1 + l2 - 0.001);
  final dir = (b - a) / (b - a).distance.clamp(0.001, double.infinity);
  final along = (l1 * l1 - l2 * l2 + d * d) / (2 * d);
  final h = math.sqrt(math.max(0, l1 * l1 - along * along));
  var perp = Offset(-dir.dy, dir.dx);
  if (perp.dx * bend.dx + perp.dy * bend.dy < 0) perp = -perp;
  return a + dir * along + perp * h;
}

class _BoardLayer extends Component {
  final SkaterComponent sk;
  _BoardLayer(this.sk);

  static final _deck = Paint()..color = Palette.board;
  static final _grip = Paint()..color = Palette.grip;
  static final _wheel = Paint()..color = Palette.skater;

  @override
  void render(Canvas canvas) {
    final p = sk.pose;
    final r = sk._rig;
    canvas.save();
    canvas.scale(p.facing == 0 ? 0.001 : p.facing, 1);
    if (p.bail > 0) {
      canvas.translate(-p.bail * 1.1, 0);
      canvas.rotate(p.bail * 0.5);
    }
    canvas.translate(r.boardCentre.dx, r.boardCentre.dy);
    canvas.rotate(r.boardTilt);

    // Tumble wraps end over end around the back foot.
    if (p.tumble != 0) {
      canvas.translate(-0.3, 0);
      canvas.rotate(-2 * math.pi * p.tumble);
      canvas.translate(0.3, 0);
    }

    // Shove: rotation about the vertical axis foreshortens the length.
    // The board also drifts towards the side it is spinning to, so
    // backside and frontside shove-its read apart.
    final cs = math.cos(2 * math.pi * p.shove);
    canvas.translate(0.1 * math.sin(2 * math.pi * p.shove), 0);
    canvas.scale(cs.abs() < 0.14 ? 0.14 * (cs < 0 ? -1 : 1) : cs, 1);

    // Roll: seen from slightly above, so the deck face shows as it turns
    // and the board bobs one way for kickflips, the other for heelflips.
    final a = 2 * math.pi * p.roll;
    final cr = math.cos(a), sr = math.sin(a);
    canvas.translate(0, 0.05 * sr);
    final half = 0.03 + 0.07 * sr.abs();
    final deck = RRect.fromRectAndRadius(Rect.fromLTRB(-0.42, -half, 0.42, half), Radius.circular(half));
    canvas.drawRRect(deck, _deck);
    if (sr.abs() > 0.15) {
      // Face towards the viewer: grip on top half of the turn, graphic below.
      final face = RRect.fromRectAndRadius(
        Rect.fromLTRB(-0.38, -half * 0.7, 0.38, half * 0.7),
        Radius.circular(half * 0.7),
      );
      canvas.drawRRect(face, sr > 0 ? _grip : _deck);
    }
    if (cr.abs() > 0.25) {
      final wy = -(half + 0.035) * cr.sign;
      canvas.drawCircle(Offset(-0.27, wy), 0.04, _wheel);
      canvas.drawCircle(Offset(0.27, wy), 0.04, _wheel);
    }
    canvas.restore();
  }
}

class _BodyLayer extends Component {
  final SkaterComponent sk;
  _BodyLayer(this.sk);

  static final _stroke = Paint()
    ..color = Palette.skater
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..style = PaintingStyle.stroke;
  static final _fill = Paint()..color = Palette.skater;

  @override
  void render(Canvas canvas) {
    final p = sk.pose;
    final r = sk._rig;
    canvas.save();
    canvas.scale(p.facing == 0 ? 0.001 : p.facing, 1);
    if (p.bail > 0) {
      canvas.translate(0.2 * p.bail, 0.1);
      canvas.rotate(-1.45 * p.bail);
    }

    void limb(Offset a, Offset b, double l1, double l2, Offset bend, double width) {
      final j = _joint(a, b, l1, l2, bend);
      canvas.drawPath(
        Path()
          ..moveTo(a.dx, a.dy)
          ..lineTo(j.dx, j.dy)
          ..lineTo(b.dx, b.dy),
        _stroke..strokeWidth = width,
      );
    }

    for (final foot in r.feet) {
      limb(r.hip, foot, _thigh, _shin, const Offset(1, 0), 0.09);
    }
    canvas.drawLine(r.hip, r.shoulder, _stroke..strokeWidth = 0.09);
    canvas.drawCircle(r.shoulder + const Offset(0.03, 0.2), 0.13, _fill);
    for (final hand in r.hands) {
      limb(r.shoulder, hand, _upperArm, _forearm, const Offset(0, -1), 0.07);
    }
    canvas.restore();
  }
}
