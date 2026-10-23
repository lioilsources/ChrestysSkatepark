/// Avatar presets and the quick customisation (≤ 5 s): pick a character,
/// optionally an outfit colour and a deck graphic. Pure Dart; colours are
/// ARGB ints so the core stays Flutter-free.
library;

class AvatarPreset {
  final String id;
  final String name;

  /// Skin of the procedural arms/hands, matched to the head sprite.
  final int skin;

  /// Default outfit index into [outfits] and default deck id.
  final int outfit;
  final String deck;

  /// The bar's mascot: gets a rattle tail.
  final bool mascot;

  const AvatarPreset({
    required this.id,
    required this.name,
    required this.skin,
    required this.outfit,
    required this.deck,
    this.mascot = false,
  });
}

class Outfit {
  final int shirt;
  final int pants;
  final int shoes;
  const Outfit(this.shirt, this.pants, this.shoes);
}

const List<AvatarPreset> presets = [
  AvatarPreset(id: 'chrestys', name: 'Chřestýš', skin: 0xFF5CB85C, outfit: 5, deck: 'snake', mascot: true),
  AvatarPreset(id: 'punk', name: 'Punk', skin: 0xFFF6D3B3, outfit: 0, deck: 'checker'),
  AvatarPreset(id: 'beanie', name: 'Kulich', skin: 0xFFF9D9BE, outfit: 1, deck: 'waves'),
  AvatarPreset(id: 'dreads', name: 'Dready', skin: 0xFF6B3E26, outfit: 2, deck: 'flames'),
  AvatarPreset(id: 'helmet', name: 'Helma', skin: 0xFFF7D7C4, outfit: 3, deck: 'galaxy'),
  AvatarPreset(id: 'oldschool', name: 'Old School', skin: 0xFFE9B48A, outfit: 4, deck: 'pizza'),
  AvatarPreset(id: 'kid', name: 'Prcek', skin: 0xFFF8D5B5, outfit: 1, deck: 'flames'),
  AvatarPreset(id: 'afro', name: 'Afro', skin: 0xFF8D5524, outfit: 3, deck: 'galaxy'),
];

const List<Outfit> outfits = [
  Outfit(0xFF2B2D42, 0xFF4A6FA5, 0xFFE63946), // black hoodie, jeans
  Outfit(0xFFE63946, 0xFF1D3557, 0xFFF1FAEE), // red tee, navy pants
  Outfit(0xFFFFB703, 0xFF3D405B, 0xFF222222), // yellow, charcoal
  Outfit(0xFF8ECAE6, 0xFFF4A3C0, 0xFFFFFFFF), // sky blue, pink
  Outfit(0xFF2A9D8F, 0xFF6D4C41, 0xFFF4A261), // teal, brown
  Outfit(0xFF111111, 0xFF2E7D32, 0xFFFFD600), // mascot: black tee, green
];

const List<String> decks = ['snake', 'flames', 'checker', 'galaxy', 'waves', 'pizza'];

class Avatar {
  final AvatarPreset preset;
  final int outfitIndex;
  final String deck;

  const Avatar(this.preset, this.outfitIndex, this.deck);

  factory Avatar.of(AvatarPreset p) => Avatar(p, p.outfit, p.deck);

  Outfit get outfit => outfits[outfitIndex];

  Avatar copyWith({AvatarPreset? preset, int? outfitIndex, String? deck}) =>
      Avatar(preset ?? this.preset, outfitIndex ?? this.outfitIndex, deck ?? this.deck);

  static Avatar get initial => Avatar.of(presets.first);
}
