import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme_colors.dart';
import '../widgets/pixel_background.dart';

class LoadingScreen extends StatefulWidget {
  final VoidCallback onLoadingComplete;

  const LoadingScreen({
    super.key,
    required this.onLoadingComplete,
  });

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fillAnimation;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _scaleAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fillAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );

    _bubbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOut),
      ),
    );

    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    _controller.repeat();
    Timer(const Duration(seconds: 3), () {
      setState(() => _isLoading = false);
      _controller.forward(from: _controller.value).then((_) {
        widget.onLoadingComplete();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const PixelBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: CustomPaint(
                        size: const Size(120, 160),
                        painter: PotionLoadingPainter(
                          fillLevel: _fillAnimation.value,
                          bubblePhase: _bubbleAnimation.value,
                          potionColor: PixelTheme.poisonGreen,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),
                Text(
                  'Brewing Magic...',
                  style: GoogleFonts.cinzelDecorative(
                    fontSize: 48,
                    color: PixelTheme.candleYellow,
                    shadows: [
                      Shadow(
                        color: PixelTheme.bloodRed,
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (_isLoading) ...[
                  SizedBox(
                    width: 200,
                    child: LinearProgressIndicator(
                      backgroundColor: PixelTheme.uiDark.withOpacity(0.3),
                      color: PixelTheme.poisonGreen,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PotionLoadingPainter extends CustomPainter {
  final double fillLevel;
  final double bubblePhase;
  final Color potionColor;

  PotionLoadingPainter({
    required this.fillLevel,
    required this.bubblePhase,
    required this.potionColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bottlePath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.2)
      ..lineTo(size.width * 0.7, size.height * 0.2)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width * 0.8, size.height * 0.9)
      ..lineTo(size.width * 0.2, size.height * 0.9)
      ..lineTo(size.width * 0.2, size.height * 0.3)
      ..close();

    final neckPath = Path()
      ..moveTo(size.width * 0.4, 0)
      ..lineTo(size.width * 0.6, 0)
      ..lineTo(size.width * 0.6, size.height * 0.2)
      ..lineTo(size.width * 0.4, size.height * 0.2)
      ..close();

    // Create a combined path for clipping
    final combinedPath = Path()
      ..addPath(bottlePath, Offset.zero)
      ..addPath(neckPath, Offset.zero);

    // Draw liquid with clipping
    if (fillLevel > 0) {
      canvas.save();
      canvas.clipPath(combinedPath);

      final liquidGradient = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          potionColor.withOpacity(0.7),
          potionColor,
        ],
      );

      final liquidRect = Rect.fromLTWH(
        0,
        size.height * (1.0 - fillLevel),
        size.width,
        size.height * fillLevel,
      );

      final liquidPaint = Paint()
        ..shader = liquidGradient.createShader(liquidRect)
        ..style = PaintingStyle.fill;

      canvas.drawRect(liquidRect, liquidPaint);

      // Draw bubbles within the clipped area
      if (bubblePhase > 0) {
        final bubblePaint = Paint()
          ..color = potionColor.withOpacity(0.6)
          ..style = PaintingStyle.fill;

        final random = DateTime.now().millisecondsSinceEpoch;
        for (var i = 0; i < 5; i++) {
          final bubblePhaseOffset = (bubblePhase + i * 0.2) % 1.0;
          final bubbleX = size.width * (0.3 + (random + i * 50) % 3 * 0.15);
          final maxBubbleY = size.height * (1.0 - fillLevel);
          final bubbleY = size.height * 0.9 -
              (size.height * 0.9 - maxBubbleY) * bubblePhaseOffset;
          final bubbleSize = 4.0 + (random + i) % 3 * 2.0;

          canvas.drawCircle(
            Offset(bubbleX, bubbleY),
            bubbleSize,
            bubblePaint,
          );
        }
      }

      canvas.restore();
    }

    // Draw bottle outline
    final outlinePaint = Paint()
      ..color = PixelTheme.uiAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawPath(bottlePath, outlinePaint);
    canvas.drawPath(neckPath, outlinePaint);

    // Add shine effect
    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final shinePath = Path()
      ..moveTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.4, size.height * 0.4);

    canvas.drawPath(shinePath, shinePaint);
  }

  @override
  bool shouldRepaint(PotionLoadingPainter oldDelegate) {
    return oldDelegate.fillLevel != fillLevel ||
        oldDelegate.bubblePhase != bubblePhase ||
        oldDelegate.potionColor != potionColor;
  }
}
