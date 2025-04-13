import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';
import 'dart:math' as math;

class PixelBackground extends StatefulWidget {
  const PixelBackground({super.key});

  @override
  State<PixelBackground> createState() => _PixelBackgroundState();
}

class _PixelBackgroundState extends State<PixelBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<MagicalElement> _elements = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    // Initialize magical elements
    _elements.addAll([
      MagicalElement(
        type: 'candle',
        position: const Offset(0.1, 0.2),
        size: 48,
        speed: 0.1,
      ),
      MagicalElement(
        type: 'book',
        position: const Offset(0.8, 0.3),
        size: 40,
        speed: 0.15,
      ),
      MagicalElement(
        type: 'potion',
        position: const Offset(0.3, 0.7),
        size: 36,
        speed: 0.2,
      ),
      MagicalElement(
        type: 'crystal',
        position: const Offset(0.7, 0.6),
        size: 44,
        speed: 0.12,
      ),
      MagicalElement(
        type: 'skull',
        position: const Offset(0.4, 0.4),
        size: 42,
        speed: 0.18,
      ),
    ]);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: PixelBackgroundPainter(
            controller: _controller,
            elements: _elements,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  PixelTheme.darkPurple.withOpacity(0.95),
                  PixelTheme.shadowPurple.withOpacity(0.98),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MagicalElement {
  final String type;
  final Offset position;
  final double size;
  final double speed;

  MagicalElement({
    required this.type,
    required this.position,
    required this.size,
    required this.speed,
  });
}

class PixelBackgroundPainter extends CustomPainter {
  final AnimationController controller;
  final List<MagicalElement> elements;

  PixelBackgroundPainter({
    required this.controller,
    required this.elements,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw stone wall texture
    _drawStoneWall(canvas, size);

    // Draw magical elements
    for (final element in elements) {
      _drawMagicalElement(canvas, size, element);
    }

    // Draw magical runes
    _drawMagicalRunes(canvas, size);

    // Draw cobwebs
    _drawCobwebs(canvas, size);
  }

  void _drawStoneWall(Canvas canvas, Size size) {
    final stonePaint = Paint()
      ..color = PixelTheme.uiDark.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw stone blocks
    for (var y = 0; y < size.height; y += 40) {
      for (var x = 0; x < size.width; x += 40) {
        final offset =
            (x / size.width + y / size.height + controller.value) % 1.0;
        final opacity = (1 - (2 * (offset - 0.5)).abs()) * 0.1;
        stonePaint.color = PixelTheme.uiDark.withOpacity(0.3 + opacity);

        canvas.drawRect(
          Rect.fromLTWH(x.toDouble(), y.toDouble(), 40, 40),
          stonePaint,
        );
      }
    }
  }

  void _drawMagicalElement(Canvas canvas, Size size, MagicalElement element) {
    final position = Offset(
      size.width * element.position.dx,
      size.height * element.position.dy +
          math.sin(controller.value * 2 * math.pi * element.speed) * 10,
    );

    switch (element.type) {
      case 'candle':
        _drawCandle(canvas, position, element.size);
        break;
      case 'book':
        _drawBook(canvas, position, element.size);
        break;
      case 'potion':
        _drawPotion(canvas, position, element.size);
        break;
      case 'crystal':
        _drawCrystal(canvas, position, element.size);
        break;
      case 'skull':
        _drawSkull(canvas, position, element.size);
        break;
    }
  }

  void _drawCandle(Canvas canvas, Offset position, double size) {
    // Candle base
    final basePaint = Paint()..color = PixelTheme.boneWhite;
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - size * 0.1,
        position.dy - size * 0.3,
        size * 0.2,
        size * 0.6,
      ),
      basePaint,
    );

    // Flame
    final flamePaint = Paint()
      ..color = PixelTheme.candleYellow.withOpacity(
        0.7 + math.sin(controller.value * 2 * math.pi) * 0.3,
      );
    final flamePath = Path()
      ..moveTo(position.dx, position.dy - size * 0.3)
      ..quadraticBezierTo(
        position.dx - size * 0.1,
        position.dy - size * 0.4,
        position.dx,
        position.dy - size * 0.5,
      )
      ..quadraticBezierTo(
        position.dx + size * 0.1,
        position.dy - size * 0.4,
        position.dx,
        position.dy - size * 0.3,
      );
    canvas.drawPath(flamePath, flamePaint);
  }

  void _drawBook(Canvas canvas, Offset position, double size) {
    final bookPaint = Paint()..color = PixelTheme.rustBrown;
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - size * 0.2,
        position.dy - size * 0.3,
        size * 0.4,
        size * 0.6,
      ),
      bookPaint,
    );

    // Pages
    final pagePaint = Paint()..color = PixelTheme.boneWhite;
    for (var i = 0; i < 3; i++) {
      canvas.drawRect(
        Rect.fromLTWH(
          position.dx - size * 0.15,
          position.dy - size * 0.25 + i * size * 0.2,
          size * 0.3,
          size * 0.1,
        ),
        pagePaint,
      );
    }
  }

  void _drawPotion(Canvas canvas, Offset position, double size) {
    // Bottle
    final bottlePaint = Paint()..color = PixelTheme.uiAccent.withOpacity(0.8);
    final bottlePath = Path()
      ..moveTo(position.dx, position.dy - size * 0.3)
      ..quadraticBezierTo(
        position.dx - size * 0.2,
        position.dy,
        position.dx,
        position.dy + size * 0.3,
      )
      ..quadraticBezierTo(
        position.dx + size * 0.2,
        position.dy,
        position.dx,
        position.dy - size * 0.3,
      );
    canvas.drawPath(bottlePath, bottlePaint);

    // Liquid
    final liquidPaint = Paint()
      ..color = PixelTheme.poisonGreen.withOpacity(
        0.6 + math.sin(controller.value * 2 * math.pi) * 0.2,
      );
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - size * 0.1,
        position.dy,
        size * 0.2,
        size * 0.2,
      ),
      liquidPaint,
    );
  }

  void _drawCrystal(Canvas canvas, Offset position, double size) {
    final crystalPaint = Paint()
      ..color = PixelTheme.lightPurple.withOpacity(
        0.7 + math.sin(controller.value * 2 * math.pi) * 0.3,
      );
    final crystalPath = Path()
      ..moveTo(position.dx, position.dy - size * 0.3)
      ..lineTo(position.dx - size * 0.2, position.dy)
      ..lineTo(position.dx, position.dy + size * 0.3)
      ..lineTo(position.dx + size * 0.2, position.dy)
      ..close();
    canvas.drawPath(crystalPath, crystalPaint);
  }

  void _drawSkull(Canvas canvas, Offset position, double size) {
    // Skull base
    final skullPaint = Paint()..color = PixelTheme.boneWhite;
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - size * 0.2,
        position.dy - size * 0.2,
        size * 0.4,
        size * 0.4,
      ),
      skullPaint,
    );

    // Eye sockets
    final socketPaint = Paint()..color = PixelTheme.shadowPurple;
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx - size * 0.15,
        position.dy - size * 0.1,
        size * 0.1,
        size * 0.1,
      ),
      socketPaint,
    );
    canvas.drawRect(
      Rect.fromLTWH(
        position.dx + size * 0.05,
        position.dy - size * 0.1,
        size * 0.1,
        size * 0.1,
      ),
      socketPaint,
    );
  }

  void _drawMagicalRunes(Canvas canvas, Size size) {
    final runePaint = Paint()
      ..color = PixelTheme.uiAccent.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 8; i++) {
      final angle = (i / 8) * 2 * math.pi;
      final radius = size.width * 0.4;
      final center = Offset(size.width * 0.5, size.height * 0.5);
      final position = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      final runePath = Path();
      runePath.moveTo(position.dx, position.dy);
      for (var j = 0; j < 3; j++) {
        final runeAngle = angle + (j * math.pi / 4);
        runePath.lineTo(
          position.dx + math.cos(runeAngle) * 20,
          position.dy + math.sin(runeAngle) * 20,
        );
      }
      canvas.drawPath(runePath, runePaint);
    }
  }

  void _drawCobwebs(Canvas canvas, Size size) {
    final webPaint = Paint()
      ..color = PixelTheme.boneWhite.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final corners = [
      Offset(0, 0),
      Offset(size.width, 0),
      Offset(0, size.height),
      Offset(size.width, size.height),
    ];

    for (final corner in corners) {
      final webPath = Path();
      webPath.moveTo(corner.dx, corner.dy);
      for (var i = 0; i < 8; i++) {
        final angle = (i / 8) * math.pi / 2;
        final length = size.width * 0.2;
        webPath.lineTo(
          corner.dx + math.cos(angle) * length,
          corner.dy + math.sin(angle) * length,
        );
      }
      canvas.drawPath(webPath, webPaint);
    }
  }

  @override
  bool shouldRepaint(PixelBackgroundPainter oldDelegate) => true;
}
