import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Soft idle “breathing” scale with a quick dip on press — reads alive without noise.
///
/// Matches [ZoMorphButton]-style sizing: [width], [height], [decoration], optional
/// centered [child].
class ZoBreathingButton extends StatefulWidget {
  final double width;
  final double height;
  final BoxDecoration decoration;
  final VoidCallback? onTap;
  final Widget? child;

  /// One full inhale/exhale cycle.
  final Duration breathDuration;

  /// Peak scale above `1.0` at the top of the breath (e.g. `0.012` ≈ 1.2%).
  final double breathAmplitude;

  final Duration pressDuration;
  final double pressedScale;

  const ZoBreathingButton({
    super.key,
    required this.width,
    required this.height,
    required this.decoration,
    this.onTap,
    this.child,
    this.breathDuration = const Duration(milliseconds: 2600),
    this.breathAmplitude = 0.014,
    this.pressDuration = const Duration(milliseconds: 120),
    this.pressedScale = 0.96,
  });

  @override
  State<ZoBreathingButton> createState() => _ZoBreathingButtonState();
}

class _ZoBreathingButtonState extends State<ZoBreathingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _breath;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _breath = AnimationController(vsync: this, duration: widget.breathDuration)
      ..repeat();
  }

  @override
  void didUpdateWidget(ZoBreathingButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.breathDuration != oldWidget.breathDuration) {
      _breath.duration = widget.breathDuration;
      _breath.repeat();
    }
  }

  @override
  void dispose() {
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          animation: _breath,
          builder: (context, _) {
            final breath = 1.0 +
                widget.breathAmplitude *
                    math.sin(_breath.value * 2 * math.pi);
            return Transform.scale(
              scale: breath,
              alignment: Alignment.center,
              child: Container(
                width: widget.width,
                height: widget.height,
                alignment: Alignment.center,
                decoration: widget.decoration,
                child: Center(child: content),
              ),
            );
          },
        ),
      ),
    );
  }
}
