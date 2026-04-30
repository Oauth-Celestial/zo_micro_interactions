import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Tactile press using a spring: dips on touch, settles with a slight bounce.
///
/// Same layout contract as [ZoMorphButton]: fixed [width]/[height], [decoration],
/// optional centered [child].
class ZoSpringButton extends StatefulWidget {
  final double width;
  final double height;
  final BoxDecoration decoration;
  final VoidCallback? onTap;
  final Widget? child;

  /// Scale at full press (before release). Closer to `1` feels subtler.
  final double pressedScale;

  final SpringDescription spring;

  const ZoSpringButton({
    super.key,
    required this.width,
    required this.height,
    required this.decoration,
    this.onTap,
    this.child,
    this.pressedScale = 0.94,
    this.spring = const SpringDescription(mass: 0.45, stiffness: 520, damping: 18),
  });

  @override
  State<ZoSpringButton> createState() => _ZoSpringButtonState();
}

class _ZoSpringButtonState extends State<ZoSpringButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  SpringDescription get _spring => widget.spring;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1);
  }

  double get _scale =>
      lerpDouble(widget.pressedScale, 1.0, _controller.value.clamp(0.0, 1.0))!;

  void _press() {
    _controller.animateWith(
      SpringSimulation(_spring, _controller.value, 0.0, 0),
    );
  }

  void _release() {
    _controller.animateWith(
      SpringSimulation(_spring, _controller.value, 1.0, 0.0),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content =
        widget.child ?? const SizedBox(height: kMinInteractiveDimension);

    return GestureDetector(
      onTapDown: (_) => _press(),
      onTapUp: (_) => _release(),
      onTapCancel: _release,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, child) {
          return Transform.scale(scale: _scale, child: child);
        },
        child: Container(
          width: widget.width,
          height: widget.height,
          alignment: Alignment.center,
          decoration: widget.decoration,
          child: Center(child: content),
        ),
      ),
    );
  }
}
