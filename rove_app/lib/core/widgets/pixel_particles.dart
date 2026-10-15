import 'dart:math';
import 'package:flutter/material.dart';

class PixelParticles extends StatefulWidget {
  final Color color;
  final int count;
  final double height;

  const PixelParticles({
    super.key,
    required this.color,
    this.count = 24,
    this.height = 200,
  });

  @override
  State<PixelParticles> createState() => _PixelParticlesState();
}

class _PixelParticlesState extends State<PixelParticles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random(42);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.count; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.2 + _random.nextDouble() * 0.4,
          size: 3.0 + (_random.nextInt(3) * 2), // 3, 5, 7 px
          alpha: 150 + _random.nextInt(105),
          isDiamond: _random.nextBool(),
        ),
      );
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            painter: _PixelParticlesPainter(
              particles: _particles,
              progress: _controller.value,
              color: widget.color,
            ),
          );
        },
      ),
    );
  }
}

class _Particle {
  double x;
  double y;
  double speed;
  double size;
  int alpha;
  bool isDiamond;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.size,
    required this.alpha,
    required this.isDiamond,
  });
}

class _PixelParticlesPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Color color;

  _PixelParticlesPainter({
    required this.particles,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (final p in particles) {
      // Stepped Y movement for vintage pixel feel
      final currentY = (p.y - (progress * p.speed)) % 1.0;
      final steppedY = (currentY * 20).floor() / 20.0 * size.height;
      final steppedX = (p.x * 20).floor() / 20.0 * size.width;

      paint.color = color.withAlpha(p.alpha);

      if (p.isDiamond) {
        // Draw 8-bit diamond pixel cross
        canvas.drawRect(
          Rect.fromLTWH(steppedX, steppedY - p.size, p.size, p.size * 3),
          paint,
        );
        canvas.drawRect(
          Rect.fromLTWH(steppedX - p.size, steppedY, p.size * 3, p.size),
          paint,
        );
      } else {
        // Crisp pixel square
        canvas.drawRect(
          Rect.fromLTWH(steppedX, steppedY, p.size, p.size),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PixelParticlesPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
