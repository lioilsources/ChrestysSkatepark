import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/trick_defs.dart';
import 'game/avatar_sprites.dart';
import 'ui/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  final book = TrickBook.fromJson(await rootBundle.loadString('assets/tricks.json'));
  final sprites = await AvatarSprites.load(rootBundle);
  runApp(RattleApp(book: book, sprites: sprites));
}
