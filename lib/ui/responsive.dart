import 'package:flutter/material.dart';

/// Width breakpoints used across the quest UI.
abstract final class Breakpoints {
  static const double sm = 600;
  static const double md = 900;
  static const double lg = 1200;
}

/// Centers content within a max-width container — the standard wrapper
/// for full-bleed screens on web/desktop layouts.
class CenteredContent extends StatelessWidget {
  const CenteredContent({
    super.key,
    required this.child,
    this.maxWidth = 960,
    this.padding = const EdgeInsets.symmetric(horizontal: 32),
  });

  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

/// Reports the active layout size class for the current screen width.
class LayoutSize {
  const LayoutSize._(this.width);

  factory LayoutSize.of(BuildContext context) {
    return LayoutSize._(MediaQuery.sizeOf(context).width);
  }

  final double width;

  bool get isCompact => width < Breakpoints.sm;
  bool get isMedium => width >= Breakpoints.sm && width < Breakpoints.md;
  bool get isExpanded => width >= Breakpoints.md;
  bool get isLarge => width >= Breakpoints.lg;
}
