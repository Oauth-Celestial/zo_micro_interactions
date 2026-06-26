import 'package:flutter/material.dart';

/// A highly polished animated switch with smooth morphing and optional icon.
class ZoAnimatedSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final Color thumbColor;
  final double width;
  final double height;
  final IconData? activeIcon;
  final IconData? inactiveIcon;

  const ZoAnimatedSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = const Color(0xFF4CAF50),
    this.inactiveColor = const Color(0xFFE0E0E0),
    this.thumbColor = Colors.white,
    this.width = 60.0,
    this.height = 32.0,
    this.activeIcon,
    this.inactiveIcon,
  });

  @override
  State<ZoAnimatedSwitch> createState() => _ZoAnimatedSwitchState();
}

class _ZoAnimatedSwitchState extends State<ZoAnimatedSwitch>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _alignmentAnimation;
  late Animation<Color?> _trackColorAnimation;
  late Animation<double> _thumbScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _setupAnimations();

    if (widget.value) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(ZoAnimatedSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    if (oldWidget.activeColor != widget.activeColor ||
        oldWidget.inactiveColor != widget.inactiveColor) {
      _setupAnimations();
    }
  }

  void _setupAnimations() {
    _alignmentAnimation = AlignmentTween(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
      reverseCurve: Curves.easeOutCubic,
    ));

    _trackColorAnimation = ColorTween(
      begin: widget.inactiveColor,
      end: widget.activeColor,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _thumbScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 50),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final padding = widget.height * 0.1;
          final thumbSize = widget.height - (padding * 2);

          return Container(
            width: widget.width,
            height: widget.height,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.height / 2),
              color: _trackColorAnimation.value,
            ),
            child: Align(
              alignment: _alignmentAnimation.value,
              child: Transform.scale(
                scale: _thumbScaleAnimation.value,
                child: Container(
                  width: thumbSize,
                  height: thumbSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.thumbColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      widget.value
                          ? widget.activeIcon
                          : widget.inactiveIcon,
                      size: thumbSize * 0.6,
                      color: _trackColorAnimation.value,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
