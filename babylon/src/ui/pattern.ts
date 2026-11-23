// Port of rattleramp/lib/ui/pattern_painter.dart: a 3×3 grid with a node path.
// progress 0…1 animates a finger dot along the path (trick book, F3);
// null draws the whole path with an arrow head.
import { NEON } from './palette';

const DOT = 'rgba(244,241,232,0.21)'; // Palette.dim at alpha 0.35

export function nodeCenter(n: number, w: number, h: number): { x: number; y: number } {
  return { x: ((n % 3) + 0.5) * (w / 3), y: (Math.trunc(n / 3) + 0.5) * (h / 3) };
}

export function drawPattern(
  g: CanvasRenderingContext2D, w: number, h: number, path: readonly number[],
  opts: { progress?: number | null; color?: string; strokeScale?: number } = {},
): void {
  const color = opts.color ?? NEON.rampEdge;
  const ss = opts.strokeScale ?? 1;
  const progress = opts.progress ?? null;
  const unit = Math.min(w, h) / 3;
  g.fillStyle = DOT;
  for (let n = 0; n < 9; n++) {
    const c = nodeCenter(n, w, h);
    g.beginPath();
    g.arc(c.x, c.y, unit * 0.08, 0, Math.PI * 2);
    g.fill();
  }
  if (path.length < 2) return;
  const pts = path.map((n) => nodeCenter(n, w, h));
  const segs = pts.length - 1;
  const shown = (progress ?? 1) * segs;
  g.strokeStyle = color;
  g.lineWidth = unit * 0.11 * ss;
  g.lineCap = 'round';
  g.lineJoin = 'round';
  g.beginPath();
  g.moveTo(pts[0].x, pts[0].y);
  let tip = pts[0];
  for (let i = 0; i < segs; i++) {
    const k = Math.min(1, Math.max(0, shown - i));
    if (k <= 0) break;
    tip = { x: pts[i].x + (pts[i + 1].x - pts[i].x) * k, y: pts[i].y + (pts[i + 1].y - pts[i].y) * k };
    g.lineTo(tip.x, tip.y);
  }
  g.stroke();
  // Start marker and, when static, an arrow head showing direction.
  g.fillStyle = color;
  g.beginPath();
  g.arc(pts[0].x, pts[0].y, unit * 0.16 * ss, 0, Math.PI * 2);
  g.fill();
  if (progress === null) {
    const a = pts[segs - 1];
    const b = pts[segs];
    const ang = Math.atan2(b.y - a.y, b.x - a.x);
    const l = unit * 0.28 * ss;
    g.beginPath();
    g.moveTo(b.x, b.y);
    g.lineTo(b.x - l * Math.cos(ang - 0.5), b.y - l * Math.sin(ang - 0.5));
    g.moveTo(b.x, b.y);
    g.lineTo(b.x - l * Math.cos(ang + 0.5), b.y - l * Math.sin(ang + 0.5));
    g.stroke();
  } else {
    g.fillStyle = 'rgba(244,241,232,0.85)';
    g.beginPath();
    g.arc(tip.x, tip.y, unit * 0.2, 0, Math.PI * 2);
    g.fill();
  }
}

/** A small canvas element showing a static pattern, sized by CSS. */
export function patternCanvas(path: readonly number[], cssSize: number): HTMLCanvasElement {
  const c = document.createElement('canvas');
  const dpr = devicePixelRatio || 1;
  c.width = c.height = Math.round(cssSize * dpr);
  c.style.width = c.style.height = `${cssSize}px`;
  const g = c.getContext('2d');
  if (g) {
    g.scale(dpr, dpr);
    drawPattern(g, cssSize, cssSize, path);
  }
  return c;
}
