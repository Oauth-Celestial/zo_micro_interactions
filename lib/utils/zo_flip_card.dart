import 'dart:math';

import 'package:flutter/material.dart';

/// A 3D flip card widget that reveals its back side upon interaction.
/// Supports horizontal or vertical flipping.
class ZoFlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final Duration duration;
  final Axis direction;

  /// Whether the card flips automatically when tapped. If false, you must
  /// use the controller/key to flip it manually.
  final bool flipOnTouch;

  const ZoFlipCard({
    super.key,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 500),
    this.direction = Axis.horizontal,
    this.flipOnTouch = true,
  });

  @override
  State<ZoFlipCard> createState() => ZoFlipCardState();
}

class ZoFlipCardState extends State<ZoFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Manually triggers the flip animation.
  void toggleCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.flipOnTouch ? toggleCard : null,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final angle = _controller.value * pi;
          final isFrontVisible = angle < (pi / 2);

          final transform = Matrix4.identity()
            ..setEntry(3, 2, 0.001) // perspective
            ..rotateX(widget.direction == Axis.vertical ? angle : 0)
            ..rotateY(widget.direction == Axis.horizontal ? angle : 0);

          Widget content;
          if (isFrontVisible) {
            content = widget.front;
          } else {
            // Re-flip the back so it isn't mirrored
            final backTransform = Matrix4.identity()
              ..rotateX(widget.direction == Axis.vertical ? pi : 0)
              ..rotateY(widget.direction == Axis.horizontal ? pi : 0);
            content = Transform(
              alignment: Alignment.center,
              transform: backTransform,
              child: widget.back,
            );
          }

          return Transform(
            alignment: Alignment.center,
            transform: transform,
            child: content,
          );
        },
      ),
    );
  }
}
