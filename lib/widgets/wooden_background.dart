import 'package:flutter/material.dart';
import 'dart:math' as math;

class WoodenBackground extends StatelessWidget {
  const WoodenBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: WoodenPatternPainter(),
      child: Container(),
    );
  }
}

class WoodenPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF8B4513) // Saddle Brown
      ..style = PaintingStyle.fill;

    // Draw base color
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Draw wood grain patterns
    final random = math.Random(42); // Fixed seed for consistent pattern
    final grainPaint = Paint()
      ..color = const Color(0xFF3D2B1F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < size.height; i += 20) {
      final path = Path();
      var x = 0.0;
      var y = i.toDouble();

      path.moveTo(x, y);

      while (x < size.width) {
        x += random.nextDouble() * 30 + 20;
        y += (random.nextDouble() - 0.5) * 10;
        path.lineTo(x, y);
      }

      canvas.drawPath(
          path, grainPaint..color = const Color(0xFF3D2B1F).withOpacity(0.3));
    }

    // Add some knots
    final knotPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = RadialGradient(
        colors: const [
          Color(0xFF3D2B1F),
          Color(0xFF8B4513),
        ],
      ).createShader(Rect.fromCircle(
        center: Offset.zero,
        radius: 20,
      ));

    for (var i = 0; i < 5; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 10 + 5;

      canvas.save();
      canvas.translate(x, y);
      canvas.drawCircle(Offset.zero, radius, knotPaint);
      canvas.restore();
    }

    // Add a subtle overlay to create depth
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.black.withOpacity(0.2),
          ],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)),
    );
  }

  @override
  bool shouldRepaint(WoodenPatternPainter oldDelegate) => false;
}
