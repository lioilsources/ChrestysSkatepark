import 'dart:ui' as ui;

import 'package:flutter/services.dart';

import '../core/avatar.dart' as av;

/// Decoded head and deck sprites, loaded once at startup. Missing entries
/// fall back to procedural drawing, so tests and a half-generated asset set
/// still run.
class AvatarSprites {
  final Map<String, ui.Image> heads;
  final Map<String, ui.Image> decks;

  const AvatarSprites({this.heads = const {}, this.decks = const {}});

  static const empty = AvatarSprites();

  static Future<AvatarSprites> load(AssetBundle bundle) async {
    Future<Map<String, ui.Image>> all(String dir, Iterable<String> ids) async {
      final out = <String, ui.Image>{};
      for (final id in ids) {
        try {
          final data = await bundle.load('assets/sprites/$dir/$id.png');
          final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
          out[id] = (await codec.getNextFrame()).image;
        } catch (_) {
          // Not generated yet — procedural fallback.
        }
      }
      return out;
    }

    return AvatarSprites(heads: await all('heads', av.presets.map((p) => p.id)), decks: await all('decks', av.decks));
  }
}
