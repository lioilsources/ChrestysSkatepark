import 'dart:async';

import 'package:flutter/material.dart';

import '../core/ride_config.dart';
import '../core/trick_defs.dart';
import 'attract_screen.dart';
import 'ride_screen.dart';
import 'theme.dart';
import 'trick_book_screen.dart';

enum AppScreen { attract, ride, trickBook }

/// Session-wide settings. In-memory for now; persisted + PIN-gated in M4.
class Settings extends ChangeNotifier {
  RideConfig _config = const RideConfig();
  RideConfig get config => _config;
  set config(RideConfig c) {
    _config = c;
    notifyListeners();
  }
}

class RattleApp extends StatelessWidget {
  final TrickBook book;
  const RattleApp({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RattleRamp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Palette.night,
        colorScheme: const ColorScheme.dark(primary: Palette.rampEdge, secondary: Palette.coping),
      ),
      home: _Shell(book: book),
    );
  }
}

class _Shell extends StatefulWidget {
  final TrickBook book;
  const _Shell({required this.book});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  final Settings settings = Settings();
  AppScreen screen = AppScreen.attract;
  bool proMode = false;
  Timer? _idle;

  /// Menus fall back to attract after this long without a touch.
  static const Duration idleTimeout = Duration(seconds: 20);

  void _go(AppScreen s, {bool? pro}) {
    setState(() {
      screen = s;
      if (pro != null) proMode = pro;
    });
    _kickIdle();
  }

  void _kickIdle() {
    _idle?.cancel();
    if (screen == AppScreen.trickBook) {
      _idle = Timer(idleTimeout, () => _go(AppScreen.attract));
    }
  }

  @override
  void dispose() {
    _idle?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final daily = dailyToken(widget.book, DateTime.now());
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: (_) => _kickIdle(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: switch (screen) {
          AppScreen.attract => AttractScreen(
            key: const ValueKey('attract'),
            book: widget.book,
            settings: settings,
            daily: daily,
            onStart: (pro) => _go(AppScreen.ride, pro: pro),
            onTrickBook: () => _go(AppScreen.trickBook),
          ),
          AppScreen.ride => RideScreen(
            key: const ValueKey('ride'),
            book: widget.book,
            settings: settings,
            proMode: proMode,
            daily: daily,
            onDone: () => _go(AppScreen.attract),
          ),
          AppScreen.trickBook => TrickBookScreen(
            key: const ValueKey('book'),
            book: widget.book,
            onClose: () => _go(AppScreen.attract),
          ),
        },
      ),
    );
  }
}
