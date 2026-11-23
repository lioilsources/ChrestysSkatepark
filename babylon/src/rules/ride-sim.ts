// Port of rattleramp/lib/core/ride_sim.dart (1:1). Deterministic ride, fixed timestep.
// Same config + same ReleaseInputs ⇒ same ride; a replay is the input log (replayJson()).
// Each segment rolls coping → coping (segStart → tEdge), then airs (tEdge → tLand).
import { Ramp } from './ramp';
import { copingHeight, launchVelocity, windowFactor, type RideConfig } from './ride-config';
import { scoreTrick, type ScoreBreakdown, type Timing } from './scoring';
import { DEFAULT_GRAB_LOOK, tokenMoves, type GrabLook, type TrickToken } from './trick-defs';
import type { ParseError, ParseResult, ParsedTrick, TrickParser } from './trick-parser';

export type { Timing } from './scoring';

/** One finished swipe: node path and the moment the finger lifted, in ride seconds. */
export interface ReleaseInput { t: number; nodes: readonly number[] }

export type RidePhase = 'dropIn' | 'rolling' | 'air' | 'bail' | 'rollout' | 'finished';
export type BailReason = 'timingMiss' | 'badPattern' | 'trickTooLong';
export type RideEventType = 'judged' | 'tooEarly' | 'landed' | 'emptyAir' | 'bail' | 'outOfSpeed' | 'finished';

export type RideEvent =
  | { type: 'judged'; t: number; timing: Timing; trick: ParsedTrick | null; parseError: ParseError | null; delta: number }
  | { type: 'tooEarly'; t: number }
  | { type: 'landed'; t: number; timing: Timing; trick: ParsedTrick; score: ScoreBreakdown }
  | { type: 'emptyAir'; t: number }
  | { type: 'bail'; t: number; bailReason: BailReason }
  | { type: 'outOfSpeed'; t: number }
  | { type: 'finished'; t: number };

interface Attempt { timing: Timing; parse: ParseResult; tStart: number }
const fatal = (a: Attempt): boolean => a.timing === 'miss' || !a.parse.ok;

/** Everything the renderer needs for one frame. */
export interface SkaterPose {
  /** Board-centre contact point in world metres. */
  x: number;
  y: number;
  /** Rotation of the skater's local frame; local +y is "up" for the skater. */
  angle: number;
  /** −1…1 horizontal scale: sign = facing, |value| < 1 = mid-spin. */
  facing: number;
  /** Board rotation in full turns (long, vertical, short axis). */
  roll: number;
  shove: number;
  tumble: number;
  /** 0…1 how far the feet lift off the board for a flip. */
  flip: number;
  /** 0…1 how far the hand reaches for the board. */
  grab: number;
  grabLook: Readonly<GrabLook>;
  crouch: number;
  /** 0…1 progress of a bail fall, 0 when riding. */
  bail: number;
}

const pose = (p: Partial<SkaterPose> & Pick<SkaterPose, 'x' | 'y' | 'angle' | 'facing'>): SkaterPose => ({
  roll: 0, shove: 0, tumble: 0, flip: 0, grab: 0, grabLook: DEFAULT_GRAB_LOOK, crouch: 0, bail: 0, ...p,
});

export class RideStats {
  score = 0;
  landed = 0;
  streak = 0;
  maxStreak = 0;
  bestTrick: string | null = null;
  bestTrickPoints = 0;
  timingSum = 0;
  readonly trickCounts = new Map<string, number>();

  /** 0…1 — perfect = 1, good = ⅔, late = ⅓. */
  get averageTiming(): number { return this.landed === 0 ? 0 : this.timingSum / this.landed; }
}

const TABLE_DT = 1 / 240;
const ROLLOUT_DURATION = 3.0;
const clamp = (v: number, lo: number, hi: number): number => Math.min(hi, Math.max(lo, v));
const clamp01 = (v: number): number => clamp(v, 0, 1);
/** Smoothstep, so the board snaps out of and back under the feet. */
const ease = (k: number): number => k * k * (3 - 2 * k);

export interface RideOptions { proMode?: boolean; dailyTokenId?: string | null }

export class RideSim {
  readonly ramp: Ramp;
  readonly proMode: boolean;
  readonly dailyTokenId: string | null;
  readonly inputs: ReleaseInput[] = [];
  readonly stats = new RideStats();

  time = 0;
  phase: RidePhase = 'dropIn';
  speed: number;
  /** +1 rolling towards the right coping, −1 towards the left. */
  dir = 1;
  /** Visual stance: −1 after an odd number of half spins (riding fakie). */
  stance = 1;
  bailReason: BailReason | null = null;

  segStart = 0;
  tEdge = 0;
  tLand = 0;
  private vLaunch = 0;
  private distTable: number[] = [];
  private attempt: Attempt | null = null;
  private nextInput = 0;
  private phaseStart = 0;
  private bailS = 0;
  private bailDir = 1;
  private events: RideEvent[] = [];

