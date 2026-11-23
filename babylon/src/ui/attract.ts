// Attract screen overlay (attract_screen.dart): title, "TAPNI A JEĎ", trick of the day,
// TRICK BOOK and PRO buttons, style switch and the hidden 3 s long press (tuning).
// The demo rider behind it is the game layer's job.
import { STYLE_LABEL } from './palette';

export interface AttractActions {
  start(pro: boolean): void;
  trickBook(): void;
  nextStyle(): void;
  tuning(): void;
}

const el = <K extends keyof HTMLElementTagNameMap>(tag: K, cls: string, text?: string): HTMLElementTagNameMap[K] => {
  const e = document.createElement(tag);
  e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
};

export class AttractScreen {
  readonly root = el('div', 'screen');

  constructor(dailyName: string, a: AttractActions) {
    this.root.id = 'attract';
    const title = el('div', 'title');
    title.append(el('div', 'name', 'RATTLERAMP'), el('div', 'bar', 'U CHŘESTÝŠE'));
    const book = el('button', 'big-btn book-btn', 'TRICK BOOK');
    const pro = el('button', 'big-btn pro-btn', 'PRO ×1,5');
    const buttons = el('div', 'buttons');
    buttons.append(book, pro);
    const style = el('button', 'big-btn small style-btn', `STYL: ${STYLE_LABEL()}`);
    const corner = el('div', 'corner');
    this.root.append(title, el('div', 'tap', 'TAPNI A JEĎ'), el('div', 'daily', `TRIK DNE: ${dailyName.toUpperCase()} ×2`), buttons, style, corner);

    // A tap anywhere else starts a Beginner ride.
    this.root.addEventListener('click', (e) => {
      if (e.target === this.root || (e.target as HTMLElement).closest('.title, .tap, .daily')) a.start(false);
    });
    book.addEventListener('click', () => a.trickBook());
    pro.addEventListener('click', () => a.start(true));
    style.addEventListener('click', () => a.nextStyle());
    // Hidden: 3 s long press in the top-left corner (PIN comes in M4).
    let down = 0;
    corner.addEventListener('pointerdown', () => { down = performance.now(); });
    corner.addEventListener('pointercancel', () => { down = 0; });
    corner.addEventListener('pointerup', () => {
      if (down && performance.now() - down >= 3000) a.tuning();
      down = 0;
    });
  }
}
