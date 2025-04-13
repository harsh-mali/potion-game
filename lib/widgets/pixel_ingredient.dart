import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';
import 'pixel_particles.dart';
import 'dart:math' as math;

class PixelIngredient extends StatefulWidget {
  final String type;
  final double size;
  final bool isGlowing;
  final bool isDraggable;

  const PixelIngredient({
    super.key,
    required this.type,
    this.size = 64.0,
    this.isGlowing = false,
    this.isDraggable = true,
  });

  @override
  State<PixelIngredient> createState() => _PixelIngredientState();
}

class _PixelIngredientState extends State<PixelIngredient>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getBaseColor() {
    switch (widget.type) {
      case 'mushroom':
        return PixelTheme.bloodRed;
      case 'herb':
        return PixelTheme.poisonGreen;
      case 'crystal':
        return PixelTheme.candleYellow;
      case 'flower':
        return PixelTheme.uiAccent;
      case 'root':
        return PixelTheme.rustBrown;
      case 'berry':
        return PixelTheme.bloodRed.withBlue(150);
      case 'leaf':
        return PixelTheme.poisonGreen.withRed(100);
      case 'gem':
        return PixelTheme.candleYellow.withBlue(200);
      default:
        return PixelTheme.uiAccent;
    }
  }

  Widget _buildIngredient() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            0,
            math.sin(_controller.value * 2 * math.pi) * 2,
          ),
          child: Transform.rotate(
            angle: _isHovered
                ? math.sin(_controller.value * 2 * math.pi) * 0.1
                : 0,
            child: AnimatedScale(
              scale: _isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: CustomPaint(
                size: Size(widget.size, widget.size),
                painter: PixelIngredientPainter(
                  type: widget.type,
                  baseColor: _getBaseColor(),
                  isGlowing: widget.isGlowing || _isHovered,
                  animationValue: _controller.value,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget ingredient = MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: _buildIngredient(),
    );

    if (widget.isDraggable) {
      ingredient = Draggable<String>(
        data: widget.type,
        feedback: PixelParticleSystem(
          type: ParticleType.sparkle,
          child: _buildIngredient(),
        ),
        childWhenDragging: Opacity(
          opacity: 0.3,
          child: _buildIngredient(),
        ),
        child: ingredient,
      );
    }

    return ingredient;
  }
}

class PixelIngredientPainter extends CustomPainter {
  final String type;
  final Color baseColor;
  final bool isGlowing;
  final double animationValue;

  PixelIngredientPainter({
    required this.type,
    required this.baseColor,
    this.isGlowing = false,
    this.animationValue = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 16;

    void drawPixel(int x, int y, Color color) {
      final shimmerOffset = (y / 16 + animationValue) % 1.0;
      final shimmerAmount = (1 - (2 * (shimmerOffset - 0.5)).abs()) * 0.2;

      final paint = Paint()
        ..color = color.withOpacity(
          color.opacity * (1.0 - (isGlowing ? shimmerAmount : 0.0)),
        );

      canvas.drawRect(
        Rect.fromLTWH(
          x * pixelSize,
          y * pixelSize +
              (isGlowing
                  ? math.sin((x / 16 + animationValue) * 2 * math.pi)
                  : 0),
          pixelSize,
          pixelSize,
        ),
        paint,
      );
    }

    // Draw shadow
    if (isGlowing) {
      final glowPaint = Paint()
        ..color = baseColor.withOpacity(0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 8);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        glowPaint,
      );
    }

    switch (type) {
      case 'mushroom':
        _drawMushroom(drawPixel);
        break;
      case 'crystal':
        _drawCrystal(drawPixel);
        break;
      case 'herb':
        _drawHerb(drawPixel);
        break;
      case 'flower':
        _drawFlower(drawPixel);
        break;
      case 'root':
        _drawRoot(drawPixel);
        break;
      case 'berry':
        _drawBerry(drawPixel);
        break;
      case 'leaf':
        _drawLeaf(drawPixel);
        break;
      case 'gem':
        _drawGem(drawPixel);
        break;
    }
  }

  void _drawMushroom(void Function(int, int, Color) drawPixel) {
    // Cap
    for (var y = 4; y < 8; y++) {
      for (var x = 5; x < 11; x++) {
        drawPixel(x, y, baseColor);
      }
    }
    // Spots
    drawPixel(6, 5, PixelTheme.boneWhite);
    drawPixel(9, 5, PixelTheme.boneWhite);
    drawPixel(7, 6, PixelTheme.boneWhite);
    // Stem
    for (var y = 8; y < 12; y++) {
      drawPixel(7, y, PixelTheme.boneWhite);
      drawPixel(8, y, PixelTheme.boneWhite);
    }
  }

  void _drawCrystal(void Function(int, int, Color) drawPixel) {
    final points = [
      [8, 4],
      [7, 5],
      [9, 5],
      [6, 6],
      [8, 6],
      [10, 6],
      [5, 7],
      [7, 7],
      [9, 7],
      [11, 7],
      [6, 8],
      [8, 8],
      [10, 8],
      [7, 9],
      [9, 9],
      [8, 10]
    ];

    for (final point in points) {
      drawPixel(
        point[0],
        point[1],
        baseColor,
      );
    }

    // Add static highlights
    drawPixel(8, 5, PixelTheme.boneWhite.withOpacity(0.5));
    drawPixel(7, 6, PixelTheme.boneWhite.withOpacity(0.3));
  }

  void _drawHerb(void Function(int x, int y, Color color) drawPixel) {
    // Leaves
    final leafPixels = [
      [6, 4],
      [9, 4],
      [5, 5],
      [7, 5],
      [8, 5],
      [10, 5],
      [6, 6],
      [9, 6],
    ];
    for (final pixel in leafPixels) {
      drawPixel(pixel[0], pixel[1], baseColor);
    }

    // Stem
    for (var y = 7; y < 12; y++) {
      drawPixel(7, y, PixelTheme.rustBrown);
      drawPixel(8, y, PixelTheme.rustBrown);
    }
  }

  void _drawFlower(void Function(int x, int y, Color color) drawPixel) {
    // Petals
    final petalPixels = [
      [8, 4],
      [7, 5],
      [8, 5],
      [9, 5],
      [6, 6],
      [7, 6],
      [8, 6],
      [9, 6],
      [10, 6],
      [7, 7],
      [8, 7],
      [9, 7],
      [8, 8],
    ];
    for (final pixel in petalPixels) {
      drawPixel(pixel[0], pixel[1], baseColor);
    }

    // Center
    drawPixel(8, 6, PixelTheme.candleYellow);
  }

  void _drawRoot(void Function(int x, int y, Color color) drawPixel) {
    final rootPixels = [
      [8, 4],
      [7, 5],
      [8, 5],
      [6, 6],
      [7, 6],
      [5, 7],
      [6, 7],
      [6, 8],
      [7, 8],
      [7, 9],
      [8, 9],
      [8, 10],
      [9, 10],
      [9, 11],
      [10, 11],
    ];
    for (final pixel in rootPixels) {
      drawPixel(pixel[0], pixel[1], baseColor);
    }
  }

  void _drawBerry(void Function(int x, int y, Color color) drawPixel) {
    // Berries
    final berryPixels = [
      [6, 6],
      [9, 6],
      [7, 7],
      [8, 7],
      [6, 8],
      [9, 8],
    ];
    for (final pixel in berryPixels) {
      drawPixel(pixel[0], pixel[1], baseColor);
    }

    // Highlights
    drawPixel(6, 6, baseColor.withOpacity(0.8));
    drawPixel(9, 6, baseColor.withOpacity(0.8));
  }

  void _drawLeaf(void Function(int x, int y, Color color) drawPixel) {
    final leafPixels = [
      [8, 4],
      [7, 5],
      [8, 5],
      [9, 5],
      [6, 6],
      [7, 6],
      [8, 6],
      [9, 6],
      [5, 7],
      [6, 7],
      [7, 7],
      [8, 7],
      [6, 8],
      [7, 8],
      [7, 9],
    ];
    for (final pixel in leafPixels) {
      drawPixel(pixel[0], pixel[1], baseColor);
    }

    // Veins
    drawPixel(7, 6, baseColor.withOpacity(0.8));
    drawPixel(6, 7, baseColor.withOpacity(0.8));
  }

  void _drawGem(void Function(int x, int y, Color color) drawPixel) {
    final gemPixels = [
      [8, 4],
      [7, 5],
      [8, 5],
      [9, 5],
      [6, 6],
      [7, 6],
      [8, 6],
      [9, 6],
      [10, 6],
      [7, 7],
      [8, 7],
      [9, 7],
      [8, 8],
    ];
    for (final pixel in gemPixels) {
      drawPixel(pixel[0], pixel[1], baseColor);
    }

    // Facets
    drawPixel(8, 5, PixelTheme.boneWhite.withOpacity(0.5));
    drawPixel(7, 6, PixelTheme.boneWhite.withOpacity(0.3));
  }

  @override
  bool shouldRepaint(PixelIngredientPainter oldDelegate) =>
      type != oldDelegate.type ||
      baseColor != oldDelegate.baseColor ||
      isGlowing != oldDelegate.isGlowing ||
      animationValue != oldDelegate.animationValue;
}