  constructor(readonly config: RideConfig, readonly parser: TrickParser, opts: RideOptions = {}) {
    this.ramp = new Ramp(config.rampRadius, config.flatWidth, config.vertHeight);
    this.proMode = opts.proMode ?? false;
    this.dailyTokenId = opts.dailyTokenId ?? null;
    this.speed = config.startSpeed;
    this.startSegment(config.dropInDelay);
  }

  get finished(): boolean { return this.phase === 'finished'; }
  /** Side of the coping the current segment is heading to. */
  get edgeSide(): number { return this.dir; }
  /** Remaining time to the edge (negative once airborne). */
  get timeToEdge(): number { return this.tEdge - this.time; }
  get perfectWindow(): number { return this.config.perfectWindow * windowFactor(this.config, this.speed); }
  get goodWindow(): number { return this.config.goodWindow * windowFactor(this.config, this.speed); }
  get lateWindow(): number { return this.config.lateWindow * windowFactor(this.config, this.speed); }
  get hasAttempt(): boolean { return this.attempt !== null; }
  /** The trick being performed in the current air, if any. */
  get currentTrick(): ParsedTrick | null { return this.attempt?.parse.trick ?? null; }

  /** Queue a release. Timestamps must be non-decreasing. */
  addInput(input: ReleaseInput): void {
    const last = this.inputs[this.inputs.length - 1];
    if (last && input.t < last.t) throw new Error('inputs must be non-decreasing');
    this.inputs.push(input);
  }

  /** Events produced since the last call. */
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

  /** Run until finished (or maxSeconds); used by tests and replays. */
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
        table.push(len); // stretch the final sample so the table ends exactly at the coping
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

  /** Path parameter for the current rolling segment. */
  get pathS(): number {
    const d = this.distanceAt(this.time);
    return this.dir > 0 ? d : this.ramp.length - d;
  }

  get airHeight(): number {
    if (this.phase !== 'air') return 0;
    const tau = this.time - this.tEdge;
    return this.vLaunch * tau - (this.config.gravity * tau * tau) / 2;
  }

