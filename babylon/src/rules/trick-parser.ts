// Port of rattleramp/lib/core/trick_parser.dart (1:1).
// The pattern splits into maximal runs of one MoveClass (unique, each grid edge has one class):
//   ring run    → one spin per same-direction stretch, 4k-1 … 4k+2 steps count as k half-turns
//   center run  → consecutive grabs, two moves each (a→4→b)
//   diamond run → exactly one flip, matched by full path
import { CENTER_NODE, areAdjacent, classifyMove, ringDirection, type MoveClass } from './grid';
import { trickGrade, type NamedCombo, type TrickBook, type TrickToken } from './trick-defs';

export type ParseError = 'tooShort' | 'notContinuous' | 'unknownGrab' | 'unknownFlip' | 'spinTooShort' | 'danglingCenter';

export class ParsedTrick {
  constructor(readonly tokens: readonly TrickToken[], readonly combo: NamedCombo | null, readonly moves: number) {}

  /** Stable key for variety tracking ("same trick again"). */
  get key(): string { return this.combo?.id ?? this.tokens.map((t) => t.id).join('+'); }
  get name(): string { return this.combo?.name ?? this.tokens.map((t) => t.name).join(' '); }
  get grade(): number { return trickGrade(this.moves); }
  get baseSum(): number { return this.tokens.reduce((s, t) => s + t.base, 0) + (this.combo?.bonus ?? 0); }
}

export type ParseResult =
  | { ok: true; trick: ParsedTrick; error: null }
  | { ok: false; trick: null; error: ParseError };

const fail = (error: ParseError): ParseResult => ({ ok: false, trick: null, error });

/** Spins longer than this are capped (1080 is the top of the trick book). */
export const MAX_SPIN_DEGREES = 1080;

export class TrickParser {
  private readonly grabByEnds: Map<string, TrickToken>;
  private readonly flipByPath: Map<string, TrickToken>;
  private readonly spinByKey: Map<string, TrickToken>;
  private readonly comboByTokens: Map<string, NamedCombo>;

  constructor(readonly book: TrickBook) {
    this.grabByEnds = new Map(book.grabs.map((g) => [`${g.path[0]}-${g.path[g.path.length - 1]}`, g]));
    this.flipByPath = new Map(book.flips.map((f) => [f.path.join(','), f]));
    this.spinByKey = new Map(book.spins.map((s) => [`${s.frontside}-${s.degrees}`, s]));
    this.comboByTokens = new Map(book.combos.map((c) => [c.tokens.join('+'), c]));
  }

  parse(nodes: readonly number[]): ParseResult {
    if (nodes.length < 3) return fail('tooShort');
    for (let i = 1; i < nodes.length; i++) {
      if (!areAdjacent(nodes[i - 1], nodes[i])) return fail('notContinuous');
    }
    const tokens: TrickToken[] = [];
    let i = 0; // index of the run's first node
    while (i < nodes.length - 1) {
      const cls = classifyMove(nodes[i], nodes[i + 1]);
      const dir = cls === 'ring' ? ringDirection(nodes[i], nodes[i + 1]) : 0;
      let j = i + 1; // run end node index
      while (
        j < nodes.length - 1 &&
        classifyMove(nodes[j], nodes[j + 1]) === cls &&
        (cls !== 'ring' || ringDirection(nodes[j], nodes[j + 1]) === dir)
      ) j++;
      const err = this.tokenize(cls, dir, nodes.slice(i, j + 1), tokens);
      if (err !== null) return fail(err);
      i = j;
    }
    const combo = this.comboByTokens.get(tokens.map((t) => t.id).join('+')) ?? null;
    return { ok: true, trick: new ParsedTrick(tokens, combo, nodes.length - 1), error: null };
  }

  private tokenize(cls: MoveClass, dir: number, run: readonly number[], out: TrickToken[]): ParseError | null {
    const moves = run.length - 1;
    switch (cls) {
      case 'ring': {
        const halfTurns = Math.trunc((moves + 1) / 4);
        if (halfTurns === 0) return 'spinTooShort';
        const deg = Math.min(MAX_SPIN_DEGREES, Math.max(180, halfTurns * 180));
        out.push(this.spinByKey.get(`${dir > 0}-${deg}`)!);
        return null;
      }
      case 'center': {
        if (moves % 2 !== 0 || run[0] === CENTER_NODE) return 'danglingCenter';
        for (let k = 0; k < moves; k += 2) {
          const g = this.grabByEnds.get(`${run[k]}-${run[k + 2]}`);
          if (!g) return 'unknownGrab';
          out.push(g);
        }
        return null;
      }
      case 'diamond': {
        const f = this.flipByPath.get(run.join(','));
        if (!f) return 'unknownFlip';
        out.push(f);
        return null;
      }
    }
  }
}
