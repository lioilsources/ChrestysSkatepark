import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { parseDartConfig } from '../scripts/dart-config';
import { RIDE_CONFIG_DEFAULTS } from '../src/rules/generated/ride-config';

describe('ride config is generated from Dart', () => {
  it('matches rattleramp/lib/core/ride_config.dart (run `npm run gen` if not)', () => {
    expect(RIDE_CONFIG_DEFAULTS).toEqual(parseDartConfig());
  });

  it('parses the dt fraction', () => {
    expect(parseDartConfig().dt).toBeCloseTo(1 / 120, 15);
  });

  it('generated file is committed as written by the generator', () => {
    const src = readFileSync(fileURLToPath(new URL('../src/rules/generated/ride-config.ts', import.meta.url)), 'utf8');
    expect(src.startsWith('// GENERATED')).toBe(true);
  });

  it('tricks.json is a byte copy of rattleramp/assets/tricks.json (run `npm run gen` if not)', () => {
    const read = (rel: string): string => readFileSync(fileURLToPath(new URL(rel, import.meta.url)), 'utf8');
    expect(read('../src/rules/generated/tricks.json')).toBe(read('../../rattleramp/assets/tricks.json'));
  });
});
