import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';

class PixelPotionIcon extends StatelessWidget {
  final double size;
  final Color color;

  const PixelPotionIcon({
    super.key,
    this.size = 48,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PixelPotionPainter(color: color),
    );
  }
}

class PixelPotionPainter extends CustomPainter {
  final Color color;

  PixelPotionPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 16;
    final paint = Paint();

    void drawPixel(int x, int y, Color color) {
      paint.color = color;
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint,
      );
    }

    // Draw bottle
    final bottlePixels = [
      // Neck
      [7, 4], [8, 4], [9, 4],
      [7, 5], [8, 5], [9, 5],
      // Cork
      [7, 3], [8, 3], [9, 3],
      // Body
      [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6], [11, 6],
      [4, 7], [5, 7], [6, 7], [7, 7], [8, 7], [9, 7], [10, 7], [11, 7], [12, 7],
      [4, 8], [5, 8], [6, 8], [7, 8], [8, 8], [9, 8], [10, 8], [11, 8], [12, 8],
      [4, 9], [5, 9], [6, 9], [7, 9], [8, 9], [9, 9], [10, 9], [11, 9], [12, 9],
      [4, 10], [5, 10], [6, 10], [7, 10], [8, 10], [9, 10], [10, 10], [11, 10],
      [12, 10],
      [5, 11], [6, 11], [7, 11], [8, 11], [9, 11], [10, 11], [11, 11],
    ];

    // Draw bottle outline
    for (final pixel in bottlePixels) {
      drawPixel(pixel[0], pixel[1], PixelTheme.uiAccent);
    }

    // Draw liquid
    final liquidPixels = [
      [5, 8],
      [6, 8],
      [7, 8],
      [8, 8],
      [9, 8],
      [10, 8],
      [11, 8],
      [5, 9],
      [6, 9],
      [7, 9],
      [8, 9],
      [9, 9],
      [10, 9],
      [11, 9],
      [5, 10],
      [6, 10],
      [7, 10],
      [8, 10],
      [9, 10],
      [10, 10],
      [11, 10],
    ];

    for (final pixel in liquidPixels) {
      drawPixel(pixel[0], pixel[1], color);
    }

    // Draw highlights
    final highlightPixels = [
      [6, 7],
      [7, 7],
    ];

    for (final pixel in highlightPixels) {
      drawPixel(pixel[0], pixel[1], Colors.white.withOpacity(0.3));
    }
  }

  @override
  bool shouldRepaint(covariant PixelPotionPainter oldDelegate) =>
      color != oldDelegate.color;
}

class PixelBookIcon extends StatelessWidget {
  final double size;
  final Color color;

  const PixelBookIcon({
    super.key,
    this.size = 32,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PixelBookPainter(color: color),
    );
  }
}

class PixelBookPainter extends CustomPainter {
  final Color color;

  PixelBookPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 16;
    final paint = Paint();

