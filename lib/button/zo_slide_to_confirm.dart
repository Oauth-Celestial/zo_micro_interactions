import 'package:flutter/material.dart';

/// A sleek slide-to-confirm button for high-friction actions.
/// Provides smooth drag physics and visual feedback when activated.
class ZoSlideToConfirm extends StatefulWidget {
  final double height;
  final double width;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color iconColor;
  final String text;
  final TextStyle? textStyle;
  final IconData icon;
  final VoidCallback onConfirm;
  final double borderRadius;
  final double elevation;

  const ZoSlideToConfirm({
    super.key,
    required this.onConfirm,
    this.height = 60,
    this.width = double.infinity,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.foregroundColor = Colors.black,
    this.iconColor = Colors.white,
    this.text = 'Slide to confirm',
    this.textStyle,
    this.icon = Icons.arrow_forward_ios_rounded,
    this.borderRadius = 30.0,
    this.elevation = 2.0,
  });

  @override
  State<ZoSlideToConfirm> createState() => _ZoSlideToConfirmState();
}

class _ZoSlideToConfirmState extends State<ZoSlideToConfirm>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragPosition = 0.0;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      setState(() {
        _dragPosition = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxDrag) {
    if (_confirmed) return;
    setState(() {
      _dragPosition += details.delta.dx;
      if (_dragPosition < 0) _dragPosition = 0;
      if (_dragPosition > maxDrag) _dragPosition = maxDrag;
    });
  }

  void _onDragEnd(DragEndDetails details, double maxDrag) {
    if (_confirmed) return;
    if (_dragPosition > maxDrag * 0.8) {
      // Confirmed
      setState(() {
        _confirmed = true;
      });
      _controller.value = _dragPosition;
      _controller.animateTo(maxDrag).then((_) {
        widget.onConfirm();
      });
    } else {
      // Snap back
      _controller.value = _dragPosition;
      _controller.animateTo(0.0, curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double effectiveWidth =
            widget.width == double.infinity ? constraints.maxWidth : widget.width;
        final double maxDrag = effectiveWidth - widget.height;

        return Container(
          width: effectiveWidth,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            boxShadow: [
              if (widget.elevation > 0)
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: widget.elevation,
                  offset: Offset(0, widget.elevation / 2),
                )
            ],
          ),
          child: Stack(
            children: [
              // Shimmer or solid text
              Center(
                child: Opacity(
                  opacity: (1 - (_dragPosition / maxDrag)).clamp(0.0, 1.0),
                  child: Text(
                    widget.text,
                    style: widget.textStyle ??
                        TextStyle(
                          color: widget.foregroundColor.withOpacity(0.7),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              // Draggable knob
              Positioned(
                left: _dragPosition,
                top: 0,
                bottom: 0,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) =>
                      _onDragUpdate(details, maxDrag),
                  onHorizontalDragEnd: (details) =>
                      _onDragEnd(details, maxDrag),
                  child: Container(
                    width: widget.height, // make it perfectly square/round
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: widget.foregroundColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                    ),
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, animation) {
                          return ScaleTransition(
                            scale: CurvedAnimation(
                              parent: animation,
                              curve: Curves.elasticOut,
                            ),
                            child: child,
                          );
                        },
                        child: _confirmed
                            ? Icon(
                                Icons.check_rounded,
                                key: const ValueKey('check'),
                                color: widget.iconColor,
                                size: widget.height * 0.5,
                              )
                            : Icon(
                                widget.icon,
                                key: const ValueKey('arrow'),
                                color: widget.iconColor,
                                size: widget.height * 0.4,
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
