// Port of rattleramp/lib/core/trick_defs.dart (1:1).
// Trick definitions from assets/tricks.json, copied unchanged to generated/tricks.json by `npm run gen`.
import tricksJson from './generated/tricks.json';

export type TokenKind = 'spin' | 'grab' | 'flip';
export type GrabHand = 'front' | 'back' | 'both';
export type GrabStyle = 'tuck' | 'tweak' | 'stiff' | 'split' | 'kick' | 'spread';

/** How a grab looks: hand, spot on the board (−1 tail … +1 nose), body shape, extra tilt (rad). */
export interface GrabLook { hand: GrabHand; at: number; style: GrabStyle; tilt: number }

/** Board rotation of a flip in full turns per axis. */
export interface FlipLook { roll: number; shove: number; tumble: number }

export const DEFAULT_GRAB_LOOK: Readonly<GrabLook> = Object.freeze({ hand: 'front', at: 0, style: 'tuck', tilt: 0 });
const DEFAULT_FLIP_LOOK: Readonly<FlipLook> = Object.freeze({ roll: 1, shove: 0, tumble: 0 });

export interface TrickToken {
  readonly id: string;
  readonly name: string;
  readonly kind: TokenKind;
  readonly base: number;
  readonly path: readonly number[];
  /** Spins only: degrees and direction (true = frontside / clockwise). */
  readonly degrees: number;
  readonly frontside: boolean;
  readonly grabLook: Readonly<GrabLook>;
  readonly flipLook: Readonly<FlipLook>;
}

export const tokenMoves = (t: TrickToken): number => t.path.length - 1;

export interface NamedCombo {
  readonly id: string;
  readonly name: string;
  readonly tokens: readonly string[];
  readonly bonus: number;
}

interface TricksJson {
  spins: { deg: number; base: number }[];
  grabs: { id: string; name: string; path: number[]; base: number; look?: Partial<GrabLook> }[];
  flips: { id: string; name: string; path: number[]; base: number; look?: Partial<FlipLook> }[];
  combos: { id: string; name: string; tokens: string[]; bonus: number }[];
}

const RING = [0, 1, 2, 5, 8, 7, 6, 3];

/** Ring path of `steps` moves starting at `start` (clockwise = frontside). */
export function ringPath(start: number, steps: number, clockwise: boolean): number[] {
  let i = RING.indexOf(start);
  const out = [start];
  for (let k = 0; k < steps; k++) {
    i = (((i + (clockwise ? 1 : -1)) % 8) + 8) % 8;
    out.push(RING[i]);
  }
  return out;
}

export class TrickBook {
  private readonly byId: Map<string, TrickToken>;

  constructor(
    readonly spins: readonly TrickToken[],
    readonly grabs: readonly TrickToken[],
    readonly flips: readonly TrickToken[],
    readonly combos: readonly NamedCombo[],
  ) {
    this.byId = new Map([...spins, ...grabs, ...flips].map((t) => [t.id, t]));
  }

  get allTokens(): TrickToken[] { return [...this.grabs, ...this.flips, ...this.spins]; }

  token(id: string): TrickToken | undefined { return this.byId.get(id); }

  /** One drawable node path for a named combo; null when the tokens don't chain. */
  comboPath(c: NamedCombo): number[] | null {
    let path: number[] | null = null;
    for (const id of c.tokens) {
      const t = this.token(id);
      if (!t) throw new Error(`unknown token ${id}`);
      const p: readonly number[] = t.kind === 'spin'
        ? ringPath(path ? path[path.length - 1] : 1, Math.trunc(t.degrees / 45), t.frontside)
        : t.path;
      if (path !== null && path[path.length - 1] !== p[0]) return null;
      path = path === null ? [...p] : [...path, ...p.slice(1)];
    }
    return path;
  }

  static fromJson(j: TricksJson): TrickBook {
    const spins: TrickToken[] = [];
    for (const s of j.spins) {
      const steps = Math.trunc(s.deg / 45);
      for (const fs of [true, false]) {
        spins.push({
          id: `${fs ? 'fs' : 'bs'}${s.deg}`,
          name: `${fs ? 'FS' : 'BS'} ${s.deg}`,
          kind: 'spin',
          base: s.base,
          path: ringPath(1, steps, fs),
          degrees: s.deg,
          frontside: fs,
          grabLook: DEFAULT_GRAB_LOOK,
          flipLook: DEFAULT_FLIP_LOOK,
        });
      }
    }
    const fixed = (kind: 'grab' | 'flip', list: TricksJson['grabs'] | TricksJson['flips']): TrickToken[] =>
      list.map((g) => ({
        id: g.id,
        name: g.name,
        kind,
        base: g.base,
        path: [...g.path],
        degrees: 0,
        frontside: true,
        grabLook: kind === 'grab' && g.look ? { ...DEFAULT_GRAB_LOOK, ...(g.look as Partial<GrabLook>) } : DEFAULT_GRAB_LOOK,
        flipLook: kind === 'flip' && g.look ? { roll: 0, shove: 0, tumble: 0, ...(g.look as Partial<FlipLook>) } : DEFAULT_FLIP_LOOK,
      }));
    return new TrickBook(
      spins,
      fixed('grab', j.grabs),
      fixed('flip', j.flips),
      j.combos.map((c) => ({ id: c.id, name: c.name, tokens: [...c.tokens], bonus: c.bonus })),
    );
  }
}

/** The trick book shipped with the game (same JSON as the Flutter app). */
export const defaultBook = (): TrickBook => TrickBook.fromJson(tricksJson as TricksJson);

/** Trick "stupeň" 1–5 from pattern length; roughly the speed it needs. */
export function trickGrade(moves: number): number {
  if (moves <= 2) return 1;
  if (moves <= 5) return 2;
  if (moves <= 9) return 3;
  if (moves <= 15) return 4;
  return 5;
}

/**
 * "Trik dne": one grab or flip, ×2 points, changes at local midnight.
 * Takes the local calendar date (month 1–12), so every device agrees.
 * Same hash as Dart: low 31 bits of day × 2654435761 (exact in doubles below 2^53).
 */
export function dailyToken(book: TrickBook, year: number, month: number, day: number): TrickToken {
  const pool = [...book.grabs, ...book.flips];
  const d = Math.floor(Date.UTC(year, month - 1, day) / 86400000);
  const prod = d * 2654435761;
  const h = prod - Math.floor(prod / 2147483648) * 2147483648; // & 0x7fffffff for non-negative ints
  return pool[h % pool.length];
}

/** dailyToken for a JS Date in the viewer's local time zone. */
export const dailyTokenFor = (book: TrickBook, now: Date): TrickToken =>
  dailyToken(book, now.getFullYear(), now.getMonth() + 1, now.getDate());
