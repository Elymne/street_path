import 'package:flutter/material.dart';
import 'dart:math';

class WaveBackground extends StatefulWidget {
  final Color color;

  const WaveBackground({super.key, this.color = Colors.blueAccent});

  @override
  createState() => _State();
}

class _State extends State<WaveBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(duration: const Duration(milliseconds: 60_000), vsync: this)..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return CustomPaint(painter: WavyPuddlePainter(animationValue: _controller.value, color: widget.color), size: Size.infinite);
      },
    );
  }
}

class WavyPuddlePainter extends CustomPainter {
  final double animationValue;
  final Color color;
  late final Paint paintBlob = Paint()..color = color.withAlpha(160);

  WavyPuddlePainter({required this.animationValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;

    final Path path = Path();
    const int points = 8;
    final double baseRadius = 400;
    final double waveStrength = 40;
    final double t = animationValue * 2 * pi;

    List<Offset> vertices = [];

    for (int i = 0; i < points; i++) {
      double angle = 2.1 * pi * i / points;
      double wave = sin(t + angle * 2 + i) * waveStrength;
      double radius = baseRadius + wave;
      double x = centerX + radius * cos(angle);
      double y = centerY + radius * sin(angle);
      vertices.add(Offset(x, y));
    }

    path.moveTo(vertices[0].dx, vertices[0].dy);

    for (int i = 0; i < vertices.length; i++) {
      Offset p1 = vertices[i];
      Offset p2 = vertices[(i + 1) % vertices.length];
      Offset controlPoint = Offset((p1.dx + p2.dx) / 2 + sin(t + i) * 10, (p1.dy + p2.dy) / 2 + cos(t + i) * 10);
      path.quadraticBezierTo(p1.dx, p1.dy, controlPoint.dx, controlPoint.dy);
    }

    path.close();
    canvas.drawPath(path, paintBlob);
  }

  @override
  bool shouldRepaint(covariant WavyPuddlePainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
