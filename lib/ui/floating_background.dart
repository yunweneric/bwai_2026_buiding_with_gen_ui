import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intro_to_genui/ui/game_theme.dart';

/// Full-bleed colored gradient with slowly drifting colored blobs.
///
/// Used as the page background on every screen.
class FloatingBackground extends StatefulWidget {
  const FloatingBackground({super.key, required this.child});

  final Widget child;

  @override
  State<FloatingBackground> createState() => _FloatingBackgroundState();
}

class _FloatingBackgroundState extends State<FloatingBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 30),
  )..repeat();

  final _blobs = _buildBlobs();

  static List<_Blob> _buildBlobs() {
    final r = Random(7);
    final palette = <Color>[
      GameColors.primary,
      GameColors.violet,
      GameColors.rose,
      GameColors.sky,
      GameColors.accent,
      GameColors.mint,
    ];
    return List.generate(6, (i) {
      return _Blob(
        seed: r.nextDouble() * pi * 2,
        baseX: r.nextDouble(),
        baseY: r.nextDouble(),
        radiusFraction: 0.18 + r.nextDouble() * 0.18,
        speed: 0.4 + r.nextDouble() * 0.6,
        color: palette[i % palette.length],
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFEEF2FF),
                Color(0xFFF5F3FF),
                Color(0xFFFCE7F3),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _BlobsPainter(blobs: _blobs, t: _controller.value),
                );
              },
            ),
          ),
        ),
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

class _Blob {
  _Blob({
    required this.seed,
    required this.baseX,
    required this.baseY,
    required this.radiusFraction,
    required this.speed,
    required this.color,
  });

  final double seed;
  final double baseX;
  final double baseY;
  final double radiusFraction;
  final double speed;
  final Color color;
}

class _BlobsPainter extends CustomPainter {
  _BlobsPainter({required this.blobs, required this.t});

  final List<_Blob> blobs;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final shortest = size.shortestSide;
    for (final b in blobs) {
      final phase = b.seed + t * b.speed * pi * 2;
      final x = (b.baseX + sin(phase) * 0.08) * size.width;
      final y = (b.baseY + cos(phase * 1.3) * 0.08) * size.height;
      final radius = shortest * b.radiusFraction;

      final paint = Paint()
        ..shader = RadialGradient(
          colors: [
            b.color.withValues(alpha: 0.28),
            b.color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: Offset(x, y), radius: radius))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BlobsPainter old) => old.t != t;
}
