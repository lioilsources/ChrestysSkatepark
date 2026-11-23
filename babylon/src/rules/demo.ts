// Scripted player for feature videos (plan 06, ch. 5a): ?demo=<id>&seed=<n>.
// Like the attract autopilot, but each feature gets its own trick pool and timing,
// the choice is seeded (the same URL plays the same ride) and every release comes
// with a plan, so the UI can draw the swipe on the pad before the finger lifts.
import type { Hint } from './hints';
import type { RideSim } from './ride-sim';
import { ringPath, type TokenKind, type TrickBook } from './trick-defs';
import type { TrickParser } from './trick-parser';

export interface DemoPlan {
  nodes: readonly number[];
  /** Ride time the swipe starts being drawn on the pad. */
  drawStart: number;
  /** Ride time the finger lifts (the release fed to the sim). */
  release: number;
}

export interface DemoOptions {
  /** Token kinds to pick from (single tokens); empty = none. */
  kinds: readonly TokenKind[];
  /** Also pick named combos and grab→spin chains; 'only' = nothing else. */
  combos: 'none' | 'also' | 'only';
  /** Release exactly on the edge (no jitter). */
  perfect: boolean;
  /** After this many landed tricks, swipe an unknown pattern and bail. */
  bailAfter: number | null;
  /** Prefer the trick of the day whenever it fits. */
  preferDaily: boolean;
  /** Copy one of the hints the strip shows (ride_screen.dart hints). */
  fromHints: boolean;
  /** Seconds the swipe takes to draw on the pad. */
  drawSeconds: number;
  /** End with the stat card instead of looping. */
  showEnd: boolean;
}

const ALL: readonly TokenKind[] = ['grab', 'flip', 'spin'];
const base: DemoOptions = {
  kinds: ALL, combos: 'also', perfect: false, bailAfter: null, preferDaily: false, fromHints: false, drawSeconds: 0.45, showEnd: false,
};

/** Feature id (babylon/PORT.md, "Funkce") → how the demo rider plays. */
export const DEMOS: Record<string, Partial<DemoOptions>> = {
  ride: {},
  timing: { kinds: ['grab'], combos: 'none', perfect: true },
  'swipe-grid': { kinds: ['grab', 'flip'], combos: 'none', drawSeconds: 0.9 },
  spins: { kinds: ['spin'], combos: 'none' },
  grabs: { kinds: ['grab'], combos: 'none' },
  flips: { kinds: ['flip'], combos: 'none' },
  combos: { kinds: [], combos: 'only', drawSeconds: 0.7 },
  bail: { bailAfter: 3, showEnd: true },
  scoring: { preferDaily: true },
  'trick-of-day': { kinds: ['grab', 'flip'], combos: 'none', preferDaily: true },
  'pro-mode': {},
  hints: { fromHints: true, drawSeconds: 0.7 },
  'stat-card': { bailAfter: 4, showEnd: true },
};

export const demoOptions = (id: string): DemoOptions => ({ ...base, ...(DEMOS[id] ?? {}) });

/** Seeded random source (same LCG as the Dart vector tool). */
export function lcg(seed: number): () => number {
  let s = Math.abs(Math.trunc(seed)) & 0x7fffffff;
  return () => (s = (s * 1103515245 + 12345) & 0x7fffffff) / 0x80000000;
}

const UNKNOWN: readonly number[] = [0, 4, 0];

export class DemoPlayer {
  private segment = -1;

  constructor(
    private readonly book: TrickBook,
    private readonly parser: TrickParser,
    readonly opts: DemoOptions,
    private readonly random: () => number,
    private readonly dailyId: string | null = null,
    private readonly hints: () => readonly Hint[] = () => [],
  ) {}

  /** Grab followed by a spin that starts where the grab ends (one swipe). */
  private chains(): number[][] {
    const out: number[][] = [];
    for (const g of this.book.grabs) {
      for (const s of this.book.spins) {
        if (s.degrees > 360) continue;
        const end = g.path[g.path.length - 1];
        out.push([...g.path, ...ringPath(end, s.degrees / 45, s.frontside).slice(1)]);
      }
    }
    return out;
  }

  private pool(sim: RideSim): (readonly number[])[] {
    const o = this.opts;
    const fits = (path: readonly number[]): boolean => {
      const r = this.parser.parse(path);
      return r.ok && sim.speedNeeded(r.trick) < sim.speed - 0.05;
    };
    if (o.fromHints) return this.hints().map((h) => h.path).filter(fits);
    const out: (readonly number[])[] = [];
    if (o.combos !== 'only') for (const t of this.book.allTokens) if (o.kinds.includes(t.kind) && fits(t.path)) out.push(t.path);
    if (o.combos !== 'none') {
      for (const c of this.book.combos) {
        const p = this.book.comboPath(c);
        if (p !== null && fits(p)) out.push(p);
      }
      for (const p of this.chains()) if (fits(p)) out.push(p);
    }
    if (o.preferDaily && this.dailyId) {
      const d = out.filter((p) => {
        const r = this.parser.parse(p);
        return r.ok && r.trick.tokens.some((t) => t.id === this.dailyId);
      });
      if (d.length > 0 && this.random() < 0.6) return d;
    }
    return out;
  }

  /** Call before every sim.step(); returns a plan when it queued a release. */
  tick(sim: RideSim): DemoPlan | null {
    if (sim.phase !== 'rolling' && sim.phase !== 'dropIn') return null;
    if (this.segment === sim.segStart) return null;
    this.segment = sim.segStart;
    const o = this.opts;
    let nodes: readonly number[] | null = null;
    if (o.bailAfter !== null && sim.stats.landed >= o.bailAfter) nodes = UNKNOWN;
    else {
      const pool = this.pool(sim);
      if (pool.length > 0) nodes = pool[Math.floor(this.random() * pool.length)];
    }
    if (nodes === null) return null;
    const jitter = o.perfect ? 0 : (this.random() - 0.5) * 0.07;
    const release = sim.tEdge + jitter;
    sim.addInput({ t: release, nodes });
    return { nodes, release, drawStart: release - o.drawSeconds };
  }
}

