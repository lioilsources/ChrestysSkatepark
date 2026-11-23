// Quick avatar pick between attract and the ride (avatar_screen.dart): tap a character
// and go. A 5 s countdown starts the ride with the current pick; every tap on an option
// restarts it.
import { avatarOf, DECKS, OUTFITS, PRESETS, type Avatar } from '../rules/avatar';
import { argbToCss, paintSkater } from './skater-paint';
import { spriteUrl, type AvatarSprites } from './sprites';
import { pal, withAlpha } from './palette';

export const COUNTDOWN_MS = 5000;

const el = <K extends keyof HTMLElementTagNameMap>(tag: K, cls: string, text?: string): HTMLElementTagNameMap[K] => {
  const e = document.createElement(tag);
  e.className = cls;
  if (text !== undefined) e.textContent = text;
  return e;
};

export class AvatarPicker {
  readonly root = el('div', 'screen');
  private readonly preview = el('canvas', 'preview');
  private readonly nameEl = el('div', 'name');
  private readonly go = el('button', 'go');
  private readonly heads: HTMLElement[] = [];
  private readonly swatches: HTMLElement[] = [];
  private readonly decks: HTMLElement[] = [];
  private t0 = performance.now();
  private raf = 0;
  private gone = false;
  private drawnFor = '';

  constructor(
    private avatar: Avatar,
    private sprites: AvatarSprites,
    private readonly onGo: (a: Avatar) => void,
    onBack: () => void,
  ) {
    this.root.id = 'avatar';
    const left = el('div', 'left');
    const headRow = el('div', 'head-row');
    const back = el('button', 'back', '←');
    back.setAttribute('aria-label', 'Zpět');
    back.addEventListener('click', onBack);
    headRow.append(back, this.nameEl);
    left.append(headRow, this.preview);

    const right = el('div', 'right');
    const grid = el('div', 'heads');
    for (const p of PRESETS) {
      const card = el('button', 'head');
      const img = el('img', '');
      img.alt = p.name;
      img.src = spriteUrl('heads', p.id);
      img.onerror = () => { img.replaceWith(el('span', '', p.name)); };
      card.append(img);
      card.addEventListener('click', () => this.pick(avatarOf(p)));
      grid.append(card);
      this.heads.push(card);
    }
    const sw = el('div', 'swatches');
    OUTFITS.forEach((o, i) => {
      const b = el('button', 'swatch');
      b.style.background = `linear-gradient(${argbToCss(o.shirt)} 0 55%, ${argbToCss(o.pants)} 55% 100%)`;
      b.addEventListener('click', () => this.pick({ ...this.avatar, outfitIndex: i }));
      sw.append(b);
      this.swatches.push(b);
    });
    const dk = el('div', 'decks');
    for (const d of DECKS) {
      const b = el('button', 'deck');
      b.style.backgroundImage = `url("${spriteUrl('decks', d)}")`;
      b.addEventListener('click', () => this.pick({ ...this.avatar, deck: d }));
      dk.append(b);
      this.decks.push(b);
    }
    this.go.addEventListener('click', () => this.finish());
    right.append(grid, sw, dk, this.go);
    this.root.append(left, right);
    this.refresh();
    this.raf = requestAnimationFrame(this.tick);
  }

  setSprites(s: AvatarSprites): void {
    this.sprites = s;
    this.drawPreview();
  }

  /** Space / Enter = JEĎ. */
  finish(): void {
    if (this.gone) return;
    this.gone = true;
    cancelAnimationFrame(this.raf);
    this.onGo(this.avatar);
  }

  dispose(): void {
    this.gone = true;
    cancelAnimationFrame(this.raf);
    this.root.remove();
  }

  private pick(a: Avatar): void {
    this.avatar = a;
    this.t0 = performance.now();
    this.refresh();
  }

  private refresh(): void {
    const a = this.avatar;
    this.nameEl.textContent = a.preset.name.toUpperCase();
    PRESETS.forEach((p, i) => this.heads[i].classList.toggle('sel', p.id === a.preset.id));
    this.swatches.forEach((b, i) => b.classList.toggle('sel', i === a.outfitIndex));
    DECKS.forEach((d, i) => this.decks[i].classList.toggle('sel', d === a.deck));
    this.drawPreview();
  }

  private drawPreview(): void {
    const c = this.preview;
    const dpr = devicePixelRatio || 1;
    const w = c.clientWidth, h = c.clientHeight;
    this.drawnFor = `${w}x${h}`;
    if (w < 1 || h < 1) return;
    c.width = Math.round(w * dpr);
    c.height = Math.round(h * dpr);
    const g = c.getContext('2d');
    if (!g) return;
    // About 2.4 m of skater-space fits the height.
    const k = (h / 2.4) * dpr;
    g.setTransform(k, 0, 0, -k, (w / 2) * dpr, h * 0.88 * dpr);
    paintSkater(g, {
      x: 0, y: 0, angle: 0, facing: 1, crouch: 0.2,
      roll: 0, shove: 0, tumble: 0, flip: 0, grab: 0, grabLook: { hand: 'front', at: 0, style: 'tuck', tilt: 0 }, bail: 0,
    }, this.avatar, this.sprites);
  }

  private readonly tick = (): void => {
    if (this.gone) return;
    const k = Math.min(1, (performance.now() - this.t0) / COUNTDOWN_MS);
    const left = Math.ceil((COUNTDOWN_MS * (1 - k)) / 1000);
    this.go.textContent = `JEĎ!  ${left}`;
    const p = `${(k * 100).toFixed(1)}%`;
    this.go.style.background = `linear-gradient(90deg, ${withAlpha(pal().coping, 0.45)} ${p}, ${withAlpha(pal().night, 0.6)} ${p})`;
    if (this.drawnFor !== `${this.preview.clientWidth}x${this.preview.clientHeight}`) this.drawPreview();
    if (k >= 1) this.finish();
    else this.raf = requestAnimationFrame(this.tick);
  };
}
