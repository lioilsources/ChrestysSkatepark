import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { describe, expect, it } from 'vitest';
import { parseDartConfig } from '../scripts/dart-config';
import { parseDartTheme, renderPalette } from '../scripts/dart-palette';
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

  it('palette.ts is generated from rattleramp/lib/ui/theme.dart (run `npm run gen` if not)', () => {
    const src = readFileSync(fileURLToPath(new URL('../src/ui/generated/palette.ts', import.meta.url)), 'utf8');
    expect(src).toBe(renderPalette(parseDartTheme()));
  });

  it('theme.dart has three styles with ink only in comic and pixelation only in pixel', () => {
    const t = parseDartTheme();
    expect(Object.keys(t)).toEqual(['neon', 'comic', 'pixel']);
    expect(t.neon.glow).toBe(true);
    expect(t.comic.ink).not.toBeNull();
    expect(t.pixel.pixel).toBe(4);
  });
});
