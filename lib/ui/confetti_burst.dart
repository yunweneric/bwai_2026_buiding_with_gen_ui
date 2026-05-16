import 'dart:math';
import 'package:flutter/material.dart';

/// Lightweight, self-contained confetti burst — no third-party deps.
///
/// Emits [particleCount] paper pieces from the top-center, with random
/// horizontal velocity and gravity, then settles them as they fall and
/// fade off-screen.
class ConfettiBurst extends StatefulWidget {
  const ConfettiBurst({
    super.key,
    this.particleCount = 90,
    this.duration = const Duration(milliseconds: 3500),
    this.colors = const [
      Color(0xFFF59E0B),
      Color(0xFF4F46E5),
      Color(0xFF34D399),
      Color(0xFFF43F5E),
      Color(0xFF38BDF8),
      Color(0xFF8B5CF6),
    ],
  });

  final int particleCount;
  final Duration duration;
  final List<Color> colors;

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  late final List<_Particle> _particles;

  @override
  void initState() {
    super.initState();
    final random = Random();
    _particles = List.generate(widget.particleCount, (i) {
      return _Particle(
        startXFraction: 0.4 + random.nextDouble() * 0.2,
        velocityX: (random.nextDouble() - 0.5) * 2.4,
        velocityY: -0.5 - random.nextDouble() * 1.6,
        rotationSpeed: (random.nextDouble() - 0.5) * 12,
        size: 6 + random.nextDouble() * 8,
        color: widget.colors[random.nextInt(widget.colors.length)],
        shape: _Shape.values[random.nextInt(_Shape.values.length)],
        wobblePhase: random.nextDouble() * pi * 2,
        wobbleAmount: 0.3 + random.nextDouble() * 0.5,
        delay: random.nextDouble() * 0.15,
      );
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(
              particles: _particles,
              t: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

enum _Shape { rect, circle, strip }

class _Particle {
  _Particle({
    required this.startXFraction,
    required this.velocityX,
    required this.velocityY,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.shape,
    required this.wobblePhase,
    required this.wobbleAmount,
    required this.delay,
  });

  final double startXFraction;
  final double velocityX;
  final double velocityY;
  final double rotationSpeed;
  final double size;
  final Color color;
  final _Shape shape;
  final double wobblePhase;
  final double wobbleAmount;
  final double delay;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter({required this.particles, required this.t});

  final List<_Particle> particles;
  final double t;

  static const double _gravity = 1.4;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final p in particles) {
      final localT = (t - p.delay).clamp(0.0, 1.0);
      if (localT <= 0) continue;

      final dx = p.velocityX * localT + sin(p.wobblePhase + localT * 6) * p.wobbleAmount * 0.05;
      final dy = p.velocityY * localT + 0.5 * _gravity * localT * localT;

      final x = (p.startXFraction + dx) * size.width;
      final y = size.height * 0.1 + dy * size.height;

      if (y > size.height + p.size) continue;

      final fadeOut = 1 - ((localT - 0.7).clamp(0.0, 1.0) / 0.3);
      paint.color = p.color.withValues(alpha: fadeOut);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.rotationSpeed * localT);

      switch (p.shape) {
        case _Shape.rect:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
              const Radius.circular(1.5),
            ),
            paint,
          );
        case _Shape.circle:
          canvas.drawCircle(Offset.zero, p.size * 0.35, paint);
        case _Shape.strip:
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: p.size * 1.4, height: p.size * 0.25),
              const Radius.circular(1),
            ),
            paint,
          );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => old.t != t;
}
