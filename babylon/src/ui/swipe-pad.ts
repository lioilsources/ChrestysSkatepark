// Fixed 3×3 swipe pad (port of rattleramp/lib/ui/swipe_grid.dart).
// Tracks one pointer (touch or mouse), lights up the path and reports the node
// sequence on lift. A node is hit when the pointer passes within hitRadius × cell
// of its centre; fast swipes are sampled along the segment and a skipped node on
// a straight line (0→2 over 1) is filled in.
// Keyboard (web only): the physical 3×3 block Q W E / A S D / Z X C or the numpad
// builds the path, Space / Enter releases it, Esc / Backspace clears.
import { areAdjacent, midpointNode } from '../rules/grid';
import { pal, withAlpha } from './palette';

/** e.code → grid node. Physical keys, so QWERTZ (Y/Z swapped) works the same. */
const KEY_NODES: Record<string, number> = {
  KeyQ: 0, KeyW: 1, KeyE: 2, KeyA: 3, KeyS: 4, KeyD: 5, KeyZ: 6, KeyX: 7, KeyC: 8,
  Numpad7: 0, Numpad8: 1, Numpad9: 2, Numpad4: 3, Numpad5: 4, Numpad6: 5, Numpad1: 6, Numpad2: 7, Numpad3: 8,
};

/** Ignore touches this close to the physical screen edge (frame / palm). */
const EDGE_GUARD = 18;

export class SwipePad {
  private pointer: number | null = null;
  private last: { x: number; y: number } | null = null;
  private finger: { x: number; y: number } | null = null;
  private readonly nodes: number[] = [];
  private demoKey = '';
  private readonly ctx: CanvasRenderingContext2D;

  constructor(
    private readonly el: HTMLCanvasElement,
    private readonly onRelease: (nodes: number[]) => void,
    private readonly hitRadius = 0.36,
  ) {
    const ctx = el.getContext('2d');
    if (!ctx) throw new Error('2d context unavailable');
    this.ctx = ctx;
    el.addEventListener('pointerdown', (e) => this.down(e));
    el.addEventListener('pointermove', (e) => this.move(e));
    el.addEventListener('pointerup', (e) => this.up(e, true));
    el.addEventListener('pointercancel', (e) => this.up(e, false));
    new ResizeObserver(() => this.draw()).observe(el);
  }

  /**
   * Demo / video: show a scripted swipe drawn up to k (0…1) with a finger dot;
   * null hides it. Real touches are unaffected.
   */
  showDemo(nodes: readonly number[] | null, k = 1): void {
    if (this.pointer !== null) return;
    const key = nodes ? `${nodes.join('')}:${k.toFixed(3)}` : '';
    if (key === this.demoKey) return;
    this.demoKey = key;
    this.nodes.length = 0;
    this.finger = null;
    if (nodes && nodes.length > 0) {
      const segs = nodes.length - 1;
      const shown = Math.min(segs, Math.max(0, k * segs));
      const i = Math.floor(shown);
      for (let n = 0; n <= Math.min(i, segs); n++) this.nodes.push(nodes[n]);
      if (i < segs) {
        const a = this.center(nodes[i]);
        const b = this.center(nodes[i + 1]);
        const f = shown - i;
        this.finger = { x: a.x + (b.x - a.x) * f, y: a.y + (b.y - a.y) * f };
      } else this.finger = this.center(nodes[segs]);
    }
    this.draw();
    if (this.finger) {
      const g = this.ctx;
      const cell = Math.min(this.el.clientWidth, this.el.clientHeight) / 3;
      g.fillStyle = withAlpha(pal().skater, 0.75);
      g.beginPath();
      g.arc(this.finger.x, this.finger.y, cell * 0.22, 0, Math.PI * 2);
      g.fill();
    }
  }

  /** Drop a half-drawn path (new ride). */
  clear(): void {
    this.nodes.length = 0;
    this.draw();
  }

  /**
   * Keyboard input. Returns true when the key was used. Space/Enter with an
   * empty path is left to the caller (e.g. to dismiss the stat card).
   */
  key(e: KeyboardEvent): boolean {
    if (this.pointer !== null || e.repeat || e.metaKey || e.ctrlKey || e.altKey) return false;
    const n = KEY_NODES[e.code];
    if (n !== undefined) {
      const prev = this.nodes[this.nodes.length - 1];
      if (prev === n) return true;
      if (prev !== undefined && !areAdjacent(prev, n)) {
        const mid = midpointNode(prev, n);
        if (mid !== null) this.nodes.push(mid);
      }
      this.nodes.push(n);
      this.draw();
      return true;
    }
    if (e.code === 'Escape' || e.code === 'Backspace') {
      this.nodes.length = 0;
      this.draw();
      return true;
    }
    if ((e.code === 'Space' || e.code === 'Enter' || e.code === 'NumpadEnter') && this.nodes.length > 0) {
      const nodes = [...this.nodes];
      this.nodes.length = 0;
      this.draw();
      this.onRelease(nodes);
      return true;
    }
    return false;
  }

