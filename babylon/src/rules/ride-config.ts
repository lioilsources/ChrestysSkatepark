// RideConfig: defaults are generated from rattleramp/lib/core/ride_config.dart.
import { RIDE_CONFIG_DEFAULTS } from './generated/ride-config';

export type RideConfig = { -readonly [K in keyof typeof RIDE_CONFIG_DEFAULTS]: number };

export const defaultConfig = (): RideConfig => ({ ...RIDE_CONFIG_DEFAULTS });

export const copingHeight = (c: RideConfig): number => c.rampRadius + c.vertHeight;

const clamp01 = (v: number): number => Math.min(1, Math.max(0, v));

export const launchVelocity = (c: RideConfig, speed: number): number => c.vLow + (c.vHigh - c.vLow) * clamp01(speed);

export const windowFactor = (c: RideConfig, speed: number): number =>
  c.windowScale * (1 - (1 - c.windowScaleAtMaxSpeed) * clamp01(speed));
