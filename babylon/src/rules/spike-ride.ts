// F0 spike: the segment physics and release timing of rattleramp/lib/core/ride_sim.dart,
// without the trick parser and scoring (those come in F1 with golden vectors).
// Any swipe of 3+ nodes counts as a trick. Same fixed step, same distance table,
// same timing windows as the Dart sim, so the feel can be compared side by side.
import { Ramp } from './ramp';
import { copingHeight, launchVelocity, windowFactor, type RideConfig } from './ride-config';

export type RidePhase = 'dropIn' | 'rolling' | 'air' | 'bail' | 'rollout' | 'finished';
export type Timing = 'perfect' | 'good' | 'late' | 'miss';

export interface ReleaseInput { t: number; nodes: readonly number[] }

export type RideEvent =
  | { type: 'judged'; t: number; timing: Timing; delta: number }
  | { type: 'tooEarly'; t: number }
  | { type: 'landed'; t: number; timing: Timing }
  | { type: 'emptyAir'; t: number }
  | { type: 'bail'; t: number }
  | { type: 'outOfSpeed'; t: number }
  | { type: 'finished'; t: number };

export interface SkaterPose {
  x: number;
  y: number;
  angle: number;
  /** −1…1 horizontal scale: sign = facing. */
  facing: number;
  crouch: number;
  /** 0…1 progress of a bail fall. */
  bail: number;
}

const TABLE_DT = 1 / 240;
const ROLLOUT_DURATION = 3.0;
const clamp01 = (v: number): number => Math.min(1, Math.max(0, v));

export class SpikeRide {
  readonly ramp: Ramp;
  readonly inputs: ReleaseInput[] = [];
  time = 0;
  phase: RidePhase = 'dropIn';
  speed: number;
  /** +1 rolling towards the right coping, −1 towards the left. */
  dir = 1;
  landed = 0;

  segStart = 0;
  tEdge = 0;
  tLand = 0;
  private vLaunch = 0;
  private distTable: number[] = [];
  private attempt: { timing: Timing } | null = null;
  private nextInput = 0;
  private phaseStart = 0;
  private bailS = 0;
  private bailDir = 1;
  private events: RideEvent[] = [];

  constructor(readonly config: RideConfig) {
    this.ramp = new Ramp(config.rampRadius, config.flatWidth, config.vertHeight);
    this.speed = config.startSpeed;
    this.startSegment(config.dropInDelay);
  }

  get finished(): boolean { return this.phase === 'finished'; }
  get timeToEdge(): number { return this.tEdge - this.time; }
  get perfectWindow(): number { return this.config.perfectWindow * windowFactor(this.config, this.speed); }
  get goodWindow(): number { return this.config.goodWindow * windowFactor(this.config, this.speed); }
  get lateWindow(): number { return this.config.lateWindow * windowFactor(this.config, this.speed); }
  get maxAirHeight(): number { return (this.vLaunch * this.vLaunch) / (2 * this.config.gravity); }
  get airDuration(): number { return this.tLand - this.tEdge; }

  /** Queue a release. Timestamps must be non-decreasing. */
  addInput(input: ReleaseInput): void {
    const last = this.inputs[this.inputs.length - 1];
    if (last && input.t < last.t) throw new Error('inputs must be non-decreasing');
    this.inputs.push(input);
  }

  drainEvents(): RideEvent[] {
    const out = this.events;
    this.events = [];
    return out;
  }

  /** Advance exactly one fixed tick. */
  step(): void {
    const target = this.time + this.config.dt;
    for (;;) {
      const boundary = this.nextBoundary();
      this.processInputs(Math.min(boundary, target));
      if (boundary <= target) {
        this.time = boundary;
        this.transition();
        if (this.phase === 'finished') return;
      } else {
        this.time = target;
        return;
      }
    }
  }

  runToEnd(maxSeconds = 600): void {
    while (!this.finished && this.time < maxSeconds) this.step();
  }

  // ── Segment physics ───────────────────────────────────────────────────

