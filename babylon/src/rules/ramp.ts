// Port of rattleramp/lib/core/ramp.dart (1:1).
// Side-view U-ramp profile. Metres, y up, x = 0 in the middle of the flat.
// Path parameter s runs from the left coping (s = 0) down the left wall,
// across the flat and up to the right coping (s = length).

export interface Vec { x: number; y: number }

export class Ramp {
  constructor(readonly radius: number, readonly flat: number, readonly vert: number) {}

  get arc(): number { return (this.radius * Math.PI) / 2; }
  get length(): number { return 2 * this.vert + 2 * this.arc + this.flat; }
  get copingHeight(): number { return this.radius + this.vert; }
  get copingX(): number { return this.flat / 2 + this.radius; }

  /** Coping position; side is -1 for left, +1 for right. */
  coping(side: number): Vec { return { x: side * this.copingX, y: this.copingHeight }; }

  point(s: number): Vec {
    const { radius: r, vert, arc, flat } = this;
    const hf = flat / 2;
    if (s <= vert) return { x: -this.copingX, y: this.copingHeight - s };
    s -= vert;
    if (s <= arc) {
      const u = s / r;
      return { x: -hf - r * Math.cos(u), y: r - r * Math.sin(u) };
    }
    s -= arc;
    if (s <= flat) return { x: -hf + s, y: 0 };
    s -= flat;
    if (s <= arc) {
      const u = s / r;
      return { x: hf + r * Math.sin(u), y: r - r * Math.cos(u) };
    }
    s -= arc;
    return { x: this.copingX, y: r + s };
  }

  /** Tangent angle (radians) in the direction of increasing s. */
  tangent(s: number): number {
    const { radius: r, vert, arc, flat } = this;
    if (s <= vert) return -Math.PI / 2;
    s -= vert;
    if (s <= arc) return -Math.PI / 2 + s / r;
    s -= arc;
    if (s <= flat) return 0;
    s -= flat;
    if (s <= arc) return s / r;
    return Math.PI / 2;
  }

  height(s: number): number { return this.point(s).y; }
}
