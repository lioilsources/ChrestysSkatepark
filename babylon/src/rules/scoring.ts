// Port of rattleramp/lib/core/scoring.dart (1:1).
// body = Σ(token.base) × timing × speed × combo × variety + air_height_bonus
import type { ParsedTrick } from './trick-parser';

export type Timing = 'perfect' | 'good' | 'late' | 'miss';

export const timingMultiplier = (t: Timing): number =>
  t === 'perfect' ? 1.5 : t === 'good' ? 1.0 : t === 'late' ? 0.6 : 0.0;

/** 1.0 for the first time in a ride, 0.5 the second, 0.25 after that. */
export const varietyMultiplier = (previousCount: number): number =>
  previousCount === 0 ? 1.0 : previousCount === 1 ? 0.5 : 0.25;

export interface ScoreBreakdown {
  base: number;
  timing: number;
  speed: number;
  combo: number;
  variety: number;
  daily: number;
  airBonus: number;
  total: number;
}

/** Dart's num.round(): half away from zero (Math.round rounds −0.5 up). */
export const dartRound = (v: number): number => Math.sign(v) * Math.round(Math.abs(v));

export interface ScoreInput {
  trick: ParsedTrick;
  timing: Timing;
  speed: number;
  streak: number;
  previousCount: number;
  airHeight: number;
  proMode?: boolean;
  dailyTokenId?: string | null;
}

export function scoreTrick(i: ScoreInput): ScoreBreakdown {
  const base = i.trick.baseSum;
  const tm = timingMultiplier(i.timing);
  const sm = 1.0 + Math.min(1, Math.max(0, i.speed));
  const cm = 1.0 + 0.1 * i.streak;
  const vm = varietyMultiplier(i.previousCount);
  const dm = i.dailyTokenId != null && i.trick.tokens.some((t) => t.id === i.dailyTokenId) ? 2.0 : 1.0;
  const air = i.airHeight > 0.8 ? dartRound((i.airHeight - 0.8) * 150) : 0;
  const raw = base * tm * sm * cm * vm * dm + air;
  return {
    base, timing: tm, speed: sm, combo: cm, variety: vm, daily: dm, airBonus: air,
    total: dartRound(raw * (i.proMode ? 1.5 : 1.0)),
  };
}