  private startSegment(start: number): void {
    this.segStart = start;
    this.vLaunch = launchVelocity(this.config, this.speed);
    this.distTable = this.buildDistanceTable(this.vLaunch);
    this.tEdge = this.segStart + (this.distTable.length - 1) * TABLE_DT;
    this.tLand = this.tEdge + (2 * this.vLaunch) / this.config.gravity;
    this.attempt = null;
  }

  /** Distance along the path every TABLE_DT, coping to coping; last sample = ramp.length. */
  private buildDistanceTable(v0: number): number[] {
    const g = this.config.gravity;
    const h = this.ramp.copingHeight;
    const len = this.ramp.length;
    const v = (s: number): number => Math.sqrt(v0 * v0 + 2 * g * (h - this.ramp.height(s)));
    const sub = 8;
    const hdt = TABLE_DT / sub;
    const table = [0];
    let s = 0;
    for (;;) {
      for (let k = 0; k < sub; k++) {
        const mid = s + (v(s) * hdt) / 2;
        s += v(mid) * hdt;
      }
      if (s >= len) {
        table.push(len);
        return table;
      }
      table.push(s);
    }
  }

  private distanceAt(t: number): number {
    const f = (t - this.segStart) / TABLE_DT;
    if (f <= 0) return 0;
    const i = Math.floor(f);
    const tab = this.distTable;
    if (i >= tab.length - 1) return tab[tab.length - 1];
    return tab[i] + (tab[i + 1] - tab[i]) * (f - i);
  }

  get pathS(): number {
    const d = this.distanceAt(this.time);
    return this.dir > 0 ? d : this.ramp.length - d;
  }

  get airHeight(): number {
    if (this.phase !== 'air') return 0;
    const tau = this.time - this.tEdge;
    return this.vLaunch * tau - (this.config.gravity * tau * tau) / 2;
  }

  // ── State machine ─────────────────────────────────────────────────────

  private nextBoundary(): number {
    switch (this.phase) {
      case 'dropIn': return this.segStart;
      case 'rolling': return this.tEdge;
      case 'air': return this.tLand;
      case 'bail': return this.phaseStart + this.config.bailDuration;
      case 'rollout': return this.phaseStart + ROLLOUT_DURATION;
      case 'finished': return Infinity;
    }
  }

  private transition(): void {
    switch (this.phase) {
      case 'dropIn':
        this.phase = 'rolling';
        break;
      case 'rolling':
        if (this.attempt?.timing === 'miss') this.bail(this.dir > 0 ? this.ramp.length : 0);
        else this.phase = 'air';
        break;
      case 'air':
        this.land();
        break;
      case 'bail':
      case 'rollout':
        this.phase = 'finished';
        this.events.push({ type: 'finished', t: this.time });
        break;
      case 'finished':
        break;
    }
  }

  private land(): void {
    const a = this.attempt;
    const c = this.config;
    if (a === null) {
      this.speed -= c.lossEmptyAir;
      this.events.push({ type: 'emptyAir', t: this.time });
      if (this.speed < 0) {
        this.speed = 0;
        this.phase = 'rollout';
        this.phaseStart = this.time;
        this.events.push({ type: 'outOfSpeed', t: this.time });
        return;
      }
    } else if (a.timing === 'miss') {
      this.bail(this.dir > 0 ? this.ramp.length : 0);
      return;
    } else {
      this.landed++;
      this.speed += a.timing === 'perfect' ? c.gainPerfect : a.timing === 'good' ? c.gainGood : -c.lossLate;
      this.speed = clamp01(this.speed);
      this.events.push({ type: 'landed', t: this.time, timing: a.timing });
    }
    this.dir = -this.dir;
    this.phase = 'rolling';
    this.startSegment(this.time);
  }

  private bail(atS: number): void {
    this.phase = 'bail';
    this.phaseStart = this.time;
    this.bailS = atS;
    this.bailDir = atS > this.ramp.length / 2 ? -1 : 1;
    this.events.push({ type: 'bail', t: this.time });
  }