    void drawPixel(int x, int y, Color color) {
      paint.color = color;
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint,
      );
    }

    // Draw book cover
    final coverPixels = [
      [4, 4],
      [5, 4],
      [6, 4],
      [7, 4],
      [8, 4],
      [9, 4],
      [10, 4],
      [11, 4],
      [12, 4],
      [4, 5],
      [5, 5],
      [6, 5],
      [7, 5],
      [8, 5],
      [9, 5],
      [10, 5],
      [11, 5],
      [12, 5],
      [4, 6],
      [5, 6],
      [6, 6],
      [7, 6],
      [8, 6],
      [9, 6],
      [10, 6],
      [11, 6],
      [12, 6],
      [4, 7],
      [5, 7],
      [6, 7],
      [7, 7],
      [8, 7],
      [9, 7],
      [10, 7],
      [11, 7],
      [12, 7],
      [4, 8],
      [5, 8],
      [6, 8],
      [7, 8],
      [8, 8],
      [9, 8],
      [10, 8],
      [11, 8],
      [12, 8],
      [4, 9],
      [5, 9],
      [6, 9],
      [7, 9],
      [8, 9],
      [9, 9],
      [10, 9],
      [11, 9],
      [12, 9],
      [4, 10],
      [5, 10],
      [6, 10],
      [7, 10],
      [8, 10],
      [9, 10],
      [10, 10],
      [11, 10],
      [12, 10],
      [4, 11],
      [5, 11],
      [6, 11],
      [7, 11],
      [8, 11],
      [9, 11],
      [10, 11],
      [11, 11],
      [12, 11],
    ];

    // Draw book outline
    for (final pixel in coverPixels) {
      drawPixel(pixel[0], pixel[1], color);
    }

    // Draw pages
    final pagePixels = [
      [5, 5],
      [6, 5],
      [7, 5],
      [8, 5],
      [9, 5],
      [10, 5],
      [11, 5],
      [5, 7],
      [6, 7],
      [7, 7],
      [8, 7],
      [9, 7],
      [10, 7],
      [11, 7],
      [5, 9],
      [6, 9],
      [7, 9],
      [8, 9],
      [9, 9],
      [10, 9],
      [11, 9],
    ];

    for (final pixel in pagePixels) {
      drawPixel(pixel[0], pixel[1], Colors.white.withOpacity(0.8));
    }

    // Draw binding
    final bindingPixels = [
      [8, 4],
      [8, 5],
      [8, 6],
      [8, 7],
      [8, 8],
      [8, 9],
      [8, 10],
      [8, 11],
    ];

    for (final pixel in bindingPixels) {
      drawPixel(pixel[0], pixel[1], color.darker);
    }
  }

  @override
  bool shouldRepaint(covariant PixelBookPainter oldDelegate) =>
      color != oldDelegate.color;
}

class PixelInventoryIcon extends StatelessWidget {
  final double size;
  final Color color;

  const PixelInventoryIcon({
    super.key,
    this.size = 32,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: PixelInventoryPainter(color: color),
    );
  }
}

class PixelInventoryPainter extends CustomPainter {
  final Color color;

  PixelInventoryPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final pixelSize = size.width / 16;
    final paint = Paint();

    void drawPixel(int x, int y, Color color) {
      paint.color = color;
      canvas.drawRect(
        Rect.fromLTWH(x * pixelSize, y * pixelSize, pixelSize, pixelSize),
        paint,
      );
    }

    // Draw chest
    final chestPixels = [
      // Lid
      [4, 4], [5, 4], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4], [11, 4], [12, 4],
      [4, 5], [5, 5], [6, 5], [7, 5], [8, 5], [9, 5], [10, 5], [11, 5], [12, 5],
      // Body
      [4, 6], [5, 6], [6, 6], [7, 6], [8, 6], [9, 6], [10, 6], [11, 6], [12, 6],
      [4, 7], [5, 7], [6, 7], [7, 7], [8, 7], [9, 7], [10, 7], [11, 7], [12, 7],
      [4, 8], [5, 8], [6, 8], [7, 8], [8, 8], [9, 8], [10, 8], [11, 8], [12, 8],
      [4, 9], [5, 9], [6, 9], [7, 9], [8, 9], [9, 9], [10, 9], [11, 9], [12, 9],
      [4, 10], [5, 10], [6, 10], [7, 10], [8, 10], [9, 10], [10, 10], [11, 10],
      [12, 10],
    ];

    // Draw chest outline
    for (final pixel in chestPixels) {
      drawPixel(pixel[0], pixel[1], color);
    }

    // Draw lock
    final lockPixels = [
      [7, 5],
      [8, 5],
      [9, 5],
      [7, 6],
      [8, 6],
      [9, 6],
    ];

    for (final pixel in lockPixels) {
      drawPixel(pixel[0], pixel[1], color.darker);
    }

    // Draw highlights
    final highlightPixels = [
      [5, 7],
      [6, 7],
      [7, 7],
    ];

    for (final pixel in highlightPixels) {
      drawPixel(pixel[0], pixel[1], Colors.white.withOpacity(0.3));
    }
  }

  @override
  bool shouldRepaint(covariant PixelInventoryPainter oldDelegate) =>
      color != oldDelegate.color;
}

extension ColorExtension on Color {
  Color get darker => Color.fromARGB(
        alpha,
        (red * 0.7).round(),
        (green * 0.7).round(),
        (blue * 0.7).round(),
      );
}