  private local(e: PointerEvent): { x: number; y: number } {
    const r = this.el.getBoundingClientRect();
    return { x: e.clientX - r.left, y: e.clientY - r.top };
  }

  private down(e: PointerEvent): void {
    if (this.pointer !== null) return;
    if (e.clientX < EDGE_GUARD || e.clientY < EDGE_GUARD
      || e.clientX > innerWidth - EDGE_GUARD || e.clientY > innerHeight - EDGE_GUARD) return;
    e.preventDefault();
    this.el.setPointerCapture(e.pointerId);
    this.pointer = e.pointerId;
    this.nodes.length = 0;
    const p = this.local(e);
    this.last = p;
    this.hit(p);
    this.finger = p;
    this.draw();
  }

  private move(e: PointerEvent): void {
    if (e.pointerId !== this.pointer || !this.last) return;
    const from = this.last;
    const to = this.local(e);
    const steps = Math.min(200, Math.max(1, Math.ceil(Math.hypot(to.x - from.x, to.y - from.y) / 4)));
    for (let i = 1; i <= steps; i++) {
      const k = i / steps;
      this.hit({ x: from.x + (to.x - from.x) * k, y: from.y + (to.y - from.y) * k });
    }
    this.last = to;
    this.finger = to;
    this.draw();
  }

  private up(e: PointerEvent, commit: boolean): void {
    if (e.pointerId !== this.pointer) return;
    this.pointer = null;
    const nodes = [...this.nodes];
    this.nodes.length = 0;
    this.finger = null;
    this.draw();
    if (commit) this.onRelease(nodes);
  }

  private center(n: number): { x: number; y: number } {
    const w = this.el.clientWidth / 3;
    const h = this.el.clientHeight / 3;
    return { x: ((n % 3) + 0.5) * w, y: (Math.trunc(n / 3) + 0.5) * h };
  }

  private hit(p: { x: number; y: number }): void {
    const cell = Math.min(this.el.clientWidth, this.el.clientHeight) / 3;
    for (let n = 0; n < 9; n++) {
      const c = this.center(n);
      if (Math.hypot(c.x - p.x, c.y - p.y) > cell * this.hitRadius) continue;
      const prev = this.nodes[this.nodes.length - 1];
      if (prev !== undefined) {
        if (prev === n) return;
        if (!areAdjacent(prev, n)) {
          const mid = midpointNode(prev, n);
          if (mid === null) return;
          this.nodes.push(mid);
        }
      }
      this.nodes.push(n);
      return;
    }
  }

  draw(): void {
    const dpr = devicePixelRatio || 1;
    const w = this.el.clientWidth;
    const h = this.el.clientHeight;
    if (this.el.width !== Math.round(w * dpr)) this.el.width = Math.round(w * dpr);
    if (this.el.height !== Math.round(h * dpr)) this.el.height = Math.round(h * dpr);
    const g = this.ctx;
    g.setTransform(dpr, 0, 0, dpr, 0, 0);
    g.clearRect(0, 0, w, h);
    const cell = Math.min(w, h) / 3;
    for (let n = 0; n < 9; n++) {
      const c = this.center(n);
      const lit = this.nodes.includes(n);
      g.fillStyle = lit ? pal().rampEdge : withAlpha(pal().skater, 0.3);
      g.beginPath();
      g.arc(c.x, c.y, cell * 0.12, 0, Math.PI * 2);
      g.fill();
      g.strokeStyle = lit ? withAlpha(pal().rampEdge, 0.8) : withAlpha(pal().skater, 0.25);
      g.lineWidth = 3;
      g.beginPath();
      g.arc(c.x, c.y, cell * 0.3, 0, Math.PI * 2);
      g.stroke();
    }
    if (this.nodes.length === 0) return;
    g.strokeStyle = withAlpha(pal().rampEdge, 0.85);
    g.lineWidth = cell * 0.09;
    g.lineCap = 'round';
    g.lineJoin = 'round';
    g.beginPath();
    this.nodes.forEach((n, i) => {
      const c = this.center(n);
      if (i === 0) g.moveTo(c.x, c.y);
      else g.lineTo(c.x, c.y);
    });
    if (this.finger) g.lineTo(this.finger.x, this.finger.y);
    g.stroke();
  }
}
