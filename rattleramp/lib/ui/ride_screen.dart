import 'dart:async';
import 'dart:math' as math;

import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/ride_sim.dart';
import '../core/scoring.dart';
import '../core/trick_defs.dart';
import '../game/avatar_sprites.dart';
import '../game/rattle_game.dart';
import 'app.dart';
import 'pattern_painter.dart';
import 'stat_card.dart';
import 'swipe_grid.dart';
import 'theme.dart';

class RideScreen extends StatefulWidget {
  final TrickBook book;
  final AvatarSprites sprites;
  final Settings settings;
  final bool proMode;
  final TrickToken daily;
  final VoidCallback onDone;

  const RideScreen({
    super.key,
    required this.book,
    required this.sprites,
    required this.settings,
    required this.proMode,
    required this.daily,
    required this.onDone,
  });

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _Popup {
  final String big;
  final String? small;
  final Color color;
  final int id;
  const _Popup(this.big, this.small, this.color, this.id);
}

class _RideScreenState extends State<RideScreen> {
  late final RattleGame game;
  final math.Random _rng = math.Random();

  int score = 0;
  int streak = 0;
  double speed = 0;
  _Popup? popup;
  int _popupId = 0;
  double? lastDeltaMs;
  List<({String name, List<int> path})> hints = [];
  RideSim? finished;
  Timer? _doneTimer;

  @override
  void initState() {
    super.initState();
    game =
        RattleGame(
            book: widget.book,
            config: widget.settings.config,
            avatar: widget.settings.avatar,
            sprites: widget.sprites,
          )
          ..startRide(proMode: widget.proMode, dailyTokenId: widget.daily.id)
          ..onEvent = _onEvent
          ..onFinished = _onFinished;
    speed = game.sim.speed;
    _refreshHints();
  }

  @override
  void dispose() {
    _doneTimer?.cancel();
    super.dispose();
  }

  void _show(String big, {String? small, Color? color}) {
    popup = _Popup(big, small, color ?? Palette.skater, ++_popupId);
  }

  void _onEvent(RideEvent e) {
    setState(() {
      switch (e.type) {
        case RideEventType.judged:
          lastDeltaMs = e.delta! * 1000;
          if (e.trick == null) {
            _show('ŠPATNÝ TRIK', color: Palette.miss);
          } else {
            _show(_timingLabel(e.timing!), small: e.trick!.name, color: _timingColor(e.timing!));
          }
        case RideEventType.tooEarly:
          _show('MOC BRZY', small: 'počkej na kruh', color: Palette.dim);
        case RideEventType.landed:
          score = game.sim.stats.score;
          streak = game.sim.stats.streak;
          _show('+${e.score!.total}', small: e.trick!.name, color: _timingColor(e.timing!));
          _refreshHints();
        case RideEventType.emptyAir:
          _show('BEZ TRIKU', small: 'ztrácíš rychlost', color: Palette.dim);
        case RideEventType.bail:
          streak = 0;
          _show(
            'BAIL!',
            small: switch (e.bailReason!) {
              BailReason.timingMiss => 'špatné načasování',
              BailReason.badPattern => 'neznámý trik',
              BailReason.trickTooLong => 'trik se nevešel do airu',
            },
            color: Palette.miss,
          );
        case RideEventType.outOfSpeed:
          _show('DOŠLA RYCHLOST', color: Palette.dim);
        case RideEventType.finished:
          break;
      }
      speed = game.sim.speed;
    });
  }

  void _onFinished(RideSim sim) {
    setState(() => finished = sim);
    _doneTimer = Timer(const Duration(seconds: 10), widget.onDone);
  }

  /// Three tricks that fit the current speed, so copying a hint can't bail.
  void _refreshHints() {
    if (widget.proMode) return;
    final sim = game.sim;
    final parser = game.parser;
    final pool = <({String name, List<int> path})>[];
    for (final t in widget.book.allTokens) {
      final trick = parser.parse(t.path).trick!;
      if (sim.speedNeeded(trick) <= sim.speed) pool.add((name: t.name, path: t.path));
    }
    for (final c in widget.book.combos) {
      final path = widget.book.comboPath(c);
      if (path == null) continue;
      if (sim.speedNeeded(parser.parse(path).trick!) <= sim.speed) pool.add((name: c.name, path: path));
    }
    pool.shuffle(_rng);
    hints = pool.take(3).toList();
  }

