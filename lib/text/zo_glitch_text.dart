import 'dart:math';

import 'package:flutter/material.dart';

class ZoGlitchText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final bool autoStart;

  final Function(AnimationController controller)? onLoaded;

  final String glitchCharacters;
  final Curve animationCurve;

  const ZoGlitchText({
    super.key,
    required this.text,
    this.onLoaded,
    this.glitchCharacters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%&*',
    this.style,
    this.animationCurve = Curves.easeInOutQuart,
    this.duration = const Duration(milliseconds: 1200),
    this.autoStart = true,
  });

  @override
  State<ZoGlitchText> createState() => _ZoGlitchTextState();
}

class _ZoGlitchTextState extends State<ZoGlitchText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final Random _random = Random();
  String _chars = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.animationCurve,
    );

    if (widget.autoStart) {
      _controller.forward();
    }

    if (widget.glitchCharacters.isEmpty) {
      _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#\$%&*';
    } else {
      _chars = widget.glitchCharacters;
    }

    widget.onLoaded?.call(_controller);
  }

  @override
  void didUpdateWidget(ZoGlitchText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getGlitchText(double progress) {
    final int length = widget.text.length;
    final int solvedThreshold = (length * progress).floor();

    return List.generate(length, (i) {
      if (widget.text[i] == ' ') return ' ';

      if (i > solvedThreshold) {
        return _chars[_random.nextInt(_chars.length)];
      }

      if (progress < 1.0 &&
          i == solvedThreshold &&
          _random.nextDouble() > 0.5) {
        return _chars[_random.nextInt(_chars.length)];
      }

      return widget.text[i];
    }).join('');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          _getGlitchText(_animation.value),
          style: widget.style?.copyWith(
            fontFeatures: [const FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}
