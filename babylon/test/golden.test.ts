// Replays the golden vectors written by rattleramp/tool/dump_vectors.dart (plan 06, F1).
// Discrete output (tokens, errors, events, scores, stats) must match exactly (P0);
// floats (times, speed, pose) to 1e-9, which only tolerates last-bit libm differences.
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { defaultConfig } from '../src/rules/ride-config';
import { RideSim, type RideEvent } from '../src/rules/ride-sim';
import { scoreTrick, type Timing } from '../src/rules/scoring';
import { dailyToken, defaultBook, trickGrade } from '../src/rules/trick-defs';
import { TrickParser } from '../src/rules/trick-parser';

const golden = <T>(name: string): T =>
  JSON.parse(readFileSync(fileURLToPath(new URL(`./golden/${name}`, import.meta.url)), 'utf8')) as T;

const book = defaultBook();
const parser = new TrickParser(book);
const EPS = 1e-9;

const near = (actual: number, expected: number, what: string): void => {
  if (Math.abs(actual - expected) > EPS * Math.max(1, Math.abs(expected))) {
    expect.fail(`${what}: ${actual} ≠ ${expected}`);
  }
};

function parseCode(nodes: number[]): string {
  const r = parser.parse(nodes);
  if (!r.ok) return `!${r.error}`;
  const ids = r.trick.tokens.map((t) => t.id).join('+');
  return r.trick.combo ? `${ids}#${r.trick.combo.id}` : ids;
}

describe('golden: trick book', () => {
  const g = golden<{
    tokens: Record<string, unknown>[];
    combos: Record<string, number[] | null>;
    grades: number[];
    daily: Record<string, string>;
  }>('book.json');

  it('tokens load from tricks.json exactly as in Dart', () => {
    const ts = book.allTokens.map((t) => ({
      id: t.id, name: t.name, kind: t.kind, base: t.base, path: t.path, degrees: t.degrees, frontside: t.frontside,
      grab: { hand: t.grabLook.hand, at: t.grabLook.at, style: t.grabLook.style, tilt: t.grabLook.tilt },
      flip: { roll: t.flipLook.roll, shove: t.flipLook.shove, tumble: t.flipLook.tumble },
    }));
    expect(ts).toEqual(g.tokens);
  });

  it('combo paths', () => {
    expect(Object.fromEntries(book.combos.map((c) => [c.id, book.comboPath(c)]))).toEqual(g.combos);
  });

  it('grades', () => {
    expect(g.grades.map((_, m) => trickGrade(m))).toEqual(g.grades);
  });

  it(`trick of the day for ${Object.keys(g.daily).length} days`, () => {
    const ts: Record<string, string> = {};
    for (const day of Object.keys(g.daily)) {
      const [y, m, d] = day.split('-').map(Number);
      ts[day] = dailyToken(book, y, m, d).id;
    }
    expect(ts).toEqual(g.daily);
  });
});

describe('golden: trick parser', () => {
  const g = golden<Record<string, string>>('parser.json');

  it(`${Object.keys(g).length} patterns parse to the same tokens, combo or error`, () => {
    const bad: string[] = [];
    for (const [key, want] of Object.entries(g)) {
      const got = parseCode([...key].map(Number));
      if (got !== want) bad.push(`${key}: ${got} ≠ ${want}`);
    }
    expect(bad.slice(0, 20)).toEqual([]);
  });
});

describe('golden: scoring', () => {
  const g = golden<{
    in: { n: number[]; timing: Timing; speed: number; streak: number; prev: number; air: number; pro: boolean; daily: string | null };
    out: Record<string, number>;
  }[]>('scoring.json');

  it(`${g.length} breakdowns match exactly`, () => {
    for (const [k, { in: i, out }] of g.entries()) {
      const r = parser.parse(i.n);
      if (!r.ok) expect.fail(`case ${k}: ${r.error}`);
      const s = scoreTrick({
        trick: r.trick, timing: i.timing, speed: i.speed, streak: i.streak, previousCount: i.prev,
        airHeight: i.air, proMode: i.pro, dailyTokenId: i.daily,
      });
      expect({ ...s }, `case ${k}`).toEqual(out);
    }
  });
});

