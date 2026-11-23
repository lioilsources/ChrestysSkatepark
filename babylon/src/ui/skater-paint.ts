// Port of rattleramp/lib/game/skater_component.dart (paintSkater) to Canvas 2D.
// Board and body in skater-local metres (y up, +x = facing forward). Board and body
// stay separate so spin (horizontal squash), flip (board rotation) and grab (body
// shape) compose freely. The caller sets a y-up transform (metres → pixels).
// Head sprites and deck graphics come in F3 (avatar_sprites.dart); until then the
// head is the Dart fallback circle.
import { avatarOutfit, type Avatar } from '../rules/avatar';
import type { SkaterPose } from '../rules/ride-sim';
import type { GrabStyle } from '../rules/trick-defs';
import { NEON } from './palette';

interface P { x: number; y: number }
const pt = (x: number, y: number): P => ({ x, y });
const add = (a: P, b: P): P => pt(a.x + b.x, a.y + b.y);
const sub = (a: P, b: P): P => pt(a.x - b.x, a.y - b.y);
const mul = (a: P, k: number): P => pt(a.x * k, a.y * k);
const lerp = (a: P, b: P, t: number): P => pt(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t);
const dist = (a: P): number => Math.hypot(a.x, a.y);
const clamp = (v: number, lo: number, hi: number): number => Math.min(hi, Math.max(lo, v));

/** ARGB int (Dart Color) → CSS colour. */
export const argbToCss = (c: number): string => {
  const a = ((c >>> 24) & 0xff) / 255;
  return `rgba(${(c >>> 16) & 0xff},${(c >>> 8) & 0xff},${c & 0xff},${a})`;
};

const BOARD_Y = 0.1;
const FOOT_Y = BOARD_Y + 0.04;
const THIGH = 0.46;
const SHIN = 0.46;
const UPPER_ARM = 0.3;
const FOREARM = 0.3;

interface StyleShape {
  board: P;
  tilt: number;
  crouch: number;
  /** Feet in board-local coordinates, or null = foot leaves the board (goes to freeFeet). */
  feetOnBoard: (P | null)[];
  freeFeet: P[];
  backArm: P;
}

const shape = (s: Partial<StyleShape> & Pick<StyleShape, 'board' | 'crouch'>): StyleShape => ({
  tilt: 0, feetOnBoard: [pt(-0.2, 0.04), pt(0.2, 0.04)], freeFeet: [pt(0, 0), pt(0, 0)], backArm: pt(-0.3, -0.18), ...s,
});

const SHAPES: Record<GrabStyle, StyleShape> = {
  tuck: shape({ board: pt(0, 0.22), crouch: 0.9 }),
  tweak: shape({ board: pt(-0.32, 0.42), tilt: 0.75, crouch: 0.75, backArm: pt(-0.15, 0.3) }),
  stiff: shape({ board: pt(0.22, 0.3), tilt: 1.0, crouch: 0.35, feetOnBoard: [pt(-0.36, 0.04), pt(-0.14, 0.04)], backArm: pt(-0.45, 0.05) }),
  split: shape({ board: pt(0.42, 0.35), tilt: 0.35, crouch: 0.1, feetOnBoard: [null, null], freeFeet: [pt(-0.45, 0.12), pt(0.38, -0.02)], backArm: pt(-0.5, 0.2) }),
  kick: shape({ board: pt(0.12, 0.2), tilt: -0.15, crouch: 0.45, feetOnBoard: [null, pt(0.2, 0.04)], freeFeet: [pt(-0.25, -0.42), pt(0, 0)], backArm: pt(-0.5, 0.25) }),
  spread: shape({ board: pt(0.55, 0.95), tilt: 1.45, crouch: 0, feetOnBoard: [null, null], freeFeet: [pt(-0.06, -0.08), pt(0.06, -0.06)], backArm: pt(-0.62, 0.12) }),
};

interface Rig { boardCentre: P; boardTilt: number; hip: P; shoulder: P; feet: P[]; hands: [P, P] }

