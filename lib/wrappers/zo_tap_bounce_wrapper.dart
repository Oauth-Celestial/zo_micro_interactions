import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// A wrapper that applies a satisfying spring-based bounce effect when tapped.
/// 
/// Automatically shrinks the [child] slightly when pressed down,
/// and uses a physics-based spring simulation to bounce back when released.
class ZoTapBounceWrapper extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  
  /// The scale the child shrinks to when pressed. Defaults to 0.9.
  final double pressedScale;
  
  /// How "bouncy" the spring is. Lower damping = more bouncy. Defaults to 12.0.
  final double damping;
  
  /// How fast/stiff the spring is. Defaults to 400.0.
  final double stiffness;

  const ZoTapBounceWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.9,
    this.damping = 12.0,
    this.stiffness = 400.0,
  });

  @override
  State<ZoTapBounceWrapper> createState() => _ZoTapBounceWrapperState();
}

class _ZoTapBounceWrapperState extends State<ZoTapBounceWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // 1.0 means fully idle (scale 1.0)
    // 0.0 means fully pressed (scale = widget.pressedScale)
    _controller = AnimationController(
      vsync: this,
      value: 1.0,
      lowerBound: -0.5,
      upperBound: 1.5,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    // Animate towards 0.0 (pressed state) using a fast curve
    _controller.animateTo(
      0.0,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeOut,
    );
  }

  void _onTapUp(TapUpDetails details) {
    // Spring back to 1.0 (idle state)
    _springBack();
  }

  void _onTapCancel() {
    _springBack();
  }

  void _springBack() {
    final spring = SpringDescription(
      mass: 1.0,
      stiffness: widget.stiffness,
      damping: widget.damping,
    );
    final simulation = SpringSimulation(spring, _controller.value, 1.0, 0.0);
    _controller.animateWith(simulation);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Map 0.0 -> pressedScale and 1.0 -> 1.0
          final scale = widget.pressedScale +
              (_controller.value * (1.0 - widget.pressedScale));
          return Transform.scale(
            scale: scale,
            alignment: Alignment.center,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
