import { describe, expect, it } from 'vitest';
import { DEMOS, DemoPlayer, demoOptions, lcg } from '../src/rules/demo';
import { feasibleHints, pickHints } from '../src/rules/hints';
import { defaultConfig } from '../src/rules/ride-config';
import { RideSim, type RideEvent } from '../src/rules/ride-sim';
import { defaultBook } from '../src/rules/trick-defs';
import { TrickParser } from '../src/rules/trick-parser';

const book = defaultBook();
const parser = new TrickParser(book);

function play(id: string, seed = 1): { sim: RideSim; events: RideEvent[] } {
  const sim = new RideSim(defaultConfig(), parser, { dailyTokenId: 'christ' });
  const rnd = lcg(seed);
  const player = new DemoPlayer(book, parser, demoOptions(id), rnd, 'christ',
    () => pickHints(feasibleHints(book, parser, sim), 3, rnd));
  const events: RideEvent[] = [];
  while (!sim.finished && sim.time < 40) {
    const plan = player.tick(sim);
    if (plan) expect(plan.drawStart).toBeLessThan(plan.release);
    sim.step();
    events.push(...sim.drainEvents());
  }
  return { sim, events };
}

describe('demo rider for feature videos', () => {
  it.each(Object.keys(DEMOS))('%s plays without surprises', (id) => {
    const { sim, events } = play(id);
    const o = demoOptions(id);
    if (o.bailAfter !== null) {
      expect(sim.bailReason).toBe('badPattern');
      expect(sim.stats.landed).toBe(o.bailAfter);
    } else {
      expect(sim.bailReason, id).toBeNull();
      expect(sim.stats.landed, id).toBeGreaterThan(5);
    }
    if (o.perfect) expect(events.filter((e) => e.type === 'judged').every((e) => e.type === 'judged' && e.timing === 'perfect')).toBe(true);
  });

  it('only the asked token kinds show up', () => {
    for (const [id, kind] of [['grabs', 'grab'], ['flips', 'flip'], ['spins', 'spin']] as const) {
      const { events } = play(id);
      for (const e of events) if (e.type === 'landed') expect(e.trick.tokens.every((t) => t.kind === kind), id).toBe(true);
    }
    const { events } = play('combos');
    for (const e of events) if (e.type === 'landed') expect(e.trick.tokens.length).toBeGreaterThan(1);
  });

  it('the same seed plays the same ride', () => {
    const a = play('ride', 42).events.map((e) => `${e.type}@${e.t}`);
    const b = play('ride', 42).events.map((e) => `${e.type}@${e.t}`);
    expect(a).toEqual(b);
  });
});
