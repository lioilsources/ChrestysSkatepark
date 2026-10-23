import 'package:flutter/material.dart';

import '../core/trick_defs.dart';
import '../core/trick_parser.dart';
import 'pattern_painter.dart';
import 'theme.dart';

/// Every token and named combo with an animated finger drawing its pattern.
class TrickBookScreen extends StatefulWidget {
  final TrickBook book;
  final VoidCallback onClose;
  const TrickBookScreen({super.key, required this.book, required this.onClose});

  @override
  State<TrickBookScreen> createState() => _TrickBookScreenState();
}

typedef _Entry = ({String name, List<int> path, int points, int grade, String? note});

class _TrickBookScreenState extends State<TrickBookScreen> with SingleTickerProviderStateMixin {
  late final AnimationController anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800))
    ..repeat();
  late final TrickParser parser = TrickParser(widget.book);
  int tab = 0;

  @override
  void dispose() {
    anim.dispose();
    super.dispose();
  }

  _Entry _token(TrickToken t, {String? note}) =>
      (name: t.name, path: t.path, points: t.base, grade: trickGrade(t.moves), note: note);

  List<_Entry> get entries {
    final b = widget.book;
    return switch (tab) {
      0 => [for (final t in b.grabs) _token(t)],
      1 => [for (final t in b.flips) _token(t)],
      2 => [for (final t in b.spins) _token(t, note: 'začni kdekoli na okraji')],
      _ => [
        for (final c in b.combos)
          if (b.comboPath(c) case final p?)
            (
              name: c.name,
              path: p,
              points: parser.parse(p).trick!.baseSum,
              grade: trickGrade(p.length - 1),
              note: c.tokens.map((id) => b.token(id)!.name).join(' + '),
            ),
      ],
    };
  }

  @override
  Widget build(BuildContext context) {
    const tabs = ['GRABY', 'FLIPY', 'SPINY', 'KOMBA'];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text('TRICK BOOK', style: hudStyle.copyWith(fontSize: 32, color: Palette.rampEdge)),
                  const SizedBox(width: 24),
                  for (var i = 0; i < tabs.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(tabs[i], style: hudStyle.copyWith(fontSize: 16)),
                        selected: tab == i,
                        onSelected: (_) => setState(() => tab = i),
                      ),
                    ),
                  const Spacer(),
                  IconButton(iconSize: 40, onPressed: widget.onClose, icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Po obvodu = spin (po směru hodin FS, proti BS) · přes střed = grab · kosočtverec = flip. '
                'Spoj triky jedním tahem – další začíná tam, kde předchozí skončil. Pusť prst, když kruh dosedne na hranu.',
                style: hudStyle.copyWith(fontSize: 14, color: Palette.dim, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: GridView.extent(
                  maxCrossAxisExtent: 220,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                  children: [for (final e in entries) _Card(entry: e, anim: anim)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final _Entry entry;
  final Animation<double> anim;
  const _Card({required this.entry, required this.anim});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Palette.rampFill, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 1,
              child: AnimatedBuilder(
                animation: anim,
                builder: (context, _) =>
                    CustomPaint(painter: PatternPainter(entry.path, progress: (anim.value * 1.25).clamp(0, 1))),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            entry.name,
            style: hudStyle.copyWith(fontSize: 16),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${entry.points} b  ${'●' * entry.grade}${'○' * (5 - entry.grade)}',
            style: hudStyle.copyWith(fontSize: 13, color: Palette.good),
          ),
          if (entry.note != null)
            Text(
              entry.note!,
              style: hudStyle.copyWith(fontSize: 11, color: Palette.dim),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
        ],
      ),
    );
  }
}