function solveRig(p: SkaterPose): Rig {
  const g = clamp(p.grab, 0, 1);
  const look = p.grabLook;
  const s = SHAPES[look.style];
  // Board: lifted towards the body by a grab, dropped below the feet by a flip.
  const boardCentre = pt(s.board.x * g, BOARD_Y + s.board.y * g - 0.08 * p.flip);
  const tilt = (s.tilt + look.tilt) * g;
  const onBoard = (l: P): P => {
    const c = Math.cos(tilt), sn = Math.sin(tilt);
    return sub(add(boardCentre, pt(l.x * c - l.y * sn, l.x * sn + l.y * c)), pt(0, BOARD_Y));
  };
  const crouch = clamp(p.crouch + (s.crouch - p.crouch) * g, 0, 1);
  const hipY = FOOT_Y + 0.85 * (1 - 0.45 * crouch) + 0.1 * p.flip;
  const hip = pt(-0.02, hipY);
  const shoulder = pt(0.04 + 0.16 * crouch, hipY + 0.58 * (1 - 0.2 * crouch));
  // Feet ride on the board unless the style kicks them off; a flip tucks them up.
  const feet: P[] = [];
  for (let i = 0; i < 2; i++) {
    const rest = pt(i === 0 ? -0.2 : 0.2, FOOT_Y + 0.1 * p.flip);
    const anchor = s.feetOnBoard[i];
    const target = anchor ? add(onBoard(anchor), pt(0, 0.1 * p.flip)) : s.freeFeet[i];
    feet.push(lerp(rest, target, g));
  }
  // Hands: grabbing hand(s) go to the grab spot on the board.
  const spot = onBoard(pt(look.at * 0.36, BOARD_Y + 0.04));
  const restFront = add(shoulder, pt(0.32, -0.25));
  const restBack = add(shoulder, lerp(pt(-0.3, -0.18), s.backArm, g));
  const front = look.hand === 'back' ? restFront : lerp(restFront, spot, g);
  const back = look.hand === 'front' ? restBack
    : look.hand === 'back' ? lerp(restBack, spot, g)
      : lerp(restBack, sub(spot, pt(0.12, 0)), g);
  return { boardCentre, boardTilt: tilt, hip, shoulder, feet, hands: [front, back] };
}

/** Two-bone IK: middle joint for a limb from a to b, bent towards bend. */
function joint(a: P, b: P, l1: number, l2: number, bend: P): P {
  const ab = sub(b, a);
  const d = clamp(dist(ab), 0.001, l1 + l2 - 0.001);
  const dir = mul(ab, 1 / Math.max(dist(ab), 0.001));
  const along = (l1 * l1 - l2 * l2 + d * d) / (2 * d);
  const h = Math.sqrt(Math.max(0, l1 * l1 - along * along));
  let perp = pt(-dir.y, dir.x);
  if (perp.x * bend.x + perp.y * bend.y < 0) perp = mul(perp, -1);
  return add(add(a, mul(dir, along)), mul(perp, h));
}

// ── Styled drawing (style_paint.dart drawStyled, neon only until F3) ──────

interface Shape { path: Path2D; fill?: string; stroke?: string; width?: number }

const circle = (c: P, r: number): Path2D => {
  const p = new Path2D();
  p.arc(c.x, c.y, r, 0, Math.PI * 2);
  return p;
};
const line = (...pts: P[]): Path2D => {
  const p = new Path2D();
  pts.forEach((q, i) => (i === 0 ? p.moveTo(q.x, q.y) : p.lineTo(q.x, q.y)));
  return p;
};
const rrect = (l: number, b: number, r: number, t: number, rad: number): Path2D => {
  const p = new Path2D();
  p.roundRect(l, b, r - l, t - b, Math.max(0, rad));
  return p;
};

/** Neon: a soft halo pass under every shape, then the shapes (drawStyled). */
function drawStyled(g: CanvasRenderingContext2D, shapes: Shape[], ink = 0.06): void {
  g.save();
  g.lineCap = 'round';
  g.lineJoin = 'round';
  g.globalAlpha = 0.45;
  for (const s of shapes) {
    const w = s.stroke ? s.width ?? 0.05 : ink;
    g.strokeStyle = s.stroke ?? s.fill ?? '#fff';
    g.lineWidth = w * 2.2;
    g.shadowColor = g.strokeStyle;
    g.shadowBlur = w * 1.2 * Math.abs(g.getTransform().a);
    g.stroke(s.path);
  }
  g.restore();
  g.save();
  g.lineCap = 'round';
  g.lineJoin = 'round';
  for (const s of shapes) {
    if (s.fill) {
      g.fillStyle = s.fill;
      g.fill(s.path);
    }
    if (s.stroke) {
      g.strokeStyle = s.stroke;
      g.lineWidth = s.width ?? 0.05;
      g.stroke(s.path);
    }
  }
  g.restore();
}

