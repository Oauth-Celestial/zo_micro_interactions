import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/utils/zo_bounce_widget.dart';

class PolishedToggleButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback? onTap;
  final String text;

  final BoxDecoration enabledDecoration;
  final BoxDecoration disabledDecoration;

  final TextStyle enabledTextStyle;
  final TextStyle disabledTextStyle;

  final EdgeInsets padding;
  final Duration duration;

  const PolishedToggleButton({
    super.key,
    required this.enabled,
    required this.text,
    required this.enabledDecoration,
    required this.disabledDecoration,
    required this.enabledTextStyle,
    required this.disabledTextStyle,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  State<PolishedToggleButton> createState() => _PolishedToggleButtonState();
}

class _PolishedToggleButtonState extends State<PolishedToggleButton>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = widget.enabled
        ? widget.enabledDecoration
        : widget.disabledDecoration;

    final textStyle = widget.enabled
        ? widget.enabledTextStyle
        : widget.disabledTextStyle;

    return ZoBounceWidget(
      onTap: widget.enabled ? widget.onTap : null,
      child: AnimatedContainer(
        duration: widget.duration,
        curve: Curves.easeInOut,
        padding: widget.padding,
        decoration: decoration,
        child: AnimatedDefaultTextStyle(
          duration: widget.duration,
          style: textStyle,
          child: Text(widget.text),
        ),
      ),
    );
  }
}
