import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Glossy highlight that sweeps across the face on a loop — subtle “premium” CTA.
///
/// [decoration] paints the base; shimmer uses [shimmerColor] and [shimmerWidthFraction].
/// Content is clipped with [decoration.borderRadius] when present.
class ZoShimmerButton extends StatefulWidget {
  final double width;
  final double height;
  final BoxDecoration decoration;
  final VoidCallback? onTap;
  final Widget? child;

  final Duration sweepDuration;

  /// Pause after each full pass before repeating (no shimmer during pause).
  final Duration pauseBetweenSweeps;

  final Color shimmerColor;
  final double shimmerWidthFraction;

  final Duration pressDuration;
  final double pressedScale;

  const ZoShimmerButton({
    super.key,
    required this.width,
    required this.height,
    required this.decoration,
    this.onTap,
    this.child,
    this.sweepDuration = const Duration(milliseconds: 2200),
    this.pauseBetweenSweeps = const Duration(milliseconds: 1400),
    this.shimmerColor = const Color(0x66FFFFFF),
    this.shimmerWidthFraction = 0.38,
    this.pressDuration = const Duration(milliseconds: 110),
    this.pressedScale = 0.97,
  });

  @override
  State<ZoShimmerButton> createState() => _ZoShimmerButtonState();
}

class _ZoShimmerButtonState extends State<ZoShimmerButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _sweep;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    final totalMs =
        widget.sweepDuration.inMilliseconds + widget.pauseBetweenSweeps.inMilliseconds;
    _sweep = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: math.max(1, totalMs)),
    )..repeat();
  }

  @override
  void didUpdateWidget(ZoShimmerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    final totalMs =
        widget.sweepDuration.inMilliseconds + widget.pauseBetweenSweeps.inMilliseconds;
    final newDuration = Duration(milliseconds: math.max(1, totalMs));
    if (newDuration != _sweep.duration) {
      _sweep.duration = newDuration;
      _sweep.repeat();
    }
  }

  @override
  void dispose() {
    _sweep.dispose();
    super.dispose();
  }

  BorderRadius _clipRadius(BuildContext context) {
    final g = widget.decoration.borderRadius;
    if (g == null) return BorderRadius.zero;
    return g.resolve(Directionality.of(context));
  }

  double? _sweepT(double controllerValue) {
    final sweepMs = widget.sweepDuration.inMilliseconds;
    final totalMs = _sweep.duration?.inMilliseconds ??
        (sweepMs + widget.pauseBetweenSweeps.inMilliseconds);
    if (totalMs <= 0 || sweepMs <= 0) return null;
    final elapsed = controllerValue * totalMs;
    if (elapsed > sweepMs) return null;
    return elapsed / sweepMs;
  }

  @override
  Widget build(BuildContext context) {
    final radius = _clipRadius(context);
    final content =
        widget.child ?? const SizedBox(height: kMinInteractiveDimension);

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: widget.pressDuration,
        scale: _pressed ? widget.pressedScale : 1.0,
        child: AnimatedBuilder(
          animation: _sweep,
          builder: (context, _) {
            final t = _sweepT(_sweep.value);
            final bandW = widget.width * widget.shimmerWidthFraction;
            final x = t == null
                ? -bandW
                : (-bandW + (widget.width + 2 * bandW) * t);

            return ClipRRect(
              borderRadius: radius,
              child: Stack(
                clipBehavior: Clip.hardEdge,
                children: [
                  Container(
                    width: widget.width,
                    height: widget.height,
                    alignment: Alignment.center,
                    decoration: widget.decoration,
                    child: Center(child: content),
                  ),
                  Positioned(
                    left: x,
                    top: 0,
                    bottom: 0,
                    width: bandW,
                    child: IgnorePointer(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              widget.shimmerColor.withValues(alpha: 0),
                              widget.shimmerColor,
                              widget.shimmerColor.withValues(alpha: 0),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