function paintBoard(g: CanvasRenderingContext2D, p: SkaterPose, r: Rig): void {
  g.save();
  g.scale(p.facing === 0 ? 0.001 : p.facing, 1);
  if (p.bail > 0) {
    g.translate(-p.bail * 1.1, 0);
    g.rotate(p.bail * 0.5);
  }
  g.translate(r.boardCentre.x, r.boardCentre.y);
  g.rotate(r.boardTilt);
  // Tumble wraps end over end around the back foot.
  if (p.tumble !== 0) {
    g.translate(-0.3, 0);
    g.rotate(-2 * Math.PI * p.tumble);
    g.translate(0.3, 0);
  }
  // Shove: rotation about the vertical axis foreshortens the length and drifts sideways.
  const cs = Math.cos(2 * Math.PI * p.shove);
  g.translate(0.1 * Math.sin(2 * Math.PI * p.shove), 0);
  g.scale(Math.abs(cs) < 0.14 ? 0.14 * (cs < 0 ? -1 : 1) : cs, 1);
  // Roll: seen from slightly above, the deck face shows as it turns.
  const a = 2 * Math.PI * p.roll;
  const cr = Math.cos(a), sr = Math.sin(a);
  g.translate(0, 0.05 * sr);
  const half = 0.03 + 0.07 * Math.abs(sr);
  const wy = -(half + 0.035) * Math.sign(cr);
  const shapes: Shape[] = [];
  if (Math.abs(cr) > 0.25) {
    shapes.push({ path: circle(pt(-0.27, wy), 0.04), fill: NEON.skater }, { path: circle(pt(0.27, wy), 0.04), fill: NEON.skater });
  }
  shapes.push({ path: rrect(-0.42, -half, 0.42, half, half), fill: NEON.board });
  if (Math.abs(sr) > 0.15) {
    shapes.push({ path: rrect(-0.38, -half * 0.7, 0.38, half * 0.7, half * 0.7), fill: sr > 0 ? NEON.grip : NEON.board });
  }
  drawStyled(g, shapes, 0.04);
  g.restore();
}

function paintBody(g: CanvasRenderingContext2D, p: SkaterPose, r: Rig, avatar: Avatar): void {
  g.save();
  g.scale(p.facing === 0 ? 0.001 : p.facing, 1);
  if (p.bail > 0) {
    g.translate(0.2 * p.bail, 0.1);
    g.rotate(-1.45 * p.bail);
  }
  const outfit = avatarOutfit(avatar);
  const skin = argbToCss(avatar.preset.skin);
  const leg = (foot: P): Shape[] => {
    const knee = joint(r.hip, foot, THIGH, SHIN, pt(1, 0));
    return [
      { path: line(r.hip, knee, foot), stroke: argbToCss(outfit.pants), width: 0.13 },
      { path: rrect(foot.x + 0.05 - 0.11, foot.y + 0.01 - 0.045, foot.x + 0.05 + 0.11, foot.y + 0.01 + 0.045, 0.04), fill: argbToCss(outfit.shoes) },
    ];
  };
  const arm = (hand: P): Shape[] => {
    const elbow = joint(r.shoulder, hand, UPPER_ARM, FOREARM, pt(0, -1));
    return [
      { path: line(elbow, hand), stroke: skin, width: 0.075 },
      { path: line(r.shoulder, elbow), stroke: argbToCss(outfit.shirt), width: 0.11 },
      { path: circle(hand, 0.05), fill: skin },
    ];
  };
  // Mascot: a rattle tail swinging behind the hips.
  const tail: Shape[] = [];
  if (avatar.preset.mascot) {
    const tip = add(r.hip, pt(-0.55, -0.05));
    const t = new Path2D();
    t.moveTo(r.hip.x, r.hip.y);
    t.quadraticCurveTo(r.hip.x - 0.35, r.hip.y - 0.35, tip.x, tip.y);
    tail.push({ path: t, stroke: skin, width: 0.1 });
    for (let i = 0; i < 3; i++) tail.push({ path: circle(add(tip, pt(-0.05 * i, 0.07 * i)), 0.055 - 0.008 * i), fill: '#F2D49B' });
  }
  drawStyled(g, [
    ...tail,
    ...arm(r.hands[1]),
    ...r.feet.flatMap(leg),
    { path: line(r.hip, r.shoulder), stroke: argbToCss(outfit.shirt), width: 0.24 },
  ]);
  // Head: sprite in F3; Dart fallback is a plain circle.
  drawStyled(g, [{ path: circle(add(r.shoulder, pt(0.03, 0.2)), 0.15), fill: skin }]);
  drawStyled(g, arm(r.hands[0]));
  g.restore();
}

/** Draws the skater at the current transform origin (board contact point, y up, metres). */
export function paintSkater(g: CanvasRenderingContext2D, p: SkaterPose, avatar: Avatar): void {
  const rig = solveRig(p);
  paintBoard(g, p, rig);
  paintBody(g, p, rig, avatar);
}
