// DOM HUD: speed, landed count, popup and timing delta. Texts match ride_screen.dart.
import type { RideEvent, Timing } from '../rules/spike-ride';
import { NEON } from './palette';

const TIMING_LABEL: Record<Timing, string> = { perfect: 'PERFECT', good: 'GOOD', late: 'LATE', miss: 'MISS' };
const TIMING_COLOR: Record<Timing, string> = {
  perfect: NEON.perfect, good: NEON.good, late: NEON.late, miss: NEON.miss,
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

  update(speed: number, landed: number): void {
    this.stats.textContent = `RYCHLOST ${Math.round(speed * 100)} %   TRIKY ${landed}`;
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
        this.delta.textContent = `Δ ${Math.round(e.delta * 1000)} ms`;
        this.show(TIMING_LABEL[e.timing], null, TIMING_COLOR[e.timing]);
        break;
      case 'tooEarly': this.show('MOC BRZY', 'počkej na kruh', NEON.dim); break;
      case 'landed': this.show('LANDED', null, TIMING_COLOR[e.timing]); break;
      case 'emptyAir': this.show('BEZ TRIKU', 'ztrácíš rychlost', NEON.dim); break;
      case 'bail': this.show('BAIL!', 'špatné načasování', NEON.miss); break;
      case 'outOfSpeed': this.show('DOŠLA RYCHLOST', null, NEON.dim); break;
      case 'finished': this.show('KONEC', 'klepni pro novou jízdu', NEON.skater); break;
    }
  }
}
