import 'package:flutter/material.dart';

/// A sleek, animated counter that smoothly transitions between numbers.
/// Perfect for balances, points, or stats.
class ZoAnimatedCounter extends ImplicitlyAnimatedWidget {
  final num value;
  final TextStyle? textStyle;
  final String? prefix;
  final String? suffix;
  final int fractionDigits;

  const ZoAnimatedCounter({
    super.key,
    required this.value,
    this.textStyle,
    this.prefix,
    this.suffix,
    this.fractionDigits = 0,
    super.duration = const Duration(milliseconds: 500),
    super.curve = Curves.fastOutSlowIn,
  });

  @override
  ImplicitlyAnimatedWidgetState<ZoAnimatedCounter> createState() =>
      _ZoAnimatedCounterState();
}

class _ZoAnimatedCounterState
    extends AnimatedWidgetBaseState<ZoAnimatedCounter> {
  Tween<double>? _value;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _value = visitor(
      _value,
      widget.value.toDouble(),
      (dynamic value) => Tween<double>(begin: value as double),
    ) as Tween<double>?;
  }

  @override
  Widget build(BuildContext context) {
    final val = _value?.evaluate(animation) ?? widget.value.toDouble();
    final formattedValue = val.toStringAsFixed(widget.fractionDigits);
    final text = '${widget.prefix ?? ''}$formattedValue${widget.suffix ?? ''}';

    return Text(
      text,
      style: widget.textStyle ?? Theme.of(context).textTheme.headlineMedium,
    );
  }
}
