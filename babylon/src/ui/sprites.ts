// Head and deck sprites (avatar_sprites.dart), loaded after the first frame.
// Missing entries fall back to procedural drawing, like in Flutter.
import { DECKS, PRESETS } from '../rules/avatar';

export interface AvatarSprites {
  heads: Map<string, HTMLImageElement>;
  decks: Map<string, HTMLImageElement>;
}

export const EMPTY_SPRITES: AvatarSprites = { heads: new Map(), decks: new Map() };

export const spriteUrl = (dir: 'heads' | 'decks', id: string): string => `${import.meta.env.BASE_URL}sprites/${dir}/${id}.png`;

function load(url: string): Promise<HTMLImageElement | null> {
  return new Promise((resolve) => {
    const img = new Image();
    img.decoding = 'async';
    img.onload = () => resolve(img);
    img.onerror = () => resolve(null);
    img.src = url;
  });
}

export async function loadSprites(): Promise<AvatarSprites> {
  const all = async (dir: 'heads' | 'decks', ids: readonly string[]): Promise<Map<string, HTMLImageElement>> => {
    const imgs = await Promise.all(ids.map((id) => load(spriteUrl(dir, id))));
    const out = new Map<string, HTMLImageElement>();
    ids.forEach((id, i) => { const im = imgs[i]; if (im) out.set(id, im); });
    return out;
  };
  const [heads, decks] = await Promise.all([all('heads', PRESETS.map((p) => p.id)), all('decks', DECKS)]);
  return { heads, decks };
}
