import 'dart:math';
import 'package:flutter/material.dart';

class ZoGlitchPriceText extends StatefulWidget {
  final double price;
  final Color profitColor;
  final Color lossColor;
  final int fixedDecimal;
  const ZoGlitchPriceText({
    super.key,
    required this.price,
    this.profitColor = Colors.green,
    this.lossColor = Colors.red,
    this.fixedDecimal = 2,
  });

  @override
  State<ZoGlitchPriceText> createState() => _ZoGlitchPriceTextState();
}

class _ZoGlitchPriceTextState extends State<ZoGlitchPriceText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Color _glitchColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _glitchColor = Colors.transparent;
  }

  @override
  void didUpdateWidget(ZoGlitchPriceText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.price != oldWidget.price) {
      _glitchColor = widget.price > oldWidget.price
          ? widget.profitColor
          : widget.lossColor;
      _controller.forward(from: 0); // Restart animation
    }
  }

  @override
  Widget build(BuildContext context) {
    final text = widget.price.toStringAsFixed(widget.fixedDecimal);
    const style = TextStyle(
      color: Colors.white,
      fontSize: 50,
      fontWeight: FontWeight.bold,
      fontFamily: 'monospace',
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        double offset =
            sin(_controller.value * 15 * pi) * (1 - _controller.value) * 15;

        return Stack(
          alignment: Alignment.center,
          children: [
            if (_controller.isAnimating) ...[
              // Left Blur/Glow layer
              Transform.translate(
                offset: Offset(-offset, 0),
                child: Text(
                  text,
                  style: style.copyWith(
                    color: _glitchColor.withValues(alpha: 0.5),
                    shadows: [Shadow(color: _glitchColor, blurRadius: 20)],
                  ),
                ),
              ),
              // Right Blur/Glow layer
              Transform.translate(
                offset: Offset(offset, 0),
                child: Text(
                  text,
                  style: style.copyWith(
                    color: _glitchColor.withValues(alpha: 0.5),
                    shadows: [Shadow(color: _glitchColor, blurRadius: 20)],
                  ),
                ),
              ),
            ],
            // Main Text
            Text(text, style: style),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