  // ── Input judgement ───────────────────────────────────────────────────

  private processInputs(until: number): void {
    while (this.nextInput < this.inputs.length && this.inputs[this.nextInput].t <= until) {
      this.judge(this.inputs[this.nextInput++]);
    }
  }

  private judge(input: ReleaseInput): void {
    if (this.phase !== 'rolling' && this.phase !== 'air' && this.phase !== 'dropIn') return;
    if (this.attempt !== null) return;
    if (input.nodes.length < 3) return; // stray tap / palm
    const d = input.t - this.config.inputLatency - this.tEdge;
    if (d < -this.config.cueLead) {
      this.events.push({ type: 'tooEarly', t: this.time });
      return;
    }
    let timing: Timing;
    if (Math.abs(d) <= this.perfectWindow) timing = 'perfect';
    else if (Math.abs(d) <= this.goodWindow) timing = 'good';
    else if (d > 0 && d <= this.lateWindow) timing = 'late';
    else timing = 'miss';
    this.attempt = { timing };
    this.events.push({ type: 'judged', t: this.time, timing, delta: d });
  }

  // ── Pose (same formulas as RideSim.pose, minus trick rotations) ──────────

  get pose(): SkaterPose {
    const r = this.ramp;
    switch (this.phase) {
      case 'dropIn': {
        const c = r.coping(-1);
        const k = clamp01((this.time - (this.segStart - 0.25)) / 0.25);
        return { x: c.x - 0.45 * (1 - k), y: c.y, angle: (-k * Math.PI) / 2, facing: 1, crouch: 0.3 * k, bail: 0 };
      }
      case 'rolling': {
        const s = this.pathS;
        const p = r.point(s);
        const h = p.y / r.copingHeight;
        return { x: p.x, y: p.y, angle: r.tangent(s), facing: this.dir, crouch: 0.15 + 0.35 * (1 - h) * (1 - h), bail: 0 };
      }
      case 'air': {
        const tau = this.time - this.tEdge;
        const u = clamp01(tau / this.airDuration);
        const c = r.coping(this.dir);
        const exit = this.dir > 0 ? Math.PI / 2 : -Math.PI / 2;
        return {
          x: c.x + this.dir * 0.15 * Math.sin(Math.PI * u),
          y: c.y + this.airHeight,
          angle: exit - this.dir * (Math.PI / 2) * Math.sin(Math.PI * u),
          facing: this.dir * Math.cos(Math.PI * u),
          crouch: 0.25,
          bail: 0,
        };
      }
      case 'bail': {
        const k = clamp01((this.time - this.phaseStart) / this.config.bailDuration);
        const s = Math.min(r.length, Math.max(0, this.bailS + this.bailDir * 4.0 * (1 - Math.exp(-3 * k))));
        const p = r.point(s);
        return { x: p.x, y: p.y, angle: r.tangent(s), facing: this.bailDir, crouch: 0, bail: k };
      }
      case 'rollout':
      case 'finished': {
        const tau = this.time - this.phaseStart;
        const half = r.length / 2;
        const amp = half * 0.85 * Math.exp(-tau / 0.9);
        const edge = this.dir > 0 ? 1 : -1;
        const s = half + edge * amp * Math.cos((2 * Math.PI * tau) / 2.4);
        const p = r.point(s);
        const moving = -edge * Math.sin((2 * Math.PI * tau) / 2.4);
        return { x: p.x, y: p.y, angle: r.tangent(s), facing: moving >= 0 ? 1 : -1, crouch: 0.1, bail: 0 };
      }
    }
  }
}

/** World extents used for camera fit (WorldView.fit in rattle_game.dart). */
export function worldBounds(c: RideConfig, ramp: Ramp): { width: number; bottom: number; top: number } {
  return {
    width: 2 * (ramp.copingX + 1.2),
    bottom: -0.4,
    top: copingHeight(c) + (c.vHigh * c.vHigh) / (2 * c.gravity) + 0.5,
  };
}
