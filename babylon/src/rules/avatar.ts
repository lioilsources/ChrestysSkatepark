// Port of rattleramp/lib/core/avatar.dart (1:1). Colours stay ARGB ints like in Dart;
// ui/ converts them with argbToCss.

export interface AvatarPreset {
  readonly id: string;
  readonly name: string;
  /** Skin of the procedural arms/hands, matched to the head sprite. */
  readonly skin: number;
  /** Default outfit index into OUTFITS and default deck id. */
  readonly outfit: number;
  readonly deck: string;
  /** The bar's mascot: gets a rattle tail. */
  readonly mascot: boolean;
}

export interface Outfit { readonly shirt: number; readonly pants: number; readonly shoes: number }

const preset = (id: string, name: string, skin: number, outfit: number, deck: string, mascot = false): AvatarPreset =>
  ({ id, name, skin, outfit, deck, mascot });

export const PRESETS: readonly AvatarPreset[] = [
  preset('chrestys', 'Chřestýš', 0xff5cb85c, 5, 'snake', true),
  preset('punk', 'Punk', 0xfff6d3b3, 0, 'checker'),
  preset('beanie', 'Kulich', 0xfff9d9be, 1, 'waves'),
  preset('dreads', 'Dready', 0xff6b3e26, 2, 'flames'),
  preset('helmet', 'Helma', 0xfff7d7c4, 3, 'galaxy'),
  preset('oldschool', 'Old School', 0xffe9b48a, 4, 'pizza'),
  preset('kid', 'Prcek', 0xfff8d5b5, 1, 'flames'),
  preset('afro', 'Afro', 0xff8d5524, 3, 'galaxy'),
];

const outfit = (shirt: number, pants: number, shoes: number): Outfit => ({ shirt, pants, shoes });

export const OUTFITS: readonly Outfit[] = [
  outfit(0xff2b2d42, 0xff4a6fa5, 0xffe63946), // black hoodie, jeans
  outfit(0xffe63946, 0xff1d3557, 0xfff1faee), // red tee, navy pants
  outfit(0xffffb703, 0xff3d405b, 0xff222222), // yellow, charcoal
  outfit(0xff8ecae6, 0xfff4a3c0, 0xffffffff), // sky blue, pink
  outfit(0xff2a9d8f, 0xff6d4c41, 0xfff4a261), // teal, brown
  outfit(0xff111111, 0xff2e7d32, 0xffffd600), // mascot: black tee, green
];

export const DECKS: readonly string[] = ['snake', 'flames', 'checker', 'galaxy', 'waves', 'pizza'];

export interface Avatar { readonly preset: AvatarPreset; readonly outfitIndex: number; readonly deck: string }

export const avatarOf = (p: AvatarPreset): Avatar => ({ preset: p, outfitIndex: p.outfit, deck: p.deck });
export const avatarOutfit = (a: Avatar): Outfit => OUTFITS[a.outfitIndex];
export const initialAvatar = (): Avatar => avatarOf(PRESETS[0]);
