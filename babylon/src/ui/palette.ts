// Active art style (rattleramp/lib/ui/theme.dart: ArtStyle + Palette). Colours come
// from generated/palette.ts (`npm run gen` reads theme.dart). Read at paint time, so
// switching the style restyles everything on the next frame / rebuild.
import { STYLES } from './generated/palette';

export type ArtStyle = keyof typeof STYLES;
export type StyleSpec = (typeof STYLES)[ArtStyle];
export const ART_STYLES = Object.keys(STYLES) as ArtStyle[];

let current: ArtStyle = 'neon';

export const Palette = {
  get style(): ArtStyle { return current; },
  set style(s: ArtStyle) { current = s; },
  get spec(): StyleSpec { return STYLES[current]; },
};

/** Label of the active style (NEON / KOMIKS / PIXEL). */
export const STYLE_LABEL = (): string => STYLES[current].label;

/** Shorthand: colours of the active style. */
export const pal = (): StyleSpec => STYLES[current];

export const nextStyle = (s: ArtStyle): ArtStyle => ART_STYLES[(ART_STYLES.indexOf(s) + 1) % ART_STYLES.length];

export const isArtStyle = (s: unknown): s is ArtStyle => typeof s === 'string' && s in STYLES;

/** '#RRGGBB' or 'rgba(…)' with its alpha multiplied by a. */
export function withAlpha(css: string, a: number): string {
  const hex = /^#([0-9A-Fa-f]{6})$/.exec(css);
  if (hex) {
    const v = parseInt(hex[1], 16);
    return `rgba(${(v >> 16) & 255},${(v >> 8) & 255},${v & 255},${a})`;
  }
  const m = /^rgba\((\d+),(\d+),(\d+),([\d.]+)\)$/.exec(css);
  if (m) return `rgba(${m[1]},${m[2]},${m[3]},${Number(m[4]) * a})`;
  return css;
}

/** RGB 0…1 of a palette colour (alpha ignored), for Babylon materials. */
export function rgb01(css: string): [number, number, number] {
  const hex = /^#([0-9A-Fa-f]{6})$/.exec(css);
  if (hex) {
    const v = parseInt(hex[1], 16);
    return [((v >> 16) & 255) / 255, ((v >> 8) & 255) / 255, (v & 255) / 255];
  }
  const m = /^rgba\((\d+),(\d+),(\d+),/.exec(css);
  if (m) return [Number(m[1]) / 255, Number(m[2]) / 255, Number(m[3]) / 255];
  throw new Error(`bad colour ${css}`);
}

/** Switch the active style and push its colours to the CSS variables and body class. */
export function applyStyle(s: ArtStyle): void {
  current = s;
  const c = STYLES[s];
  const root = document.documentElement.style;
  const vars: Record<string, string> = {
    '--night': c.night, '--ramp-fill': c.rampFill, '--ramp-edge': c.rampEdge, '--coping': c.coping,
    '--skater': c.skater, '--good': c.good, '--perfect': c.perfect, '--miss': c.miss, '--dim': c.dim,
    '--hud': c.skater, '--night-70': withAlpha(c.night, 0.7), '--night-88': withAlpha(c.night, 0.88),
  };
  for (const [k, v] of Object.entries(vars)) root.setProperty(k, v);
  for (const x of ART_STYLES) document.body.classList.toggle(`style-${x}`, x === s);
  document.querySelector('meta[name="theme-color"]')?.setAttribute('content', c.night);
}
