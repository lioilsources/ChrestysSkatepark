import 'package:flutter/material.dart';

import '../core/avatar.dart';
import '../core/ride_sim.dart';
import '../game/avatar_sprites.dart';
import '../game/skater_component.dart';
import 'theme.dart';

/// Quick avatar pick between attract and the ride: tap a character and go.
/// A 5 s countdown starts the ride with the current pick, so a guest who
/// just wants to skate loses nothing; every tap on an option restarts it.
class AvatarScreen extends StatefulWidget {
  final Avatar initial;
  final AvatarSprites sprites;
  final void Function(Avatar avatar) onGo;
  final VoidCallback onBack;

  const AvatarScreen({
    super.key,
    required this.initial,
    required this.sprites,
    required this.onGo,
    required this.onBack,
  });

  static const Duration countdown = Duration(seconds: 5);

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> with SingleTickerProviderStateMixin {
  late Avatar avatar = widget.initial;
  late final AnimationController timer = AnimationController(vsync: this, duration: AvatarScreen.countdown)
    ..addStatusListener((s) {
      if (s == AnimationStatus.completed) _go();
    })
    ..forward();
  bool _gone = false;

  void _pick(Avatar a) {
    setState(() => avatar = a);
    timer.forward(from: 0);
  }

  void _go() {
    if (_gone) return;
    _gone = true;
    widget.onGo(avatar);
  }

  @override
  void dispose() {
    timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Live preview of the current pick.
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(iconSize: 36, onPressed: widget.onBack, icon: const Icon(Icons.arrow_back)),
                        Expanded(
                          child: Text(
                            avatar.preset.name.toUpperCase(),
                            style: hudStyle.copyWith(fontSize: 30, color: Palette.rampEdge),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: CustomPaint(painter: _PreviewPainter(avatar, widget.sprites), size: Size.infinite),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 4,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        children: [
                          for (final p in presets)
                            _HeadCard(
                              key: ValueKey('preset-${p.id}'),
                              preset: p,
                              selected: p.id == avatar.preset.id,
                              onTap: () => _pick(Avatar.of(p)),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 48,
                      child: Row(
                        children: [
                          for (var i = 0; i < outfits.length; i++)
                            Expanded(
                              child: _Swatch(
                                outfit: outfits[i],
                                selected: i == avatar.outfitIndex,
                                onTap: () => _pick(avatar.copyWith(outfitIndex: i)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 44,
                      child: Row(
                        children: [
                          for (final d in decks)
                            Expanded(
                              child: _DeckChip(
                                id: d,
                                selected: d == avatar.deck,
                                onTap: () => _pick(avatar.copyWith(deck: d)),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    _GoButton(progress: timer, onTap: _go),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewPainter extends CustomPainter {
  final Avatar avatar;
  final AvatarSprites sprites;
  _PreviewPainter(this.avatar, this.sprites);

  @override
  void paint(Canvas canvas, Size size) {
    // About 2.4 m of skater-space fits the height.
    final k = size.height / 2.4;
    canvas.translate(size.width / 2, size.height * 0.88);
    canvas.scale(k, -k);
    paintSkater(canvas, const SkaterPose(x: 0, y: 0, angle: 0, facing: 1, crouch: 0.2), avatar, sprites);
  }

  @override
  bool shouldRepaint(_PreviewPainter old) => old.avatar != avatar;
}

class _HeadCard extends StatelessWidget {
  final AvatarPreset preset;
  final bool selected;
  final VoidCallback onTap;
  const _HeadCard({super.key, required this.preset, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Palette.rampFill,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? Palette.good : Colors.transparent, width: 4),
        ),
        padding: const EdgeInsets.all(6),
        child: Image.asset(
          'assets/sprites/heads/${preset.id}.png',
          fit: BoxFit.contain,
          errorBuilder: (context, _, _) => Center(child: Text(preset.name, style: hudStyle.copyWith(fontSize: 14))),
        ),
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  final Outfit outfit;
  final bool selected;
  final VoidCallback onTap;
  const _Swatch({required this.outfit, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Palette.good : Palette.dim, width: selected ? 4 : 1),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(outfit.shirt), Color(outfit.shirt), Color(outfit.pants), Color(outfit.pants)],
            stops: const [0, 0.55, 0.55, 1],
          ),
        ),
      ),
    );
  }
}

class _DeckChip extends StatelessWidget {
  final String id;
  final bool selected;
  final VoidCallback onTap;
  const _DeckChip({required this.id, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: selected ? Palette.good : Palette.dim, width: selected ? 4 : 1),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/sprites/decks/$id.png',
          fit: BoxFit.cover,
          errorBuilder: (context, _, _) => ColoredBox(color: Palette.board),
        ),
      ),
    );
  }
}

class _GoButton extends StatelessWidget {
  final Animation<double> progress;
  final VoidCallback onTap;
  const _GoButton({required this.progress, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedBuilder(
        animation: progress,
        builder: (context, _) {
          final left = (AvatarScreen.countdown.inMilliseconds * (1 - progress.value) / 1000).ceil();
          return Container(
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Palette.coping, width: 3),
              gradient: LinearGradient(
                colors: [Palette.coping.withValues(alpha: 0.45), Palette.night.withValues(alpha: 0.6)],
                stops: [progress.value, progress.value],
              ),
            ),
            alignment: Alignment.center,
            child: Text('JEĎ!  $left', style: hudStyle.copyWith(fontSize: 28, color: Palette.coping)),
          );
        },
      ),
    );
  }
}
