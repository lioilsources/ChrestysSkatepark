import { describe, expect, it } from 'vitest';
import { defaultConfig, launchVelocity } from '../src/rules/ride-config';
import { RideSim, type RideEvent } from '../src/rules/ride-sim';
import { defaultBook } from '../src/rules/trick-defs';
import { TrickParser } from '../src/rules/trick-parser';

const parser = new TrickParser(defaultBook());
const INDY = [3, 4, 5];

const run = (release: (r: RideSim) => number | null, segments = 6, nodes: number[] = INDY): { ride: RideSim; events: RideEvent[] } => {
  const ride = new RideSim(defaultConfig(), parser);
  const events: RideEvent[] = [];
  let seg = -1;
  let n = 0;
  while (!ride.finished && ride.time < 120) {
    if (ride.phase === 'rolling' && ride.segStart !== seg && n < segments) {
      seg = ride.segStart;
      n++;
      const t = release(ride);
      if (t !== null) ride.addInput({ t, nodes });
    }
    ride.step();
    events.push(...ride.drainEvents());
  }
  return { ride, events };
};

describe('RideSim (sanity checks; parity is in golden.test.ts)', () => {
  it('rolls coping to coping and airs for 2·v/g', () => {
    const ride = new RideSim(defaultConfig(), parser);
    const c = defaultConfig();
    expect(ride.airDuration).toBeCloseTo((2 * launchVelocity(c, c.startSpeed)) / c.gravity, 12);
    expect(ride.tEdge).toBeGreaterThan(c.dropInDelay);
    // Energy check: launch velocity at the coping, so the roll is faster than the ramp length at v0.
    expect(ride.tEdge - c.dropInDelay).toBeLessThan(ride.ramp.length / launchVelocity(c, c.startSpeed));
  });

  it('without input loses speed every air and ends in a rollout', () => {
    const { events } = run(() => null);
    const types = events.map((e) => e.type);
    expect(types.filter((t) => t === 'emptyAir').length).toBe(3); // 0.4 − 3 × 0.18 < 0
    expect(types).toContain('outOfSpeed');
    expect(types[types.length - 1]).toBe('finished');
  });

  it('a release on the edge is perfect and gains speed', () => {
    const { ride, events } = run((r) => r.tEdge, 4);
    const judged = events.filter((e) => e.type === 'judged');
    expect(judged.length).toBe(4);
    expect(judged.every((e) => e.type === 'judged' && e.timing === 'perfect')).toBe(true);
    expect(ride.stats.landed).toBe(4);
    expect(ride.stats.score).toBeGreaterThan(0);
  });

  it('a late release outside the window bails', () => {
    const { events } = run((r) => r.tEdge + 0.5, 1);
    expect(events.find((e) => e.type === 'judged')).toMatchObject({ timing: 'miss' });
    expect(events.map((e) => e.type)).toContain('bail');
  });

  it('is deterministic: same inputs, same ride', () => {
    const a = run((r) => r.tEdge + 0.02);
    const b = run((r) => r.tEdge + 0.02);
    expect(a.ride.time).toBe(b.ride.time);
    expect(a.events).toEqual(b.events);
  });

  it('an unknown pattern bails with badPattern', () => {
    const { ride, events } = run((r) => r.tEdge, 1, [0, 4, 0]);
    expect(events.find((e) => e.type === 'judged')).toMatchObject({ trick: null, parseError: 'unknownGrab' });
    expect(ride.bailReason).toBe('badPattern');
  });

  it('an odd number of half spins flips the stance', () => {
    const { ride } = run((r) => r.tEdge, 1, [1, 2, 5, 8]); // FS 180
    expect(ride.stance).toBe(-1);
  });
});
