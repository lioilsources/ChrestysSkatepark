// Trick book (trick_book_screen.dart): every token and named combo, with an animated
// finger drawing its pattern.
import { tokenMoves, trickGrade, type TrickBook, type TrickToken } from '../rules/trick-defs';
import type { TrickParser } from '../rules/trick-parser';
import { drawPattern } from './pattern';

interface Entry { name: string; path: readonly number[]; points: number; grade: number; note: string | null }

const TABS = ['GRABY', 'FLIPY', 'SPINY', 'KOMBA'];
const LOOP_MS = 1800;

const el = <K extends keyof HTMLElementTagNameMap>(tag: K, cls: string, text?: string): HTMLElementTagNameMap[K] => {
  const e = document.createElement(tag);
  e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
};

export function bookEntries(book: TrickBook, parser: TrickParser, tab: number): Entry[] {
  const token = (t: TrickToken, note: string | null = null): Entry =>
    ({ name: t.name, path: t.path, points: t.base, grade: trickGrade(tokenMoves(t)), note });
  switch (tab) {
    case 0: return book.grabs.map((t) => token(t));
    case 1: return book.flips.map((t) => token(t));
    case 2: return book.spins.map((t) => token(t, 'začni kdekoli na okraji'));
    default: {
      const out: Entry[] = [];
      for (const c of book.combos) {
        const p = book.comboPath(c);
        if (p === null) continue;
        const r = parser.parse(p);
        out.push({
          name: c.name, path: p, points: r.ok ? r.trick.baseSum : 0, grade: trickGrade(p.length - 1),
          note: c.tokens.map((id) => book.token(id)?.name ?? id).join(' + '),
        });
      }
      return out;
    }
  }
}

export class TrickBookScreen {
  readonly root = el('div', 'screen');
  private readonly grid = el('div', 'grid');
  private readonly tabs: HTMLElement[] = [];
  private cards: { canvas: HTMLCanvasElement; path: readonly number[] }[] = [];
  private raf = 0;
  private readonly t0 = performance.now();

  constructor(private readonly book: TrickBook, private readonly parser: TrickParser, onClose: () => void) {
    this.root.id = 'trickbook';
    const top = el('div', 'top');
    const tabs = el('div', 'tabs');
    tabs.append(el('h1', '', 'TRICK BOOK'));
    TABS.forEach((t, i) => {
      const b = el('button', 'tab', t);
      b.addEventListener('click', () => this.show(i));
      tabs.append(b);
      this.tabs.push(b);
    });
    const close = el('button', 'close', '✕');
    close.setAttribute('aria-label', 'Zavřít');
    close.addEventListener('click', onClose);
    top.append(tabs, close);
    const help = el('div', 'help',
      'Po obvodu = spin (po směru hodin FS, proti BS) · přes střed = grab · kosočtverec = flip. '
      + 'Spoj triky jedním tahem – další začíná tam, kde předchozí skončil. Pusť prst, když kruh dosedne na hranu.');
    this.root.append(top, help, this.grid);
    this.show(0);
    this.raf = requestAnimationFrame(this.tick);
  }

  dispose(): void {
    cancelAnimationFrame(this.raf);
    this.root.remove();
  }

  private show(tab: number): void {
    this.tabs.forEach((b, i) => b.classList.toggle('sel', i === tab));
    this.cards = [];
    this.grid.replaceChildren(...bookEntries(this.book, this.parser, tab).map((e) => {
      const card = el('div', 'card');
      const canvas = el('canvas', '');
      card.append(canvas, el('div', 'n', e.name), el('div', 'p', `${e.points} b  ${'●'.repeat(e.grade)}${'○'.repeat(5 - e.grade)}`));
      if (e.note) card.append(el('div', 'note', e.note));
      this.cards.push({ canvas, path: e.path });
      return card;
    }));
    this.grid.scrollTop = 0;
  }

  private readonly tick = (): void => {
    const progress = Math.min(1, (((performance.now() - this.t0) % LOOP_MS) / LOOP_MS) * 1.25);
    const dpr = devicePixelRatio || 1;
    for (const c of this.cards) {
      const w = c.canvas.clientWidth;
      if (w < 1) continue;
      const px = Math.round(w * dpr);
      if (c.canvas.width !== px) c.canvas.width = c.canvas.height = px;
      const g = c.canvas.getContext('2d');
      if (!g) continue;
      g.setTransform(dpr, 0, 0, dpr, 0, 0);
      g.clearRect(0, 0, w, w);
      drawPattern(g, w, w, c.path, { progress });
    }
    this.raf = requestAnimationFrame(this.tick);
  };
}
