import { describe, expect, it } from 'vitest';
import { areAdjacent, classifyMove, midpointNode, ringDirection } from '../src/rules/grid';

describe('grid (grid.dart)', () => {
  it('classifies each of the 20 edges into exactly one class', () => {
    const counts = { ring: 0, center: 0, diamond: 0 };
    for (let a = 0; a < 9; a++) for (let b = a + 1; b < 9; b++) if (areAdjacent(a, b)) counts[classifyMove(a, b)]++;
    expect(counts).toEqual({ ring: 8, center: 8, diamond: 4 });
  });

  it('ring direction is clockwise in screen order', () => {
    expect(ringDirection(0, 1)).toBe(1);
    expect(ringDirection(1, 0)).toBe(-1);
    expect(ringDirection(3, 0)).toBe(1);
    expect(ringDirection(0, 3)).toBe(-1);
  });

  it('fills the skipped node on straight lines only', () => {
    expect(midpointNode(0, 2)).toBe(1);
    expect(midpointNode(0, 8)).toBe(4);
    expect(midpointNode(6, 0)).toBe(3);
    expect(midpointNode(0, 5)).toBeNull();
    expect(midpointNode(0, 1)).toBeNull();
  });

  it('rejects non-adjacent moves', () => {
    expect(() => classifyMove(0, 2)).toThrow();
  });
});
