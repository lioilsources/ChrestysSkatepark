// Port of rattleramp/lib/core/grid.dart (1:1). 3×3 swipe grid geometry.
//
//     0 1 2
//     3 4 5
//     6 7 8

export const CENTER_NODE = 4;

/** Outer ring in clockwise screen order. */
export const RING_ORDER: readonly number[] = [0, 1, 2, 5, 8, 7, 6, 3];

/** Edge-mid nodes forming the inner diamond. */
export const DIAMOND_NODES: ReadonlySet<number> = new Set([1, 3, 5, 7]);

export type MoveClass = 'ring' | 'center' | 'diamond';

export const nodeRow = (n: number): number => Math.trunc(n / 3);
export const nodeCol = (n: number): number => n % 3;
export const isValidNode = (n: number): boolean => Number.isInteger(n) && n >= 0 && n < 9;

/** True when a and b are distinct 8-neighbours. */
export function areAdjacent(a: number, b: number): boolean {
  if (!isValidNode(a) || !isValidNode(b) || a === b) return false;
  return Math.abs(nodeRow(a) - nodeRow(b)) <= 1 && Math.abs(nodeCol(a) - nodeCol(b)) <= 1;
}

/** Classifies a step between adjacent nodes. Throws on non-adjacent input. */
export function classifyMove(a: number, b: number): MoveClass {
  if (!areAdjacent(a, b)) throw new Error(`Nodes ${a} and ${b} are not adjacent`);
  if (a === CENTER_NODE || b === CENTER_NODE) return 'center';
  if (DIAMOND_NODES.has(a) && DIAMOND_NODES.has(b)) return 'diamond';
  return 'ring';
}

/** +1 for a clockwise ring step, -1 for counter-clockwise (ring moves only). */
export function ringDirection(a: number, b: number): number {
  const ia = RING_ORDER.indexOf(a);
  const ib = RING_ORDER.indexOf(b);
  return (((ib - ia) % 8) + 8) % 8 === 1 ? 1 : -1;
}

/** Node exactly between a and b on a straight line (0→2 gives 1), or null. */
export function midpointNode(a: number, b: number): number | null {
  const r = nodeRow(a) + nodeRow(b);
  const c = nodeCol(a) + nodeCol(b);
  if (r % 2 !== 0 || c % 2 !== 0) return null;
  const m = (r / 2) * 3 + c / 2;
  return m === a || m === b ? null : m;
}
