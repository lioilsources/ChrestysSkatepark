import { describe, expect, it } from 'vitest';
import { Ramp } from '../src/rules/ramp';

describe('Ramp (ramp.dart)', () => {
  const r = new Ramp(3, 4, 0.3);

  it('has the Dart geometry', () => {
    expect(r.length).toBeCloseTo(2 * 0.3 + 3 * Math.PI + 4, 12);
    expect(r.copingHeight).toBeCloseTo(3.3, 12);
    expect(r.copingX).toBeCloseTo(5, 12);
  });

  it('starts and ends on the copings and is continuous', () => {
    expect(r.point(0)).toEqual({ x: -5, y: 3.3 });
    const end = r.point(r.length);
    expect(end.x).toBeCloseTo(5, 12);
    expect(end.y).toBeCloseTo(3.3, 12);
    const n = 2000;
    for (let i = 1; i <= n; i++) {
      const a = r.point((r.length * (i - 1)) / n);
      const b = r.point((r.length * i) / n);
      expect(Math.hypot(b.x - a.x, b.y - a.y)).toBeLessThanOrEqual(r.length / n + 1e-9);
    }
  });

  it('is symmetric and flat in the middle', () => {
    for (const s of [0.1, 1, 2.5, 4]) {
      const a = r.point(s);
      const b = r.point(r.length - s);
      expect(b.x).toBeCloseTo(-a.x, 9);
      expect(b.y).toBeCloseTo(a.y, 9);
    }
    expect(r.height(r.length / 2)).toBe(0);
    expect(r.tangent(r.length / 2)).toBe(0);
    expect(r.tangent(0)).toBeCloseTo(-Math.PI / 2, 12);
    expect(r.tangent(r.length)).toBeCloseTo(Math.PI / 2, 12);
  });
});