interface GoldenEvent {
  type: string; t: number; timing?: string; trick?: string; score?: number; bail?: string; parseError?: string; delta?: number;
}
interface GoldenRide {
  id: string;
  config: { startSpeed: number; windowScale: number; inputLatency: number; cueLead: number };
  replay: { v: number; pro: boolean; daily: string | null; inputs: { t: number; n: number[] }[] };
  ticks: number;
  events: GoldenEvent[];
  segments: Record<string, number>[];
  stats: Record<string, unknown> & { trickCounts: Record<string, number> };
  poses?: number[][];
}

function eventJson(e: RideEvent): GoldenEvent {
  const o: GoldenEvent = { type: e.type, t: e.t };
  if ('timing' in e) o.timing = e.timing;
  if ('trick' in e && e.trick) o.trick = e.trick.key;
  if ('score' in e) o.score = e.score.total;
  if ('bailReason' in e) o.bail = e.bailReason;
  if ('parseError' in e && e.parseError) o.parseError = e.parseError;
  if ('delta' in e) o.delta = e.delta;
  return o;
}

function compare(actual: unknown, expected: unknown, path: string): void {
  if (typeof expected === 'number' && typeof actual === 'number') {
    near(actual, expected, path); // integers (scores, counts) can't differ by < 1, so this is exact for them
    return;
  }
  if (Array.isArray(expected)) {
    expect(Array.isArray(actual) && actual.length, `${path}.length`).toBe(expected.length);
    expected.forEach((v, i) => compare((actual as unknown[])[i], v, `${path}[${i}]`));
    return;
  }
  if (expected !== null && typeof expected === 'object') {
    const a = actual as Record<string, unknown>;
    expect(Object.keys(a).sort(), `${path} keys`).toEqual(Object.keys(expected).sort());
    for (const [k, v] of Object.entries(expected)) compare(a[k], v, `${path}.${k}`);
    return;
  }
  expect(actual, path).toEqual(expected);
}

describe('golden: ride replays', () => {
  const rides = golden<GoldenRide[]>('rides.json');

  it.each(rides.map((r) => [r.id, r] as const))('%s', (_, g) => {
    const sim = new RideSim({ ...defaultConfig(), ...g.config }, parser, { proMode: g.replay.pro, dailyTokenId: g.replay.daily });
    for (const i of g.replay.inputs) sim.addInput({ t: i.t, nodes: i.n });
    const events: GoldenEvent[] = [];
    const segments: Record<string, number>[] = [];
    const poses: number[][] = [];
    let seg = NaN;
    let tick = 0;
    const snap = (): void => {
      if (sim.segStart === seg) return;
      seg = sim.segStart;
      segments.push({
        time: sim.time, segStart: sim.segStart, tEdge: sim.tEdge, tLand: sim.tLand,
        speed: sim.speed, dir: sim.dir, stance: sim.stance, maxAir: sim.maxAirHeight,
      });
    };
    snap();
    while (!sim.finished && sim.time < 300) {
      sim.step();
      tick++;
      events.push(...sim.drainEvents().map(eventJson));
      snap();
      if (g.poses && tick % 5 === 0) {
        const p = sim.pose;
        poses.push([sim.time, p.x, p.y, p.angle, p.facing, p.roll, p.shove, p.tumble, p.flip, p.grab, p.crouch, p.bail]);
      }
    }
    const st = sim.stats;
    expect(tick).toBe(g.ticks);
    compare(events, g.events, 'events');
    compare(segments, g.segments, 'segments');
    compare({
      score: st.score, landed: st.landed, streak: st.streak, maxStreak: st.maxStreak, bestTrick: st.bestTrick,
      bestTrickPoints: st.bestTrickPoints, averageTiming: st.averageTiming,
      trickCounts: Object.fromEntries(st.trickCounts), bailReason: sim.bailReason,
    }, g.stats, 'stats');
    if (g.poses) compare(poses, g.poses, 'poses');
    expect(sim.replayJson()).toEqual(g.replay);
  });

  it('covers every event type and bail reason', () => {
    const all = rides.flatMap((r) => r.events);
    expect(new Set(all.map((e) => e.type))).toEqual(new Set(['judged', 'tooEarly', 'landed', 'emptyAir', 'bail', 'outOfSpeed', 'finished']));
    expect(new Set(all.flatMap((e) => (e.bail ? [e.bail] : [])))).toEqual(new Set(['timingMiss', 'badPattern', 'trickTooLong']));
    expect(new Set(all.flatMap((e) => (e.timing ? [e.timing] : [])))).toEqual(new Set(['perfect', 'good', 'late', 'miss']));
  });
});
