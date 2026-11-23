import { describe, expect, it } from 'vitest';
import { Autopilot } from '../src/rules/autopilot';
import { feasibleHints, pickHints } from '../src/rules/hints';
import { defaultConfig } from '../src/rules/ride-config';
import { RideSim } from '../src/rules/ride-sim';
import { defaultBook } from '../src/rules/trick-defs';
import { TrickParser } from '../src/rules/trick-parser';

const book = defaultBook();
const parser = new TrickParser(book);

/** Deterministic random source for tests. */
const lcg = (seed: number) => () => ((seed = (seed * 1103515245 + 12345) & 0x7fffffff) / 0x80000000);

describe('hint strip', () => {
  it('offers only tricks that fit the current speed', () => {
    const sim = new RideSim(defaultConfig(), parser);
    const pool = feasibleHints(book, parser, sim);
    expect(pool.length).toBeGreaterThan(3);
    for (const h of pool) {
      const r = parser.parse(h.path);
      expect(r.ok && sim.speedNeeded(r.trick) <= sim.speed, h.name).toBe(true);
    }
    const picked = pickHints(pool, 3, lcg(1));
    expect(picked).toHaveLength(3);
    expect(new Set(picked.map((h) => h.name)).size).toBe(3);
  });

  it('copying any hint on the edge lands', () => {
    for (const h of feasibleHints(book, parser, new RideSim(defaultConfig(), parser))) {
      const sim = new RideSim(defaultConfig(), parser);
      sim.addInput({ t: sim.tEdge, nodes: h.path });
      while (sim.stats.landed === 0 && sim.bailReason === null && !sim.finished) sim.step();
      expect(sim.bailReason, h.name).toBeNull();
      expect(sim.stats.landed, h.name).toBe(1);
    }
  });
});

describe('autopilot', () => {
  it('rides a long, bail-free run', () => {
    const sim = new RideSim(defaultConfig(), parser);
    const bot = new Autopilot(book, parser, lcg(7));
    while (!sim.finished && sim.time < 60) {
      bot.tick(sim);
      sim.step();
    }
    expect(sim.bailReason).toBeNull();
    expect(sim.stats.landed).toBeGreaterThan(10);
  });
});
