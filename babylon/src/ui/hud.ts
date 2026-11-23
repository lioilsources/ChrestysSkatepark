// DOM HUD: speed, landed count, popup and timing delta. Texts match ride_screen.dart.
import type { BailReason, RideEvent, Timing } from '../rules/ride-sim';
import { NEON } from './palette';

const TIMING_LABEL: Record<Timing, string> = { perfect: 'PERFECT', good: 'GOOD', late: 'LATE', miss: 'MISS' };
const TIMING_COLOR: Record<Timing, string> = {
  perfect: NEON.perfect, good: NEON.good, late: NEON.late, miss: NEON.miss,
};

const BAIL_TEXT: Record<BailReason, string> = {
  timingMiss: 'špatné načasování', badPattern: 'neznámý trik', trickTooLong: 'trik se nevešel do airu',
};

const byId = (id: string): HTMLElement => {
  const el = document.getElementById(id);
  if (!el) throw new Error(`#${id} missing`);
  return el;
};

export class Hud {
  private readonly stats = byId('stats');
  private readonly delta = byId('delta');
  private readonly popup = byId('popup');
  private readonly fps = byId('fps');

  private lastDeltaMs: number | null = null;

  /** dailyName: "trik dne" shown in the strip with the last Δ, as in ride_screen.dart. */
  constructor(private readonly dailyName: string, private readonly pro = false) {
    this.renderDelta();
  }

  update(score: number, streak: number, speed: number): void {
    this.stats.textContent =
      `${score}   COMBO ×${(1 + 0.1 * streak).toFixed(1)}   RYCHLOST ${Math.round(speed * 100)} %${this.pro ? '   PRO' : ''}`;
  }

  private renderDelta(): void {
    const d = this.lastDeltaMs === null ? '' : `   Δ ${Math.round(this.lastDeltaMs)} ms`;
    this.delta.textContent = `TRIK DNE: ${this.dailyName} ×2${d}`;
  }

  showFps(text: string | null): void {
    this.fps.hidden = text === null;
    if (text !== null) this.fps.textContent = text;
  }

  private show(big: string, small: string | null, color: string): void {
    this.popup.replaceChildren();
    const b = document.createElement('div');
    b.className = 'big';
    b.textContent = big;
    b.style.color = color;
    this.popup.append(b);
    if (small) {
      const s = document.createElement('div');
      s.className = 'small';
      s.textContent = small;
      this.popup.append(s);
    }
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
      case 'finished': this.show('KONEC', 'klepni pro novou jízdu', NEON.skater); break;
    }
  }
}
