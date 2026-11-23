// DOM HUD from rattleramp/lib/ui/ride_screen.dart: score, combo, speed bar, PRO,
// trick of the day + Δ, popups (timing, points, bail reason) and the hint strip.
import type { Hint } from '../rules/hints';
import type { BailReason, RideEvent, Timing } from '../rules/ride-sim';
import { NEON } from './palette';
import { patternCanvas } from './pattern';

const TIMING_LABEL: Record<Timing, string> = { perfect: 'PERFECT', good: 'GOOD', late: 'LATE', miss: 'MISS' };
const TIMING_COLOR: Record<Timing, string> = {
  perfect: NEON.perfect, good: NEON.good, late: NEON.late, miss: NEON.miss,
};
const BAIL_TEXT: Record<BailReason, string> = {
  timingMiss: 'špatné načasování', badPattern: 'neznámý trik', trickTooLong: 'trik se nevešel do airu',
};

export const byId = (id: string): HTMLElement => {
  const el = document.getElementById(id);
  if (!el) throw new Error(`#${id} missing`);
  return el;
};

/** Mix two #RRGGBB colours (Color.lerp). */
function mix(a: string, b: string, t: number): string {
  const p = (h: string, i: number): number => parseInt(h.slice(1 + 2 * i, 3 + 2 * i), 16);
  const c = [0, 1, 2].map((i) => Math.round(p(a, i) + (p(b, i) - p(a, i)) * t));
  return `rgb(${c.join(',')})`;
}

export class Hud {
  private readonly score = byId('score');
  private readonly combo = byId('combo');
  private readonly speedFill = byId('speed-fill');
  private readonly delta = byId('delta');
  private readonly popup = byId('popup');
  private readonly hints = byId('hints');
  private readonly fps = byId('fps');
  private lastDeltaMs: number | null = null;
  private shown = { score: -1, streak: -1, speed: -1 };

  /** dailyName: "trik dne" shown with the last Δ, as in ride_screen.dart. */
  constructor(private readonly dailyName: string, pro: boolean) {
    byId('pro').hidden = !pro;
    this.hints.hidden = pro;
    this.reset();
  }

  reset(): void {
    this.lastDeltaMs = null;
    this.renderDelta();
    this.popup.replaceChildren();
    this.popup.classList.remove('pop');
    this.update(0, 0, 0);
  }

  update(score: number, streak: number, speed: number): void {
    const s = this.shown;
    if (score !== s.score) this.score.textContent = String(score);
    if (streak !== s.streak) {
      this.combo.hidden = streak === 0;
      this.combo.textContent = `COMBO ×${(1 + 0.1 * streak).toFixed(1)}`;
    }
    if (Math.abs(speed - s.speed) > 0.002) {
      this.speedFill.style.width = `${Math.round(speed * 100)}%`;
      this.speedFill.style.background = mix(NEON.rampEdge, NEON.coping, speed);
    }
    this.shown = { score, streak, speed };
  }

  showHints(hints: readonly Hint[]): void {
    this.hints.replaceChildren(...hints.map((h) => {
      const item = document.createElement('div');
      item.className = 'hint';
      const name = document.createElement('span');
      name.textContent = h.name;
      item.append(patternCanvas(h.path, innerWidth < 600 ? 40 : 72), name);
      return item;
    }));
  }

  showFps(text: string | null): void {
    this.fps.hidden = text === null;
    if (text !== null) this.fps.textContent = text;
  }

  private renderDelta(): void {
    const d = this.lastDeltaMs === null ? '' : `   Δ ${Math.round(this.lastDeltaMs)} ms`;
    this.delta.textContent = `TRIK DNE: ${this.dailyName} ×2${d}`;
  }

  private show(big: string, small: string | null, color: string): void {
    const b = document.createElement('div');
    b.className = 'big';
    b.textContent = big;
    b.style.color = color;
    const nodes: HTMLElement[] = [b];
    if (small) {
      const s = document.createElement('div');
      s.className = 'small';
      s.textContent = small;
      nodes.push(s);
    }
    this.popup.replaceChildren(...nodes);
    this.popup.classList.remove('pop');
    void this.popup.offsetWidth; // restart the CSS animation
    this.popup.classList.add('pop');
  }

  onEvent(e: RideEvent): void {
    switch (e.type) {
      case 'judged':
        this.lastDeltaMs = e.delta * 1000;
        this.renderDelta();
        if (e.trick === null) this.show('ŠPATNÝ TRIK', null, NEON.miss);
        else this.show(TIMING_LABEL[e.timing], e.trick.name, TIMING_COLOR[e.timing]);
        break;
      case 'tooEarly': this.show('MOC BRZY', 'počkej na kruh', NEON.dim); break;
      case 'landed': this.show(`+${e.score.total}`, e.trick.name, TIMING_COLOR[e.timing]); break;
      case 'emptyAir': this.show('BEZ TRIKU', 'ztrácíš rychlost', NEON.dim); break;
      case 'bail': this.show('BAIL!', BAIL_TEXT[e.bailReason], NEON.miss); break;
      case 'outOfSpeed': this.show('DOŠLA RYCHLOST', null, NEON.dim); break;
      case 'finished': break;
    }
  }
}
