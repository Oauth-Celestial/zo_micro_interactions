import 'package:flutter/material.dart';

/// A wrapper that smoothly pulses the [child] by scaling it up and down.
/// 
/// Excellent for calling user attention to specific buttons, badges, or icons.
class ZoPulseWrapper extends StatefulWidget {
  final Widget child;
  
  /// Whether the pulsing animation is active.
  final bool isPulsing;
  
  /// The maximum scale the child reaches during a pulse. Defaults to 1.1.
  final double pulseScale;
  
  /// Duration of one complete pulse cycle (up and down). Defaults to 1200ms.
  final Duration duration;

  const ZoPulseWrapper({
    super.key,
    required this.child,
    this.isPulsing = true,
    this.pulseScale = 1.1,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<ZoPulseWrapper> createState() => _ZoPulseWrapperState();
}

class _ZoPulseWrapperState extends State<ZoPulseWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    
    _setupAnimation();

    if (widget.isPulsing) {
      _controller.repeat(reverse: true);
    }
  }

  void _setupAnimation() {
    _scaleAnimation = Tween<double>(begin: 1.0, end: widget.pulseScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant ZoPulseWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.pulseScale != widget.pulseScale || oldWidget.duration != widget.duration) {
      _controller.duration = widget.duration;
      _setupAnimation();
    }

    if (widget.isPulsing && !oldWidget.isPulsing) {
      _controller.repeat(reverse: true);
    } else if (!widget.isPulsing && oldWidget.isPulsing) {
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
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
