import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A wrapper that rapidly wiggles/shakes the [child] horizontally.
/// Useful for indicating errors (e.g. wrong password).
class ZoShakeWrapper extends StatefulWidget {
  final Widget child;
  
  /// If true, the child will shake continuously.
  /// If false, it will sit still. Toggling this triggers a new shake.
  final bool shake;
  
  /// The distance (in pixels) the child moves left and right. Defaults to 8.0.
  final double offset;
  
  /// How many full shakes (left-right cycles) per second. Defaults to 4.
  final int shakesPerSecond;

  const ZoShakeWrapper({
    super.key,
    required this.child,
    required this.shake,
    this.offset = 8.0,
    this.shakesPerSecond = 4,
  });

  @override
  State<ZoShakeWrapper> createState() => _ZoShakeWrapperState();
}

class _ZoShakeWrapperState extends State<ZoShakeWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    if (widget.shake) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ZoShakeWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.shake && !oldWidget.shake) {
      // Trigger a shake
      _controller.forward(from: 0.0).then((_) {
        if (widget.shake) _controller.repeat();
      });
    } else if (!widget.shake && oldWidget.shake) {
      // Stop shaking and return to center
      _controller.animateTo(0.0, duration: const Duration(milliseconds: 200));
    }
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
        final sineValue = math.sin(_controller.value * widget.shakesPerSecond * math.pi * 2);
        // decay the shake over the animation duration if it's a single play (not repeating)
        // Wait, if it's repeating we just use sineValue.
        final dx = sineValue * widget.offset;
        return Transform.translate(
          offset: Offset(dx, 0.0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
