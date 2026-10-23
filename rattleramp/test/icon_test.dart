import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// App icon: a rattlesnake riding a skateboard over a neon U-ramp.
/// Regenerate the source PNGs, then the platform icons:
///   ICON_OUT=assets/icon flutter test test/icon_test.dart
///   dart run flutter_launcher_icons
void main() {
  final out = Platform.environment['ICON_OUT'];
  testWidgets('app icon', skip: out == null, (tester) async {
    Future<void> save(String name, void Function(Canvas) paint) async {
      final rec = ui.PictureRecorder();
      paint(Canvas(rec));
      final img = await tester.runAsync(() => rec.endRecording().toImage(1024, 1024));
      final bytes = await tester.runAsync(() => img!.toByteData(format: ui.ImageByteFormat.png));
      File('$out/$name').writeAsBytesSync(bytes!.buffer.asUint8List());
    }

    Directory(out!).createSync(recursive: true);
    await save('icon.png', (c) {
      _background(c);
      _rider(c, 1);
    });
    // Android adaptive icon: foreground scaled into the 66 % safe zone.
    await save('icon_foreground.png', (c) {
      c.translate(512, 512);
      c.scale(0.68);
      c.translate(-512, -512);
      _rider(c, 1);
    });
    await save('icon_background.png', _background);
  });
}

const _night = Color(0xFF0E1018);
const _nightHi = Color(0xFF232A45);
const _cyan = Color(0xFF3EF0FF);
const _pink = Color(0xFFFF4FD8);
const _board = Color(0xFFFFB238);
const _ink = Color(0xFF0A0B10);
const _snake = Color(0xFF5CD65C);
const _snakeDark = Color(0xFF2E7D3A);
const _belly = Color(0xFFE6E08A);
const _rattle = Color(0xFFF2D49B);

void _background(Canvas c) {
  const r = Rect.fromLTWH(0, 0, 1024, 1024);
  c.drawRect(r, Paint()..shader = const RadialGradient(colors: [_nightHi, _night], radius: 0.75).createShader(r));
  // Neon U-ramp across the bottom.
  final ramp = Path()
    ..moveTo(-40, 610)
    ..lineTo(90, 610)
    ..arcToPoint(const Offset(934, 610), radius: const Radius.circular(422), clockwise: false)
    ..lineTo(1064, 610);
  final glow = Paint()
    ..color = _cyan.withValues(alpha: 0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 46
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22);
  c.drawPath(ramp, glow);
  c.drawPath(
    ramp,
    Paint()
      ..color = _cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18,
  );
  for (final x in [90.0, 934.0]) {
    c.drawCircle(Offset(x, 610), 26, Paint()..color = _pink);
  }
}

