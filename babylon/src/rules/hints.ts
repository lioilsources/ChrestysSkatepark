// Hint strip selection from rattleramp/lib/ui/ride_screen.dart (_refreshHints):
// three tricks that fit the current speed, so copying a hint can't bail.
import type { RideSim } from './ride-sim';
import type { TrickBook } from './trick-defs';
import type { TrickParser } from './trick-parser';

export interface Hint { name: string; path: readonly number[] }

/** Every token and drawable combo whose speedNeeded ≤ the ride's speed. */
export function feasibleHints(book: TrickBook, parser: TrickParser, sim: RideSim): Hint[] {
  const pool: Hint[] = [];
  const fits = (path: readonly number[]): boolean => {
    const r = parser.parse(path);
    return r.ok && sim.speedNeeded(r.trick) <= sim.speed;
  };
  for (const t of book.allTokens) if (fits(t.path)) pool.push({ name: t.name, path: t.path });
  for (const c of book.combos) {
    const path = book.comboPath(c);
    if (path !== null && fits(path)) pool.push({ name: c.name, path });
  }
  return pool;
}

/** Shuffle (Fisher–Yates with the given random source) and take n. */
export function pickHints(pool: readonly Hint[], n: number, random: () => number): Hint[] {
  const a = [...pool];
  for (let i = a.length - 1; i > 0; i--) {
    const j = Math.floor(random() * (i + 1));
    [a[i], a[j]] = [a[j], a[i]];
  }
  return a.slice(0, n);
}
