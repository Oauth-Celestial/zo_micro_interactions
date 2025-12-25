import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

// 1. Added fancySpring to the enum
enum ZoAnimatedTextType {
  fadeBlur,
  slideUp,
  chaos,
  flipUp,
  swirl,
  syncFade,
  fancySpring,
}

class ZoAnimatedText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final ZoAnimatedTextType type;
  final Duration duration;
  final double stagger;
  final bool splitByWord;
  final Function(AnimationController)? onLoaded;

  const ZoAnimatedText({
    super.key,
    required this.text,
    this.style,
    this.type = ZoAnimatedTextType.fadeBlur,
    this.duration = const Duration(milliseconds: 1500),
    this.stagger = 0.05,
    required this.splitByWord,
    this.onLoaded,
  });

  @override
  State<ZoAnimatedText> createState() => _ZoAnimatedTextState();
}

class _ZoAnimatedTextState extends State<ZoAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _units;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _prepUnits();

    if (widget.onLoaded != null) {
      widget.onLoaded!(_controller);
    }
  }

  void _prepUnits() {
    _units = widget.splitByWord
        ? RegExp(
            r'\S+|\s+',
          ).allMatches(widget.text).map((m) => m.group(0)!).toList()
        : widget.text.split('');
  }

  @override
  void didUpdateWidget(ZoAnimatedText old) {
    super.didUpdateWidget(old);
    if (widget.text != old.text || widget.splitByWord != old.splitByWord) {
      _prepUnits();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: List.generate(_units.length, (i) {
          final bool isSync = widget.type == ZoAnimatedTextType.syncFade;

          final double individualWeight = 1.0;
          final double totalWeight = 1.0 + (_units.length - 1) * widget.stagger;
          final double unitWindow = individualWeight / totalWeight;

          final double start = isSync
              ? 0.0
              : (i * widget.stagger * unitWindow).clamp(0.0, 1.0);
          final double end = isSync
              ? 1.0
              : (start + unitWindow).clamp(0.0, 1.0);

          final curve = widget.type == ZoAnimatedTextType.fancySpring
              ? Curves.easeInOutCubic
              : Curves.easeOutCubic;

          return _AnimatedUnit(
            unit: _units[i],
            type: widget.type,
            style: widget.style,
            animation: CurvedAnimation(
              parent: _controller,
              curve: Interval(start, end, curve: curve),
            ),
          );
        }),
      ),
    );
  }
}

class _AnimatedUnit extends AnimatedWidget {
  final String unit;
  final ZoAnimatedTextType type;
  final TextStyle? style;

  const _AnimatedUnit({
    required this.unit,
    required this.type,
    required Animation<double> animation,
    this.style,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final anim = listenable as Animation<double>;
    final currentValue = anim.value;
    final inv = (1.0 - currentValue).clamp(0.0, 1.0);
    final childText = Text(unit, style: style);

    switch (type) {
      case ZoAnimatedTextType.fancySpring:
        // Configurable spring parameters
        const springDesc = SpringDescription(
          mass: 0.8,
          stiffness: 300,
          damping: 10,
        );
        const maxOffset = 50.0;
        const maxRotation = 45.0;
        const minScale = 0.3;
        const maxBlur = 14.0;

        final random = math.Random(unit.hashCode);
        final initialY = (random.nextDouble() * 2 - 1) * maxOffset;
        final initialRotation = (random.nextDouble() * 2 - 1) * maxRotation;

        final springCurve = SpringSimulation(springDesc, 0, 1, 0);
        final springValue = springCurve.x(currentValue);

        final currentY = initialY * (1 - springValue);
        final currentRotation = initialRotation * (1 - springValue);
        final currentScale = minScale + (1 - minScale) * springValue;
        final blurAmount = (1 - springValue) * maxBlur;

        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, currentY)
            ..rotateZ(currentRotation * math.pi / 180)
            ..scale(currentScale),
          alignment: Alignment.center,
          child: Opacity(
            opacity: springValue.clamp(0.0, 1.0),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blurAmount,
                sigmaY: blurAmount,
              ),
              child: childText,
            ),
          ),
        );

      case ZoAnimatedTextType.fadeBlur:
      case ZoAnimatedTextType.syncFade:
        return Opacity(
          opacity: currentValue,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10 * inv, sigmaY: 10 * inv),
            child: childText,
          ),
        );
      case ZoAnimatedTextType.slideUp:
        return FractionalTranslation(
          translation: Offset(0, 0.5 * inv),
          child: Opacity(opacity: currentValue, child: childText),
        );
      case ZoAnimatedTextType.chaos:
        final rnd = math.Random(unit.hashCode);
        final x = (rnd.nextDouble() * 200 - 100) * inv;
        final y = (rnd.nextDouble() * 200 - 100) * inv;
        return Transform.translate(
          offset: Offset(x, y),
          child: Opacity(opacity: currentValue, child: childText),
        );
      case ZoAnimatedTextType.flipUp:
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(inv * math.pi / 2),
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: currentValue.clamp(0.0, 1.0),
            child: childText,
          ),
        );
      case ZoAnimatedTextType.swirl:
        return Transform.rotate(
          angle: inv * math.pi,
          child: Transform.scale(
            scale: currentValue,
            child: Opacity(opacity: currentValue, child: childText),
          ),
        );
    }
  }
}
