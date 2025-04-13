import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';
import 'pixel_particles.dart';
import 'dart:math' as math;

class PixelCauldron extends StatefulWidget {
  final bool isGlowing;
  final bool isCooking;
  final int ingredientCount;

  const PixelCauldron({
    super.key,
    this.isGlowing = false,
    this.isCooking = false,
    this.ingredientCount = 0,
  });

  @override
  State<PixelCauldron> createState() => _PixelCauldronState();
}

class _PixelCauldronState extends State<PixelCauldron>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Offset> _bubbleOffsets = [];

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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            CustomPaint(
              painter: PixelCauldronPainter(
                isGlowing: widget.isGlowing,
                isCooking: widget.isCooking,
                bubblePhase: _controller.value,
              ),
              child: Center(
                child: widget.ingredientCount > 0
                    ? TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        builder: (context, value, child) {
                          return Transform.scale(
                            scale: value,
                            child: Text(
                              '${widget.ingredientCount}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                color: PixelTheme.boneWhite,
                                shadows: [
                                  Shadow(
                                    color:
                                        PixelTheme.poisonGreen.withOpacity(0.8),
                                    offset: const Offset(2, 2),
                                    blurRadius: widget.isCooking ? 8 : 0,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      )
                    : null,
              ),
            ),
            if (widget.isCooking)
              Positioned.fill(
                child: PixelParticleSystem(
                  type: ParticleType.magic,
                  child: const SizedBox(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class PixelCauldronPainter extends CustomPainter {
  final bool isGlowing;
  final bool isCooking;
  final double bubblePhase;

  PixelCauldronPainter({
    this.isGlowing = false,
    this.isCooking = false,
    this.bubblePhase = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 32;

    void drawPixel(int x, int y, Color color) {
      final paint = Paint()..color = color;
      canvas.drawRect(
        Rect.fromLTWH(
          x * pixelSize,
          y * pixelSize,
          pixelSize,
          pixelSize,
        ),
        paint,
      );
    }

    // Draw cauldron outline
    final outline = [
      // Left handle
      [8, 8], [9, 8], [7, 9], [8, 9], [9, 9], [10, 9],
      // Right handle
      [22, 8], [23, 8], [21, 9], [22, 9], [23, 9], [24, 9],
      // Rim
      [10, 10], [11, 10], [12, 10], [13, 10], [14, 10],
      [15, 10], [16, 10], [17, 10], [18, 10], [19, 10],
      [20, 10], [21, 10],
      // Body
      [9, 11], [10, 11], [21, 11], [22, 11],
      [8, 12], [9, 12], [22, 12], [23, 12],
      [8, 13], [9, 13], [22, 13], [23, 13],
      [8, 14], [9, 14], [22, 14], [23, 14],
      [8, 15], [9, 15], [22, 15], [23, 15],
      [9, 16], [10, 16], [21, 16], [22, 16],
      // Base
      [10, 17], [11, 17], [12, 17], [13, 17], [14, 17],
      [15, 17], [16, 17], [17, 17], [18, 17], [19, 17],
      [20, 17], [21, 17],
      // Legs
      [11, 18], [12, 18], [19, 18], [20, 18],
      [11, 19], [12, 19], [19, 19], [20, 19],
    ];

    // Draw shadow with pixel-perfect offset
    for (final pixel in outline) {
      drawPixel(
        pixel[0] + 1,
        pixel[1] + 1,
        PixelTheme.shadowPurple,
      );
    }

    // Draw outline with shimmer effect
    for (final pixel in outline) {
      final shimmerOffset = (pixel[1] / 32 + bubblePhase) % 1.0;
      final shimmerAmount = (1 - (2 * (shimmerOffset - 0.5)).abs()) * 0.2;

      drawPixel(
        pixel[0],
        pixel[1],
        PixelTheme.uiAccent.withOpacity(1.0 - shimmerAmount),
      );
    }

    // Fill cauldron
    for (var y = 11; y < 17; y++) {
      for (var x = 10; x < 22; x++) {
        drawPixel(x, y, PixelTheme.uiDark);
      }
    }

    // Draw potion if cooking
    if (isCooking) {
      final potionColor = PixelTheme.poisonGreen.withOpacity(0.8);
      for (var y = 12; y < 16; y++) {
        for (var x = 10; x < 22; x++) {
          final waveOffset = (x / 32 + bubblePhase) % 1.0;
          final waveAmount = (1 - (2 * (waveOffset - 0.5)).abs()) * 0.1;

          drawPixel(
            x,
            y + (waveAmount * 2).round(),
            potionColor,
          );
        }
      }

      // Add animated bubbles
      final bubblePositions = [
        [13, 12],
        [17, 13],
        [14, 14],
        [19, 12],
        [12, 13],
      ];
      for (var i = 0; i < bubblePositions.length; i++) {
        final bubble = bubblePositions[i];
        final bubbleOffset = ((i / bubblePositions.length) + bubblePhase) % 1.0;
        final y = bubble[1] - (bubbleOffset * 2).round();

        if (y >= 12) {
          drawPixel(
            bubble[0],
            y,
            PixelTheme.boneWhite.withOpacity(0.3 + bubbleOffset * 0.4),
          );
        }
      }
    }

    // Add glow if needed
    if (isGlowing) {
      final glowPaint = Paint()
        ..color = PixelTheme.poisonGreen.withOpacity(0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 12);
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(PixelCauldronPainter oldDelegate) =>
      isGlowing != oldDelegate.isGlowing ||
      isCooking != oldDelegate.isCooking ||
      bubblePhase != oldDelegate.bubblePhase;
}
