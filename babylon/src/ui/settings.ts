// Session settings (app.dart Settings): art style, last avatar and the tuning knobs.
// Flutter keeps them in memory; the web remembers them in localStorage per browser.
import { DECKS, OUTFITS, PRESETS, initialAvatar, type Avatar } from '../rules/avatar';
import type { RideConfig } from '../rules/ride-config';
import { isArtStyle, type ArtStyle } from './palette';

const KEY = 'rattleramp.settings.v1';

/** Only the knobs of the tuning panel (RideConfig.copyWith). */
export type Tuning = Pick<RideConfig, 'startSpeed' | 'windowScale' | 'inputLatency' | 'cueLead'>;

export interface Settings {
  style: ArtStyle;
  avatar: Avatar;
  tuning: Partial<Tuning>;
}

interface Stored { style?: string; preset?: string; outfit?: number; deck?: string; tuning?: Partial<Record<keyof Tuning, number>> }

export function loadSettings(): Settings {
  const out: Settings = { style: 'neon', avatar: initialAvatar(), tuning: {} };
  let s: Stored = {};
  try {
    s = JSON.parse(localStorage.getItem(KEY) ?? '{}') as Stored;
  } catch {
    return out;
  }
  if (isArtStyle(s.style)) out.style = s.style;
  const preset = PRESETS.find((p) => p.id === s.preset);
  if (preset) {
    out.avatar = {
      preset,
      outfitIndex: typeof s.outfit === 'number' && s.outfit >= 0 && s.outfit < OUTFITS.length ? s.outfit : preset.outfit,
      deck: typeof s.deck === 'string' && DECKS.includes(s.deck) ? s.deck : preset.deck,
    };
  }
  for (const k of ['startSpeed', 'windowScale', 'inputLatency', 'cueLead'] as const) {
    const v = s.tuning?.[k];
    if (typeof v === 'number' && Number.isFinite(v)) out.tuning[k] = v;
  }
  return out;
}

export function saveSettings(st: Settings): void {
  const s: Stored = { style: st.style, preset: st.avatar.preset.id, outfit: st.avatar.outfitIndex, deck: st.avatar.deck, tuning: st.tuning };
  try {
    localStorage.setItem(KEY, JSON.stringify(s));
  } catch {
    // Private mode / blocked storage: settings just don't persist.
  }
}
