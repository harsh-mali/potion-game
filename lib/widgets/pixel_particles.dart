import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../utils/theme_colors.dart';

class PixelParticle {
  Offset position;
  Offset velocity;
  double size;
  Color color;
  double life;
  double maxLife;

  PixelParticle({
    required this.position,
    required this.velocity,
    required this.size,
    required this.color,
    required this.maxLife,
  }) : life = maxLife;

  bool update(double dt) {
    position += velocity * dt;
    life -= dt;
    return life > 0;
  }
}

class PixelParticleSystem extends StatefulWidget {
  final Widget child;
  final ParticleType type;

  const PixelParticleSystem({
    super.key,
    required this.child,
    this.type = ParticleType.magic,
  });

  @override
  State<PixelParticleSystem> createState() => _PixelParticleSystemState();
}

enum ParticleType {
  magic,
  fire,
  sparkle,
}

class _PixelParticleSystemState extends State<PixelParticleSystem>
    with SingleTickerProviderStateMixin {
  final List<PixelParticle> _particles = [];
  final math.Random _random = math.Random();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _spawnParticles(Size size) {
    if (_particles.length > 100) return;

    switch (widget.type) {
      case ParticleType.magic:
        _spawnMagicParticles(size);
        break;
      case ParticleType.fire:
        _spawnFireParticles(size);
        break;
      case ParticleType.sparkle:
        _spawnSparkleParticles(size);
        break;
    }
  }

  void _spawnMagicParticles(Size size) {
    final colors = [
      PixelTheme.poisonGreen,
      PixelTheme.lightPurple,
      PixelTheme.candleYellow,
    ];

    for (var i = 0; i < 2; i++) {
      final x = _random.nextDouble() * size.width;
      final y = size.height;
      _particles.add(
        PixelParticle(
          position: Offset(x, y),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 50,
            -_random.nextDouble() * 100 - 50,
          ),
          size: _random.nextDouble() * 4 + 2,
          color: colors[_random.nextInt(colors.length)],
          maxLife: _random.nextDouble() * 2 + 1,
        ),
      );
    }
  }

  void _spawnFireParticles(Size size) {
    final colors = [
      PixelTheme.bloodRed,
      PixelTheme.candleYellow,
      Colors.orange,
    ];

    for (var i = 0; i < 3; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      _particles.add(
        PixelParticle(
          position: Offset(x, y),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 30,
            -_random.nextDouble() * 60 - 30,
          ),
          size: _random.nextDouble() * 3 + 1,
          color: colors[_random.nextInt(colors.length)],
          maxLife: _random.nextDouble() + 0.5,
        ),
      );
    }
  }

  void _spawnSparkleParticles(Size size) {
    for (var i = 0; i < 1; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;
      _particles.add(
        PixelParticle(
          position: Offset(x, y),
          velocity: Offset.zero,
          size: _random.nextDouble() * 2 + 1,
          color: PixelTheme.candleYellow.withOpacity(0.8),
          maxLife: _random.nextDouble() * 0.5 + 0.2,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          foregroundPainter: ParticlePainter(
            particles: _particles,
            onPaint: (size) {
              _spawnParticles(size);
              _particles.removeWhere((p) => !p.update(0.016));
            },
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class ParticlePainter extends CustomPainter {
  final List<PixelParticle> particles;
  final void Function(Size size) onPaint;

  ParticlePainter({
    required this.particles,
    required this.onPaint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    onPaint(size);

    for (final particle in particles) {
      final paint = Paint()
        ..color = particle.color.withOpacity(particle.life / particle.maxLife);

      canvas.drawRect(
        Rect.fromCenter(
          center: particle.position,
          width: particle.size,
          height: particle.size,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) => true;
}
