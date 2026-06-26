import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A wrapper that applies a continuous, slight random-looking wobble to the [child].
/// 
/// Mimics the iOS "edit home screen" jiggle effect.
class ZoJiggleWrapper extends StatefulWidget {
  final Widget child;
  
  /// Whether the jiggle animation is currently active.
  final bool isJiggling;
  
  /// The maximum rotation angle in degrees. Defaults to 2.0.
  final double maxRotation;

  const ZoJiggleWrapper({
    super.key,
    required this.child,
    this.isJiggling = true,
    this.maxRotation = 2.0,
  });

  @override
  State<ZoJiggleWrapper> createState() => _ZoJiggleWrapperState();
}

class _ZoJiggleWrapperState extends State<ZoJiggleWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    if (widget.isJiggling) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ZoJiggleWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isJiggling && !oldWidget.isJiggling) {
      _controller.repeat(reverse: true);
    } else if (!widget.isJiggling && oldWidget.isJiggling) {
      _controller.animateTo(0.5, duration: const Duration(milliseconds: 150));
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
        // Map 0.0 -> 1.0 to -maxRotation -> +maxRotation
        final rotation = (widget.maxRotation * 2 * _controller.value) - widget.maxRotation;
        return Transform.rotate(
          angle: rotation * (math.pi / 180),
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
