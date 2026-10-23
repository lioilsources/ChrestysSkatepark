import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../core/trick_defs.dart';
import '../game/avatar_sprites.dart';
import '../game/rattle_game.dart';
import 'app.dart';
import 'theme.dart';
import 'tuning_panel.dart';

/// Idle loop: the demo rider skates behind the title. A tap anywhere starts
/// a Beginner ride; the Pro button starts Pro.
class AttractScreen extends StatefulWidget {
  final TrickBook book;
  final AvatarSprites sprites;
  final Settings settings;
  final TrickToken daily;
  final void Function(bool pro) onStart;
  final VoidCallback onTrickBook;

  const AttractScreen({
    super.key,
    required this.book,
    required this.sprites,
    required this.settings,
    required this.daily,
    required this.onStart,
    required this.onTrickBook,
  });

  @override
  State<AttractScreen> createState() => _AttractScreenState();
}

class _AttractScreenState extends State<AttractScreen> with SingleTickerProviderStateMixin {
  late final RattleGame game = RattleGame(
    book: widget.book,
    config: widget.settings.config,
    autopilot: true,
    sprites: widget.sprites,
  );
  late final AnimationController pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
    ..repeat(reverse: true);

  @override
  void dispose() {
    pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, c) {
          game.setWorldRect(Rect.fromLTWH(0, c.maxHeight * 0.12, c.maxWidth, c.maxHeight * 0.88));
          return Stack(
            children: [
              Positioned.fill(child: GameWidget(game: game)),
              Positioned.fill(
                child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => widget.onStart(false)),
              ),
              Positioned(
                top: 24,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Column(
                    children: [
                      Text('RATTLERAMP', style: hudStyle.copyWith(fontSize: 56, color: Palette.rampEdge)),
                      Text('U CHŘESTÝŠE', style: hudStyle.copyWith(fontSize: 20, color: Palette.coping)),
                    ],
                  ),
                ),
              ),
              Center(
                child: IgnorePointer(
                  child: FadeTransition(
                    opacity: Tween(begin: 0.35, end: 1.0).animate(pulse),
                    child: Text('TAPNI A JEĎ', style: hudStyle.copyWith(fontSize: 44)),
                  ),
                ),
              ),
              Positioned(
                left: 24,
                bottom: 24,
                child: IgnorePointer(
                  child: Text(
                    'TRIK DNE: ${widget.daily.name.toUpperCase()} ×2',
                    style: hudStyle.copyWith(fontSize: 20, color: Palette.good),
                  ),
                ),
              ),
              Positioned(
                right: 24,
                bottom: 24,
                child: Row(
                  children: [
                    _BigButton(label: 'TRICK BOOK', color: Palette.rampEdge, onTap: widget.onTrickBook),
                    const SizedBox(width: 16),
                    _BigButton(label: 'PRO ×1,5', color: Palette.coping, onTap: () => widget.onStart(true)),
                  ],
                ),
              ),
              Positioned(
                top: 24,
                right: 24,
                child: _BigButton(
                  label: 'STYL: ${widget.settings.style.label}',
                  color: Palette.good,
                  small: true,
                  onTap: () => widget.settings.style = widget.settings.style.next,
                ),
              ),
              // Hidden: 3 s long press in the top-left corner (PIN comes in M4).
              Positioned(
                left: 0,
                top: 0,
                width: 90,
                height: 90,
                child: _HiddenLongPress(onTriggered: () => showTuningPanel(context, widget.settings)),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _BigButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool small;
  const _BigButton({required this.label, required this.color, required this.onTap, this.small = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: small
            ? const EdgeInsets.symmetric(horizontal: 18, vertical: 10)
            : const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 3),
          borderRadius: BorderRadius.circular(16),
          color: Palette.night.withValues(alpha: 0.7),
        ),
        child: Text(
          label,
          style: hudStyle.copyWith(fontSize: small ? 16 : 22, color: color),
        ),
      ),
    );
  }
}

class _HiddenLongPress extends StatefulWidget {
  final VoidCallback onTriggered;
  const _HiddenLongPress({required this.onTriggered});

  @override
  State<_HiddenLongPress> createState() => _HiddenLongPressState();
}

class _HiddenLongPressState extends State<_HiddenLongPress> {
  DateTime? _down;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => _down = DateTime.now(),
      onPointerCancel: (_) => _down = null,
      onPointerUp: (_) {
        final d = _down;
        _down = null;
        if (d != null && DateTime.now().difference(d) >= const Duration(seconds: 3)) {
          widget.onTriggered();
        }
      },
    );
  }
}
