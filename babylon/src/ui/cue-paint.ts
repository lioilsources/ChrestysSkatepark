// Port of rattleramp/lib/game/cue_component.dart: a ring that shrinks onto the coping
// and meets the target ring exactly when the skater leaves the edge.
import { circle, drawStyled } from './skater-paint';
import { pal, withAlpha } from './palette';

export const CUE_TARGET = 0.34;
export const CUE_SPREAD = 1.9;

/**
 * Draws the cue at the transform origin (the coping, y up, metres).
 * k = 0…1 time-to-edge / cue lead; color = timing colour of the moment.
 */
export function paintCue(g: CanvasRenderingContext2D, k: number, color: string): void {
  const c = pal();
  const fade = (1 - k) * 0.8 + 0.2;
  const o = { x: 0, y: 0 };
  drawStyled(g, [
    { path: circle(o, CUE_TARGET), stroke: withAlpha(c.coping, 0.9), width: 0.06 },
    { path: circle(o, CUE_TARGET + CUE_SPREAD * k), stroke: withAlpha(color, fade), width: 0.08 + 0.06 * (1 - k) },
  ]);
}
