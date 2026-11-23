import { describe, expect, it } from 'vitest';
import { defaultBook, tokenMoves, trickGrade } from '../src/rules/trick-defs';
import { TrickParser } from '../src/rules/trick-parser';
import { bookEntries } from '../src/ui/trick-book';

const book = defaultBook();
const parser = new TrickParser(book);

describe('trick book entries (trick_book_screen.dart)', () => {
  it('tabs list every grab, flip, spin and drawable combo', () => {
    expect(bookEntries(book, parser, 0)).toHaveLength(book.grabs.length);
    expect(bookEntries(book, parser, 1)).toHaveLength(book.flips.length);
    expect(bookEntries(book, parser, 2)).toHaveLength(book.spins.length);
    expect(bookEntries(book, parser, 3)).toHaveLength(book.combos.filter((c) => book.comboPath(c) !== null).length);
  });

  it('every pattern in the book parses back to its own entry', () => {
    for (const t of book.allTokens) {
      const r = parser.parse(t.path);
      expect(r.ok && r.trick.tokens.map((x) => x.id), t.id).toEqual([t.id]);
      expect(trickGrade(tokenMoves(t))).toBeGreaterThanOrEqual(1);
    }
    for (const e of bookEntries(book, parser, 3)) {
      const r = parser.parse(e.path);
      expect(r.ok && r.trick.combo?.name, e.name).toBe(e.name);
      expect(e.points).toBe(r.ok ? r.trick.baseSum : -1);
    }
  });
});
