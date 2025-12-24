import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

class ZoBounceWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const ZoBounceWidget({super.key, required this.child, this.onTap});

  @override
  State<ZoBounceWidget> createState() => _ZoBounceWidgetState();
}

class _ZoBounceWidgetState extends State<ZoBounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final SpringDescription _spring = SpringDescription(
    mass: 0.5,
    stiffness: 600,
    damping: 15,
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, value: 1);
  }

  double get _scale => lerpDouble(0.85, 1.0, _controller.value)!;

  void _press() {
    _controller.animateWith(
      SpringSimulation(_spring, _controller.value, 0.0, 0),
    );
  }

  void _release() {
    _controller.animateWith(
      SpringSimulation(_spring, _controller.value, 1, 0.0),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
