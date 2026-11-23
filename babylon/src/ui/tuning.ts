// Feel-tuning knobs (tuning_panel.dart): style, timing window, touch latency, start
// speed, cue lead. Becomes the PIN-gated admin screen in M4. Values persist per browser.
import { defaultConfig } from '../rules/ride-config';
import { ART_STYLES, Palette } from './palette';
import { STYLES } from './generated/palette';
import type { ArtStyle } from './palette';
import type { Tuning } from './settings';

interface Knob { key: keyof Tuning; label: string; min: number; max: number; step: number; scale: number; fmt: (v: number) => string }

const KNOBS: Knob[] = [
  { key: 'windowScale', label: 'Šířka timing okna', min: 0.5, max: 2, step: 0.01, scale: 1, fmt: (v) => `×${v.toFixed(2)}` },
  { key: 'inputLatency', label: 'Latence dotyku', min: -50, max: 150, step: 1, scale: 1000, fmt: (v) => `${Math.round(v)} ms` },
  { key: 'startSpeed', label: 'Startovní rychlost', min: 0.1, max: 0.9, step: 0.01, scale: 1, fmt: (v) => v.toFixed(2) },
  { key: 'cueLead', label: 'Předstih kruhu', min: 0.5, max: 1.6, step: 0.01, scale: 1, fmt: (v) => `${v.toFixed(2)} s` },
];

export class TuningPanel {
  readonly root = document.createElement('div');

  constructor(tuning: Partial<Tuning>, onTuning: (t: Partial<Tuning>) => void, onStyle: (s: ArtStyle) => void, onClose: () => void) {
    this.root.id = 'tuning';
    const h = document.createElement('h2');
    h.textContent = 'LADĚNÍ (M0)';
    const styles = document.createElement('div');
    styles.className = 'styles';
    for (const s of ART_STYLES) {
      const b = document.createElement('button');
      b.className = 'big-btn small';
      b.textContent = STYLES[s].label;
      if (s === Palette.style) b.style.color = 'var(--good)';
      b.addEventListener('click', () => onStyle(s));
      styles.append(b);
    }
    this.root.append(h, styles);
    const defaults = defaultConfig();
    const cur: Partial<Tuning> = { ...tuning };
    for (const k of KNOBS) {
      const row = document.createElement('div');
      row.className = 'row';
      const label = document.createElement('label');
      label.textContent = k.label;
      const input = document.createElement('input');
      input.type = 'range';
      input.min = String(k.min);
      input.max = String(k.max);
      input.step = String(k.step);
      const v0 = (cur[k.key] ?? defaults[k.key]) * k.scale;
      input.value = String(Math.min(k.max, Math.max(k.min, v0)));
      const out = document.createElement('output');
      out.textContent = k.fmt(v0);
      input.addEventListener('input', () => {
        const v = Number(input.value);
        out.textContent = k.fmt(v);
        cur[k.key] = v / k.scale;
        onTuning({ ...cur });
      });
      row.append(label, input, out);
      this.root.append(row);
    }
    const note = document.createElement('div');
    note.className = 'note';
    note.textContent = 'Δ v pravém horním rohu jízdy = odchylka posledního puštění od hrany (− brzy, + pozdě).';
    const close = document.createElement('button');
    close.className = 'big-btn small';
    close.textContent = 'HOTOVO';
    close.style.marginTop = '12px';
    close.addEventListener('click', onClose);
    this.root.append(note, close);
  }
}
