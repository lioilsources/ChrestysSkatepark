import { describe, expect, it } from 'vitest';
import { defaultConfig, launchVelocity } from '../src/rules/ride-config';
import { SpikeRide, type RideEvent } from '../src/rules/spike-ride';

const run = (release: (r: SpikeRide) => number | null, segments = 6): { ride: SpikeRide; events: RideEvent[] } => {
  const ride = new SpikeRide(defaultConfig());
  const events: RideEvent[] = [];
  let seg = -1;
  let n = 0;
  while (!ride.finished && ride.time < 120) {
    if (ride.phase === 'rolling' && ride.segStart !== seg && n < segments) {
      seg = ride.segStart;
      n++;
      const t = release(ride);
      if (t !== null) ride.addInput({ t, nodes: [0, 1, 2] });
    }
    ride.step();
    events.push(...ride.drainEvents());
  }
  return { ride, events };
};

describe('SpikeRide (segment physics of ride_sim.dart)', () => {
  it('rolls coping to coping and airs for 2·v/g', () => {
    const ride = new SpikeRide(defaultConfig());
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
    expect(ride.landed).toBe(4);
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
});