  static String _timingLabel(Timing t) => switch (t) {
    Timing.perfect => 'PERFECT',
    Timing.good => 'GOOD',
    Timing.late => 'LATE',
    Timing.miss => 'MISS',
  };

  static Color _timingColor(Timing t) => switch (t) {
    Timing.perfect => Palette.perfect,
    Timing.good => Palette.good,
    Timing.late => Palette.late,
    Timing.miss => Palette.miss,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;
          final h = c.maxHeight;
          final gridSize = math.max(h * 0.45, 220.0);
          const top = 64.0;
          final hintH = widget.proMode ? 16.0 : 112.0;
          final world = Rect.fromLTWH(12, top, w - gridSize - 36, h - top - hintH);
          game.setWorldRect(world);

          return Stack(
            children: [
              Positioned.fill(child: GameWidget(game: game)),
              Positioned(
                left: 20,
                top: 12,
                child: _Hud(score: score, streak: streak, speed: speed, pro: widget.proMode),
              ),
              Positioned(
                right: 20,
                top: 14,
                child: Text(
                  'TRIK DNE: ${widget.daily.name} ×2${lastDeltaMs == null ? '' : '   Δ ${lastDeltaMs!.round()} ms'}',
                  style: hudStyle.copyWith(fontSize: 14, color: Palette.dim),
                ),
              ),
              if (popup != null)
                Positioned(
                  left: world.left,
                  width: world.width,
                  top: top + 8,
                  child: IgnorePointer(
                    child: _PopupView(key: ValueKey(popup!.id), popup: popup!),
                  ),
                ),
              if (!widget.proMode)
                Positioned(
                  left: 20,
                  bottom: 12,
                  height: hintH - 20,
                  right: gridSize + 40,
                  child: _HintStrip(hints: hints),
                ),
              Positioned(
                right: 16,
                bottom: 16,
                width: gridSize,
                height: gridSize,
                child: SwipeGrid(onRelease: game.release),
              ),
              if (finished != null)
                Positioned.fill(
                  child: StatCard(stats: finished!.stats, bailed: finished!.bailReason != null, onDone: widget.onDone),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _Hud extends StatelessWidget {
  final int score;
  final int streak;
  final double speed;
  final bool pro;
  const _Hud({required this.score, required this.streak, required this.speed, required this.pro});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('$score', style: hudStyle.copyWith(fontSize: 34)),
        const SizedBox(width: 16),
        if (streak > 0)
          Text(
            'COMBO ×${(1 + 0.1 * streak).toStringAsFixed(1)}',
            style: hudStyle.copyWith(fontSize: 18, color: Palette.good),
          ),
        const SizedBox(width: 16),
        SizedBox(
          width: 120,
          height: 12,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: speed,
              backgroundColor: Palette.rampFill,
              color: Color.lerp(Palette.rampEdge, Palette.coping, speed),
            ),
          ),
        ),
        if (pro) ...[
          const SizedBox(width: 16),
          Text('PRO', style: hudStyle.copyWith(fontSize: 18, color: Palette.coping)),
        ],
      ],
    );
  }
}

class _PopupView extends StatefulWidget {
  final _Popup popup;
  const _PopupView({super.key, required this.popup});

  @override
  State<_PopupView> createState() => _PopupViewState();
}

class _PopupViewState extends State<_PopupView> with SingleTickerProviderStateMixin {
  late final AnimationController a = AnimationController(vsync: this, duration: const Duration(milliseconds: 1300))
    ..forward();

  @override
  void dispose() {
    a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: a,
      builder: (context, _) {
        final t = a.value;
        final scale = 1 + 0.25 * (1 - Curves.easeOutBack.transform((t * 4).clamp(0, 1)));
        final opacity = t < 0.75 ? 1.0 : (1 - (t - 0.75) / 0.25);
        return Opacity(
          opacity: opacity.clamp(0, 1),
          child: Transform.scale(
            scale: scale,
            child: Column(
              children: [
                Text(widget.popup.big, style: hudStyle.copyWith(fontSize: 44, color: widget.popup.color)),
                if (widget.popup.small != null) Text(widget.popup.small!, style: hudStyle.copyWith(fontSize: 24)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _HintStrip extends StatelessWidget {
  final List<({String name, List<int> path})> hints;
  const _HintStrip({required this.hints});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final h in hints)
          Expanded(
            child: Row(
              children: [
                AspectRatio(aspectRatio: 1, child: CustomPaint(painter: PatternPainter(h.path))),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    h.name,
                    style: hudStyle.copyWith(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
