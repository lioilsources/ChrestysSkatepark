import 'dart:async';

import 'package:flutter/material.dart';

import '../core/ride_sim.dart';
import 'theme.dart';

/// End-of-ride summary. Taps are ignored for the first 2 s so a late swipe
/// doesn't skip it. (Initials entry follows here in M3.)
class StatCard extends StatefulWidget {
  final RideStats stats;
  final bool bailed;
  final VoidCallback onDone;
  const StatCard({super.key, required this.stats, required this.bailed, required this.onDone});

  @override
  State<StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<StatCard> {
  bool _armed = false;
  late final Timer _arm = Timer(const Duration(seconds: 2), () => setState(() => _armed = true));

  @override
  void initState() {
    super.initState();
    _arm;
  }

  @override
  void dispose() {
    _arm.cancel();
    super.dispose();
  }

  String get _timingLabel {
    final t = widget.stats.averageTiming;
    if (widget.stats.landed == 0) return '–';
    if (t > 0.85) return 'PERFECT';
    if (t > 0.55) return 'GOOD';
    return 'LATE';
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.stats;
    Widget row(String k, String v) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 260,
            child: Text(k, style: hudStyle.copyWith(fontSize: 22, color: Palette.dim)),
          ),
          SizedBox(width: 320, child: Text(v, style: hudStyle.copyWith(fontSize: 26))),
        ],
      ),
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _armed ? widget.onDone : null,
      child: Container(
        color: Palette.night.withValues(alpha: 0.88),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.bailed ? 'BAIL!' : 'KONEC JÍZDY',
              style: hudStyle.copyWith(fontSize: 28, color: widget.bailed ? Palette.miss : Palette.dim),
            ),
            Text('${s.score}', style: hudStyle.copyWith(fontSize: 88, color: Palette.rampEdge)),
            const SizedBox(height: 12),
            row('NEJLEPŠÍ TRIK', s.bestTrick == null ? '–' : '${s.bestTrick}  (${s.bestTrickPoints})'),
            row('NEJDELŠÍ COMBO', '${s.maxStreak}'),
            row('TRIKŮ', '${s.landed}'),
            row('PRŮMĚRNÝ TIMING', _timingLabel),
            const SizedBox(height: 24),
            AnimatedOpacity(
              opacity: _armed ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: Text('TAPNI PRO POKRAČOVÁNÍ', style: hudStyle.copyWith(fontSize: 18, color: Palette.dim)),
            ),
          ],
        ),
      ),
    );
  }
}