  get maxAirHeight(): number { return (this.vLaunch * this.vLaunch) / (2 * this.config.gravity); }
  get airDuration(): number { return this.tLand - this.tEdge; }

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
      case 'rolling': {
        const a = this.attempt;
        if (a !== null && fatal(a)) this.bail(a.parse.ok ? 'timingMiss' : 'badPattern', this.ramp.length * (this.dir > 0 ? 1 : 0));
        else this.phase = 'air';
        break;
      }
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
    const edgeS = this.dir > 0 ? this.ramp.length : 0;
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
    } else if (!a.parse.ok || a.timing === 'miss') {
      this.bail(a.parse.ok ? 'timingMiss' : 'badPattern', edgeS);
      return;
    } else {
      const trick = a.parse.trick;
      if (a.tStart + this.trickDuration(trick) > this.tLand + 1e-9) {
        this.bail('trickTooLong', edgeS);
        return;
      }
      this.score(trick, a.timing);
      if (this.halfSpins(trick) % 2 !== 0) this.stance = -this.stance;
    }
    this.dir = -this.dir;
    this.phase = 'rolling';
    this.startSegment(this.time);
  }

  private score(trick: ParsedTrick, timing: Timing): void {
    const st = this.stats;
    const c = this.config;
    const prev = st.trickCounts.get(trick.key) ?? 0;
    const sb = scoreTrick({
      trick, timing, speed: this.speed, streak: st.streak, previousCount: prev,
      airHeight: this.maxAirHeight, proMode: this.proMode, dailyTokenId: this.dailyTokenId,
    });
    st.trickCounts.set(trick.key, prev + 1);
    st.score += sb.total;
    st.landed++;
    st.streak++;
    st.maxStreak = Math.max(st.maxStreak, st.streak);
    st.timingSum += timing === 'perfect' ? 1.0 : timing === 'good' ? 2 / 3 : 1 / 3;
    if (sb.total > st.bestTrickPoints) {
      st.bestTrickPoints = sb.total;
      st.bestTrick = trick.name;
    }
    this.speed += timing === 'perfect' ? c.gainPerfect : timing === 'good' ? c.gainGood : -c.lossLate;
    this.speed += c.gainPerGrade * trick.grade;
    this.speed = clamp01(this.speed);
    this.events.push({ type: 'landed', t: this.time, timing, trick, score: sb });
  }

  private bail(reason: BailReason, atS: number): void {
    this.bailReason = reason;
    this.stats.streak = 0;
    this.phase = 'bail';
    this.phaseStart = this.time;
    this.bailS = atS;
    this.bailDir = atS > this.ramp.length / 2 ? -1 : 1;
    this.events.push({ type: 'bail', t: this.time, bailReason: reason });
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
    const parse = this.parser.parse(input.nodes);
    if (parse.error === 'tooShort') return; // stray tap / palm
    const t = input.t - this.config.inputLatency;
    const d = t - this.tEdge;
    if (d < -this.config.cueLead) {
      this.events.push({ type: 'tooEarly', t: this.time });
      return;
    }
    let timing: Timing;
    if (Math.abs(d) <= this.perfectWindow) timing = 'perfect';
    else if (Math.abs(d) <= this.goodWindow) timing = 'good';
    else if (d > 0 && d <= this.lateWindow) timing = 'late';
    else timing = 'miss';
    this.attempt = { timing, parse, tStart: Math.max(t, this.tEdge) };
    this.events.push({ type: 'judged', t: this.time, timing, trick: parse.trick, parseError: parse.error, delta: d });
  }

  // ── Trick playback ────────────────────────────────────────────────────

  tokenDuration(t: TrickToken): number { return tokenMoves(t) * this.config.secondsPerMove + this.config.secondsPerToken; }

  trickDuration(trick: ParsedTrick): number { return trick.tokens.reduce((s, t) => s + this.tokenDuration(t), 0); }

  private halfSpins(trick: ParsedTrick): number {
    return trick.tokens.filter((t) => t.kind === 'spin').reduce((s, t) => s + Math.trunc(t.degrees / 180), 0);
  }

  /** Normalised launch speed at which trick still fits the air from the edge; > 1 = never. */
  speedNeeded(trick: ParsedTrick): number {
    const v = (this.trickDuration(trick) * this.config.gravity) / 2;
    return (v - this.config.vLow) / (this.config.vHigh - this.config.vLow);
  }

  // ── Pose ──────────────────────────────────────────────────────────────

  get pose(): SkaterPose {
    const r = this.ramp;
    switch (this.phase) {
      case 'dropIn': {
        const c = r.coping(-1);
        const k = clamp01((this.time - (this.segStart - 0.25)) / 0.25);
        return pose({ x: c.x - 0.45 * (1 - k), y: c.y, angle: (-k * Math.PI) / 2, facing: 1, crouch: 0.3 * k });
      }
      case 'rolling': {
        const s = this.pathS;
        const p = r.point(s);
        const h = p.y / r.copingHeight;
        return pose({ x: p.x, y: p.y, angle: r.tangent(s), facing: this.dir * this.stance, crouch: 0.15 + 0.35 * (1 - h) * (1 - h) });
      }
      case 'air':
        return this.airPose();
      case 'bail': {
        const k = clamp01((this.time - this.phaseStart) / this.config.bailDuration);
        const s = clamp(this.bailS + this.bailDir * 4.0 * (1 - Math.exp(-3 * k)), 0, r.length);
        const p = r.point(s);
        return pose({ x: p.x, y: p.y, angle: r.tangent(s), facing: this.bailDir, bail: k });
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
        return pose({ x: p.x, y: p.y, angle: r.tangent(s), facing: (moving >= 0 ? 1 : -1) * this.stance, crouch: 0.1 });
      }
    }
  }

  private airPose(): SkaterPose {
    const tau = this.time - this.tEdge;
    const u = clamp01(tau / this.airDuration);
    const c = this.ramp.coping(this.dir);
    const exit = this.dir > 0 ? Math.PI / 2 : -Math.PI / 2;
    const angle = exit - this.dir * (Math.PI / 2) * Math.sin(Math.PI * u);
    let spin = 0, roll = 0, shove = 0, tumble = 0, flip = 0, grab = 0;
    let look: Readonly<GrabLook> = DEFAULT_GRAB_LOOK;
    const a = this.attempt;
    if (a !== null && a.parse.ok) {
      let t0 = a.tStart;
      for (const tok of a.parse.trick.tokens) {
        const dur = this.tokenDuration(tok);
        const k = clamp01((this.time - t0) / dur);
        switch (tok.kind) {
          case 'spin':
            spin += (k * tok.degrees * Math.PI) / 180;
            break;
          case 'flip': {
            const f = tok.flipLook;
            const e = ease(k);
            roll += e * f.roll;
            shove += e * f.shove;
            tumble += e * f.tumble;
            if (k > 0 && k < 1) flip = Math.sin(Math.PI * k);
            break;
          }
          case 'grab':
            if (k > 0 && k < 1) {
              grab = Math.sin(Math.PI * k);
              look = tok.grabLook;
            }
            break;
        }
        t0 += dur;
      }
    }
    return pose({
      x: c.x + this.dir * 0.15 * Math.sin(Math.PI * u),
      y: c.y + this.airHeight,
      angle,
      facing: this.dir * this.stance * Math.cos(Math.PI * u + spin),
      roll, shove, tumble, flip, grab, grabLook: look,
      crouch: 0.25 + 0.3 * flip + 0.4 * grab,
    });
  }

  // ── Replay ────────────────────────────────────────────────────────────

  replayJson(): { v: 1; pro: boolean; daily: string | null; inputs: { t: number; n: number[] }[] } {
    return { v: 1, pro: this.proMode, daily: this.dailyTokenId, inputs: this.inputs.map((i) => ({ t: i.t, n: [...i.nodes] })) };
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
