// Reads the default values of RideConfig straight from the Dart source, so the
// web client never hard-codes a feel constant a second time.
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';

export const DART_CONFIG = fileURLToPath(new URL('../../rattleramp/lib/core/ride_config.dart', import.meta.url));

/** Evaluates the literal forms used in ride_config.dart: `3.0`, `1 / 120`. */
function evalLiteral(expr: string): number {
  const m = /^(-?[\d.]+)\s*\/\s*(-?[\d.]+)$/.exec(expr);
  const v = m ? Number(m[1]) / Number(m[2]) : Number(expr);
  if (!Number.isFinite(v)) throw new Error(`Unsupported default in ride_config.dart: ${expr}`);
  return v;
}

export function parseDartConfig(src: string = readFileSync(DART_CONFIG, 'utf8')): Record<string, number> {
  const ctor = /const RideConfig\(\{([\s\S]*?)\}\);/.exec(src);
  if (!ctor) throw new Error('RideConfig constructor not found');
  const out: Record<string, number> = {};
  for (const m of ctor[1].matchAll(/this\.(\w+)\s*=\s*([^,]+),/g)) out[m[1]] = evalLiteral(m[2].trim());
  if (Object.keys(out).length === 0) throw new Error('No RideConfig defaults found');
  return out;
}
