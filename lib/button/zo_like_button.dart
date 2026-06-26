import 'package:flutter/material.dart';
import '../utils/zo_bounce_widget.dart';
import '../utils/zo_sparkle_burst.dart';

/// A polished like button that scales down on press and bursts with
/// particles when toggled on.
class ZoLikeButton extends StatefulWidget {
  final bool isLiked;
  final ValueChanged<bool> onToggle;
  final double size;
  final Color likedColor;
  final Color unlikedColor;
  final IconData likedIcon;
  final IconData unlikedIcon;

  const ZoLikeButton({
    super.key,
    required this.isLiked,
    required this.onToggle,
    this.size = 32.0,
    this.likedColor = const Color(0xFFE91E63),
    this.unlikedColor = const Color(0xFF9E9E9E),
    this.likedIcon = Icons.favorite,
    this.unlikedIcon = Icons.favorite_border,
  });

  @override
  State<ZoLikeButton> createState() => _ZoLikeButtonState();
}

class _ZoLikeButtonState extends State<ZoLikeButton> {
  void _handleTap(AnimationController burstController) {
    widget.onToggle(!widget.isLiked);
    if (!widget.isLiked) {
      // It is becoming liked, trigger burst
      burstController.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SparkleBurstWrapper(
      size: Size(widget.size * 3, widget.size * 3),
      sparkleColor: widget.likedColor,
      builder: (context, controller) {
        return ZoBounceWidget(
          onTap: () => _handleTap(controller),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              widget.isLiked ? widget.likedIcon : widget.unlikedIcon,
              key: ValueKey(widget.isLiked),
              color: widget.isLiked ? widget.likedColor : widget.unlikedColor,
              size: widget.size,
            ),
          ),
        );
      },
    );
  }
}
