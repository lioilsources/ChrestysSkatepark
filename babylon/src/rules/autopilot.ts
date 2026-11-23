// Attract-mode demo rider from rattleramp/lib/game/rattle_game.dart (_botTick):
// on every new segment it releases a random trick that fits the current speed,
// with a little timing jitter. Used by ?demo (and the attract loop in F3).
import type { RideSim } from './ride-sim';
import type { TrickBook } from './trick-defs';
import type { TrickParser } from './trick-parser';

export class Autopilot {
  private segment = -1;

  constructor(private readonly book: TrickBook, private readonly parser: TrickParser, private readonly random: () => number) {}

  /** Call before every sim.step(). */
  tick(sim: RideSim): void {
    if (sim.phase !== 'rolling' && sim.phase !== 'dropIn') return;
    if (this.segment === sim.segStart) return;
    this.segment = sim.segStart;
    const options: (readonly number[])[] = [];
    const fits = (path: readonly number[]): boolean => {
      const r = this.parser.parse(path);
      return r.ok && sim.speedNeeded(r.trick) < sim.speed - 0.05;
    };
    for (const t of this.book.allTokens) if (fits(t.path)) options.push(t.path);
    for (const c of this.book.combos) {
      const path = this.book.comboPath(c);
      if (path !== null && fits(path)) options.push(path);
    }
    if (options.length === 0) return;
    const jitter = (this.random() - 0.5) * 0.07;
    sim.addInput({ t: sim.tEdge + jitter, nodes: options[Math.floor(this.random() * options.length)] });
  }
}
