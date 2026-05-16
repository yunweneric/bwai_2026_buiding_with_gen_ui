import 'package:flutter/material.dart';

/// Subtle lift + scale on hover for clickable cards on web/desktop.
class HoverLift extends StatefulWidget {
  const HoverLift({
    super.key,
    required this.child,
    this.scale = 1.025,
    this.lift = 4,
  });

  final Widget child;
  final double scale;
  final double lift;

  @override
  State<HoverLift> createState() => _HoverLiftState();
}

class _HoverLiftState extends State<HoverLift> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _hovered ? -widget.lift : 0.0, 0.0, 1.0)
          ..scaleByDouble(
            _hovered ? widget.scale : 1.0,
            _hovered ? widget.scale : 1.0,
            1.0,
            1.0,
          ),
        transformAlignment: Alignment.center,
        child: widget.child,
      ),
    );
  }
}