void _rider(Canvas c, double s) {
  c.save();
  c.translate(530, 600);
  c.rotate(-0.12);

  // ── Board ────────────────────────────────────────────────────────────
  final deck = Path()
    ..moveTo(-380, -40)
    ..quadraticBezierTo(-330, 0, -270, 0)
    ..lineTo(270, 0)
    ..quadraticBezierTo(330, 0, 380, -40);
  final outline = Paint()
    ..color = _ink
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  for (final x in [-215.0, 215.0]) {
    c.drawRect(Rect.fromCenter(center: Offset(x, 40), width: 90, height: 34), Paint()..color = const Color(0xFF9AA0B5));
    c.drawCircle(Offset(x - 40, 82), 44, Paint()..color = _ink);
    c.drawCircle(Offset(x + 40, 82), 44, Paint()..color = _ink);
    c.drawCircle(Offset(x - 40, 82), 32, Paint()..color = const Color(0xFFF4F1E8));
    c.drawCircle(Offset(x + 40, 82), 32, Paint()..color = const Color(0xFFF4F1E8));
  }
  c.drawPath(deck, outline..strokeWidth = 76);
  c.drawPath(
    deck,
    Paint()
      ..color = _board
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 52,
  );

  // ── Snake ────────────────────────────────────────────────────────────
  // Tail rises at the back with the rattle, the body coils along the deck,
  // the neck rears up at the front.
  final body = Path()
    ..moveTo(-300, -330)
    ..cubicTo(-330, -200, -330, -90, -220, -70)
    ..cubicTo(-80, -45, 40, -110, 140, -70)
    ..cubicTo(260, -25, 300, -150, 250, -260)
    ..cubicTo(215, -340, 130, -360, 80, -390);
  c.drawPath(
    body,
    Paint()
      ..color = _snake.withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 150
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 30),
  );
  c.drawPath(body, outline..strokeWidth = 128);
  c.drawPath(
    body,
    Paint()
      ..color = _snake
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 100,
  );

  // Diamond back pattern, oriented along the body.
  final metric = body.computeMetrics().first;
  final diamond = Paint()..color = _snakeDark;
  for (var d = 70.0; d < metric.length - 80; d += 62) {
    final t = metric.getTangentForOffset(d)!;
    c.save();
    c.translate(t.position.dx, t.position.dy);
    c.rotate(t.vector.direction);
    c.drawPath(
      Path()
        ..moveTo(-24, 0)
        ..lineTo(0, -26)
        ..lineTo(24, 0)
        ..lineTo(0, 26)
        ..close(),
      diamond,
    );
    c.restore();
  }

  // Rattle: stacked segments continuing the tail upwards.
  final tail = metric.getTangentForOffset(0)!;
  c.save();
  c.translate(tail.position.dx, tail.position.dy);
  c.rotate(tail.vector.direction + math.pi);
  for (var i = 0; i < 4; i++) {
    final w = 92.0 - i * 14;
    final seg = Rect.fromCenter(center: Offset(26.0 + i * 40, 0), width: 52, height: w);
    c.drawOval(seg.inflate(12), Paint()..color = _ink);
    c.drawOval(seg, Paint()..color = _rattle);
  }
  c.restore();
  // Shake lines around the rattle tip.
  final tip = tail.position - tail.vector * 175;
  final shake = Paint()
    ..color = _rattle
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 14;
  for (final a in [-2.7, -2.2, -1.7, -0.95, -0.5]) {
    c.drawLine(tip + Offset.fromDirection(a, 70), tip + Offset.fromDirection(a, 110), shake);
  }

  // Head at the front end of the body, looking forward.
  final neck = metric.getTangentForOffset(metric.length)!;
  c.save();
  c.translate(neck.position.dx, neck.position.dy);
  c.rotate(math.pi + 0.15);
  // Forked tongue.
  final tongue = Path()
    ..moveTo(110, 18)
    ..lineTo(190, 22)
    ..moveTo(185, 22)
    ..lineTo(222, -4)
    ..moveTo(185, 22)
    ..lineTo(222, 48);
  c.drawPath(
    tongue,
    Paint()
      ..color = const Color(0xFFFF3B5C)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 16,
  );
  final head = Path()
    ..moveTo(-60, -70)
    ..cubicTo(40, -95, 130, -50, 135, 5)
    ..cubicTo(140, 50, 60, 80, -40, 70)
    ..cubicTo(-90, 60, -110, -55, -60, -70)
    ..close();
  c.drawPath(head, outline..strokeWidth = 28);
  c.drawPath(head, Paint()..color = _snake);
  c.drawPath(
    Path()
      ..moveTo(-50, 50)
      ..cubicTo(20, 64, 90, 50, 125, 22),
    Paint()
      ..color = _belly
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 16,
  );
  // Eye with a slit pupil and a brow for attitude.
  c.drawCircle(const Offset(55, -22), 30, Paint()..color = _ink);
  c.drawCircle(const Offset(55, -22), 22, Paint()..color = const Color(0xFFFFE15C));
  c.drawOval(Rect.fromCenter(center: const Offset(58, -22), width: 10, height: 34), Paint()..color = _ink);
  c.drawLine(const Offset(15, -58), const Offset(95, -46), outline..strokeWidth = 16);
  c.drawCircle(const Offset(118, -8), 6, Paint()..color = _ink);
  c.restore();

  c.restore();
}
