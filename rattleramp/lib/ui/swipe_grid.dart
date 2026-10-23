import 'package:flutter/material.dart';

import '../core/grid.dart';
import 'pattern_painter.dart';
import 'theme.dart';

/// Fixed 3×3 swipe pad. Tracks one finger, lights up the path live and
/// reports the node sequence on lift.
///
/// Recognition is by node sequence, not by curve: a node is hit when the
/// finger passes within [hitRadius] × cell of its centre. Fast swipes are
/// sampled along the segment between pointer events, and a skipped node on a
/// straight line (0→2 over 1) is filled in.
class SwipeGrid extends StatefulWidget {
  final void Function(List<int> nodes) onRelease;
  final double hitRadius;

  const SwipeGrid({super.key, required this.onRelease, this.hitRadius = 0.36});

  @override
  State<SwipeGrid> createState() => _SwipeGridState();
}

class _SwipeGridState extends State<SwipeGrid> {
  int? _pointer;
  Offset? _last;
  final List<int> _nodes = [];
  Offset? _finger;

  /// Ignore touches this close to the physical screen edge (frame / palm).
  static const double _edgeGuard = 18;

  Size get _size => (context.size ?? Size.zero);

  void _down(PointerDownEvent e) {
    if (_pointer != null) return;
    final screen = MediaQuery.sizeOf(context);
    final g = e.position;
    if (g.dx < _edgeGuard ||
        g.dy < _edgeGuard ||
        g.dx > screen.width - _edgeGuard ||
        g.dy > screen.height - _edgeGuard) {
      return;
    }
    _pointer = e.pointer;
    _nodes.clear();
    _last = e.localPosition;
    _hit(e.localPosition);
    setState(() => _finger = e.localPosition);
  }

  void _move(PointerMoveEvent e) {
    if (e.pointer != _pointer) return;
    final from = _last!;
    final to = e.localPosition;
    final dist = (to - from).distance;
    final steps = (dist / 4).ceil().clamp(1, 200);
    for (var i = 1; i <= steps; i++) {
      _hit(Offset.lerp(from, to, i / steps)!);
    }
    _last = to;
    setState(() => _finger = to);
  }

  void _up(PointerEvent e) {
    if (e.pointer != _pointer) return;
    _pointer = null;
    final nodes = List<int>.of(_nodes);
    setState(() {
      _nodes.clear();
      _finger = null;
    });
    if (e is PointerUpEvent) widget.onRelease(nodes);
  }

  void _hit(Offset p) {
    final size = _size;
    final cell = size.shortestSide / 3;
    for (var n = 0; n < 9; n++) {
      if ((PatternPainter.nodeCenter(n, size) - p).distance > cell * widget.hitRadius) continue;
      if (_nodes.isNotEmpty) {
        final prev = _nodes.last;
        if (prev == n) return;
        if (!areAdjacent(prev, n)) {
          final mid = midpointNode(prev, n);
          if (mid == null) return;
          _nodes.add(mid);
        }
      }
      _nodes.add(n);
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _down,
      onPointerMove: _move,
      onPointerUp: _up,
      onPointerCancel: _up,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Palette.night.withValues(alpha: 0.35),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Palette.rampEdge.withValues(alpha: 0.25), width: 2),
        ),
        child: CustomPaint(painter: _LivePainter(List<int>.of(_nodes), _finger), size: Size.infinite),
      ),
    );
  }
}

class _LivePainter extends CustomPainter {
  final List<int> nodes;
  final Offset? finger;
  _LivePainter(this.nodes, this.finger);

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.shortestSide / 3;
    final ring = Paint()
      ..color = Palette.skater.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    for (var n = 0; n < 9; n++) {
      final c = PatternPainter.nodeCenter(n, size);
      final lit = nodes.contains(n);
      canvas.drawCircle(c, cell * 0.12, Paint()..color = lit ? Palette.rampEdge : Palette.dim.withValues(alpha: 0.5));
      canvas.drawCircle(
        c,
        cell * 0.3,
        ring..color = (lit ? Palette.rampEdge : Palette.skater).withValues(alpha: lit ? 0.8 : 0.25),
      );
    }
    if (nodes.isEmpty) return;
    final line = Paint()
      ..color = Palette.rampEdge.withValues(alpha: 0.85)
      ..strokeWidth = cell * 0.09
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final p = Path();
    final first = PatternPainter.nodeCenter(nodes.first, size);
    p.moveTo(first.dx, first.dy);
    for (final n in nodes.skip(1)) {
      final c = PatternPainter.nodeCenter(n, size);
      p.lineTo(c.dx, c.dy);
    }
    if (finger != null) p.lineTo(finger!.dx, finger!.dy);
    canvas.drawPath(p, line);
  }

  @override
  bool shouldRepaint(_LivePainter old) => true;
}
