import 'package:flutter/material.dart';
import 'dart:math' as math;

class CauldronPainter extends CustomPainter {
  final Color color;
  final bool isGlowing;

  CauldronPainter({
    this.color = const Color(0xFF2F2F2F),
    this.isGlowing = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..strokeWidth = 4;

    if (isGlowing) {
      paint.maskFilter = const MaskFilter.blur(BlurStyle.outer, 4);
    }

    // Draw cauldron body
    final bodyPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.1,
        size.height * 0.6,
        size.width * 0.2,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.9,
        size.width * 0.8,
        size.height * 0.8,
      )
      ..quadraticBezierTo(
        size.width * 0.9,
        size.height * 0.6,
        size.width * 0.8,
        size.height * 0.3,
      );

    // Draw rim
    final rimPath = Path()
      ..moveTo(size.width * 0.15, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.25,
        size.width * 0.85,
        size.height * 0.3,
      );

    // Draw legs
    final leftLeg = Path()
      ..moveTo(size.width * 0.25, size.height * 0.8)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.3, size.height);

    final rightLeg = Path()
      ..moveTo(size.width * 0.75, size.height * 0.8)
      ..lineTo(size.width * 0.7, size.height)
      ..lineTo(size.width * 0.8, size.height);

    // Draw handles
    final leftHandle = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.15, size.height * 0.4),
          width: size.width * 0.2,
          height: size.height * 0.2,
        ),
        math.pi * 0.5,
        math.pi,
      );

    final rightHandle = Path()
      ..addArc(
        Rect.fromCenter(
          center: Offset(size.width * 0.85, size.height * 0.4),
          width: size.width * 0.2,
          height: size.height * 0.2,
        ),
        math.pi * 1.5,
        math.pi,
      );

    // Draw all parts
    canvas.drawPath(bodyPath, paint);
    canvas.drawPath(rimPath, paint..style = PaintingStyle.stroke);
    canvas.drawPath(leftLeg, paint..style = PaintingStyle.fill);
    canvas.drawPath(rightLeg, paint);
    canvas.drawPath(leftHandle, paint..style = PaintingStyle.stroke);
    canvas.drawPath(rightHandle, paint..style = PaintingStyle.stroke);

    // Add highlights
    if (isGlowing) {
      final highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawPath(bodyPath, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(CauldronPainter oldDelegate) =>
      color != oldDelegate.color || isGlowing != oldDelegate.isGlowing;
}
