import 'dart:math';

import 'package:flutter/material.dart';

/// A pill-shaped button with a subtle animated border morph and press scale.
///
/// Pass [width], [height], [decoration], and [onTap].
///
/// [BoxDecoration.borderRadius] is used only to size the morphing corners; the
/// fill is drawn square and clipped so the animated outline stays visible (a
/// rounded [BoxDecoration] alone would paint a static silhouette). Optional
/// [child] is centered in the button.
class ZoMorphButton extends StatefulWidget {
  final double width, height;
  final BoxDecoration decoration;
  final VoidCallback? onTap;
  final Widget? child;

  /// Duration of one full morph cycle on the outline.
  final Duration morphDuration;

  /// Scale applied while the pointer is down.
  final double pressedScale;

  const ZoMorphButton({
    super.key,
    required this.width,
    required this.height,
    required this.decoration,
    this.onTap,
    this.child,
    this.morphDuration = const Duration(seconds: 3),
    this.pressedScale = 0.95,
  });

  @override
  State<ZoMorphButton> createState() => _ZoMorphButtonState();
}

class _ZoMorphButtonState extends State<ZoMorphButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.morphDuration,
    )..repeat();
  }

  @override
  void didUpdateWidget(ZoMorphButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.morphDuration != oldWidget.morphDuration) {
      _controller.duration = widget.morphDuration;
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => setState(() => _pressed = true);
  void _onTapUp(_) => setState(() => _pressed = false);
  void _onTapCancel() => setState(() => _pressed = false);

  double _baseRadius(BuildContext context) {
    final geometry = widget.decoration.borderRadius;
    if (geometry == null) return 30;
    final r = geometry.resolve(Directionality.of(context));
    return (r.topLeft.x + r.topRight.x + r.bottomLeft.x + r.bottomRight.x) / 4;
  }

  /// Paints [decoration] without corner rounding so [ClipPath] is the only
  /// thing shaping the outline; otherwise the gradient follows a static
  /// [BorderRadius] and the morph disappears visually.
  BoxDecoration _decorationForClip(BoxDecoration d) {
    return d.copyWith(
      borderRadius: BorderRadius.zero,
      shape: BoxShape.rectangle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final baseRadius = _baseRadius(context);
    final content =
        widget.child ?? const SizedBox(height: kMinInteractiveDimension);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? widget.pressedScale : 1,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, _) {
            return ClipPath(
              clipper: _ZoMorphButtonClipper(
                t: _controller.value,
                baseRadius: baseRadius,
              ),
              child: Container(
                width: widget.width,
                height: widget.height,
                alignment: Alignment.center,
                decoration: _decorationForClip(widget.decoration),
                child: Center(child: content),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ZoMorphButtonClipper extends CustomClipper<Path> {
  final double t;
  final double baseRadius;

  const _ZoMorphButtonClipper({required this.t, required this.baseRadius});

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;

    final r1 = _radius(t, 0.0);
    final r2 = _radius(t, 0.25);
    final r3 = _radius(t, 0.5);
    final r4 = _radius(t, 0.75);

    final path = Path()
      ..moveTo(r1, 0)
      ..lineTo(w - r2, 0)
      ..quadraticBezierTo(w, 0, w, r2)
      ..lineTo(w, h - r3)
      ..quadraticBezierTo(w, h, w - r3, h)
      ..lineTo(r4, h)
      ..quadraticBezierTo(0, h, 0, h - r4)
      ..lineTo(0, r1)
      ..quadraticBezierTo(0, 0, r1, 0)
      ..close();

    return path;
  }

  double _radius(double t, double shift) {
    final wave = sin((t + shift) * 2 * pi) * 0.15 + 0.5;
    return wave * baseRadius;
  }

  @override
  bool shouldReclip(covariant _ZoMorphButtonClipper oldClipper) {
    return oldClipper.t != t || oldClipper.baseRadius != baseRadius;
  }
}
