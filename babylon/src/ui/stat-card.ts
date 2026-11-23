// End-of-ride summary (rattleramp/lib/ui/stat_card.dart). Taps are ignored for
// the first 2 s so a late swipe doesn't skip it.
import type { RideStats } from '../rules/ride-sim';
import { byId } from './hud';
import { NEON } from './palette';

const ARM_MS = 2000;

function timingLabel(s: RideStats): string {
  if (s.landed === 0) return '–';
  const t = s.averageTiming;
  if (t > 0.85) return 'PERFECT';
  if (t > 0.55) return 'GOOD';
  return 'LATE';
}

export class StatCard {
  private readonly el = byId('statcard');
  private armTimer = 0;
  private armed = false;

  constructor(private readonly onDone: () => void) {
    this.el.addEventListener('pointerdown', (e) => {
      e.preventDefault();
      this.tryDone();
    });
  }

  get visible(): boolean { return !this.el.hidden; }

  /** Space / Enter on the keyboard does the same as a tap. */
  tryDone(): void {
    if (this.armed) this.onDone();
  }

  show(stats: RideStats, bailed: boolean): void {
    const row = (k: string, v: string): HTMLElement => {
      const r = document.createElement('div');
      r.className = 'row';
      const a = document.createElement('span');
      a.className = 'k';
      a.textContent = k;
      const b = document.createElement('span');
      b.className = 'v';
      b.textContent = v;
      r.append(a, b);
      return r;
    };
    const title = document.createElement('div');
    title.className = 'title';
    title.textContent = bailed ? 'BAIL!' : 'KONEC JÍZDY';
    title.style.color = bailed ? NEON.miss : NEON.dim;
    const score = document.createElement('div');
    score.className = 'score';
    score.textContent = String(stats.score);
    const cont = document.createElement('div');
    cont.className = 'continue';
    cont.textContent = 'TAPNI PRO POKRAČOVÁNÍ';
    this.el.replaceChildren(
      title, score,
      row('NEJLEPŠÍ TRIK', stats.bestTrick === null ? '–' : `${stats.bestTrick}  (${stats.bestTrickPoints})`),
      row('NEJDELŠÍ COMBO', String(stats.maxStreak)),
      row('TRIKŮ', String(stats.landed)),
      row('PRŮMĚRNÝ TIMING', timingLabel(stats)),
      cont,
    );
    this.armed = false;
    this.el.classList.remove('armed');
    this.el.hidden = false;
    clearTimeout(this.armTimer);
    this.armTimer = window.setTimeout(() => {
      this.armed = true;
      this.el.classList.add('armed');
    }, ARM_MS);
  }

  hide(): void {
    clearTimeout(this.armTimer);
    this.armed = false;
    this.el.hidden = true;
  }
}
