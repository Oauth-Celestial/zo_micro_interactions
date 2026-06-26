import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Defines the visual and animated variant of the [ZoInteractiveButton].
enum ZoButtonVariant {
  /// A shiny shimmer sweeps across the button periodically.
  shimmer,

  /// The button continuously pulses like a heartbeat.
  heartbeat,

  /// A fluid fills the button when enabled and drains when disabled.
  fluidFill,
}

/// Direction for the fluid fill animation.
enum FluidFillDirection {
  bottomToTop,
  topToBottom,
  leftToRight,
  rightToLeft,
}

/// A highly polished, multi-variant micro-interaction button.
/// 
/// Variations:
/// - [ZoButtonVariant.shimmer]: A smooth shimmer effect.
/// - [ZoButtonVariant.heartbeat]: A continuous heartbeat pulse.
/// - [ZoButtonVariant.fluidFill]: A fluid wave fills the button when [isActive] is true.
class ZoInteractiveButton extends StatefulWidget {
  final ZoButtonVariant variant;
  final Widget child;
  final VoidCallback onTap;
  
  /// Controls the filled/empty state for the [ZoButtonVariant.fluidFill] variant.
  final bool isActive;
  
  /// The direction of the fluid wave fill. Defaults to [FluidFillDirection.bottomToTop].
  final FluidFillDirection fluidFillDirection;
  
  final double width;
  final double height;
  final Color baseColor;
  final Color activeColor;
  final double borderRadius;

  const ZoInteractiveButton({
    super.key,
    required this.variant,
    required this.child,
    required this.onTap,
    this.isActive = false,
    this.fluidFillDirection = FluidFillDirection.bottomToTop,
    this.width = 160.0,
    this.height = 50.0,
    this.baseColor = const Color(0xFFE0E0E0),
    this.activeColor = const Color(0xFF2196F3),
    this.borderRadius = 25.0,
  });

  @override
  State<ZoInteractiveButton> createState() => _ZoInteractiveButtonState();
}

class _ZoInteractiveButtonState extends State<ZoInteractiveButton>
    with TickerProviderStateMixin {
  // Common scale controller for press feedback
  late AnimationController _pressController;
  
  // Controllers for specific variants
  AnimationController? _shimmerController;
  AnimationController? _heartbeatController;
  AnimationController? _fluidController; // Controls the wave animation
  AnimationController? _fillController;  // Controls the fill level

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _setupVariantControllers();
  }

  @override
  void didUpdateWidget(covariant ZoInteractiveButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variant != widget.variant) {
      _disposeVariantControllers();
      _setupVariantControllers();
    }
    
    if (widget.variant == ZoButtonVariant.fluidFill && oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _fillController?.forward();
      } else {
        _fillController?.reverse();
      }
    }
  }

  void _setupVariantControllers() {
    switch (widget.variant) {
      case ZoButtonVariant.shimmer:
        _shimmerController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 2000),
        )..repeat(reverse: false);
        break;
      case ZoButtonVariant.heartbeat:
        _heartbeatController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 800),
        )..repeat(reverse: true);
        break;
      case ZoButtonVariant.fluidFill:
        _fluidController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1500),
        )..repeat();
        _fillController = AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 800),
          value: widget.isActive ? 1.0 : 0.0,
        );
        break;
    }
  }

  void _disposeVariantControllers() {
    _shimmerController?.dispose();
    _heartbeatController?.dispose();
    _fluidController?.dispose();
    _fillController?.dispose();
    _shimmerController = null;
    _heartbeatController = null;
    _fluidController = null;
    _fillController = null;
  }

  @override
  void dispose() {
    _pressController.dispose();
    _disposeVariantControllers();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _pressController.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          final scale = 1.0 - (_pressController.value * 0.05);
          return Transform.scale(
            scale: scale,
            child: _buildVariant(context),
          );
        },
      ),
    );
  }

  Widget _buildVariant(BuildContext context) {
    switch (widget.variant) {
      case ZoButtonVariant.shimmer:
        return _buildShimmer();
      case ZoButtonVariant.heartbeat:
        return _buildHeartbeat();
      case ZoButtonVariant.fluidFill:
        return _buildFluidFill();
    }
  }

  Widget _buildShimmer() {
    return AnimatedBuilder(
      animation: _shimmerController!,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.baseColor,
            gradient: LinearGradient(
              colors: [
                widget.baseColor,
                Colors.white.withAlpha(150),
                widget.baseColor,
              ],
              stops: const [0.3, 0.5, 0.7],
              begin: const Alignment(-1.0, -0.5),
              end: const Alignment(1.0, 0.5),
              transform: _SlidingGradientTransform(
                slidePercent: _shimmerController!.value,
              ),
            ),
          ),
          child: Center(child: widget.child),
        );
      },
    );
  }

  Widget _buildHeartbeat() {
    return AnimatedBuilder(
      animation: _heartbeatController!,
      builder: (context, child) {
        // Curve the heartbeat to snap and relax
        final curve = Curves.elasticOut.transform(_heartbeatController!.value);
        final heartbeatScale = 1.0 + (curve * 0.06);
        return Transform.scale(
          scale: heartbeatScale,
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: widget.baseColor,
              boxShadow: [
                BoxShadow(
                  color: widget.baseColor.withAlpha(100),
                  blurRadius: 10 * curve,
                  spreadRadius: 2 * curve,
                )
              ],
            ),
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }

  Widget _buildFluidFill() {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        color: widget.baseColor,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: Listenable.merge([_fluidController, _fillController]),
            builder: (context, child) {
              return CustomPaint(
                size: Size(widget.width, widget.height),
                painter: _FluidPainter(
                  waveAnimation: _fluidController!.value,
                  fillLevel: CurvedAnimation(
                    parent: _fillController!,
                    curve: Curves.easeInOutCubic,
                  ).value,
                  color: widget.activeColor,
                  direction: widget.fluidFillDirection,
                ),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent * 2 - 1), 0.0, 0.0);
  }
}

class _FluidPainter extends CustomPainter {
  final double waveAnimation;
  final double fillLevel;
  final Color color;
  final FluidFillDirection direction;

  _FluidPainter({
    required this.waveAnimation,
    required this.fillLevel,
    required this.color,
    required this.direction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (fillLevel <= 0.0) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // If fully filled, no waves needed, just a rect.
    if (fillLevel >= 1.0) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
      return;
    }

    final waveHeight = 8.0;

    switch (direction) {
      case FluidFillDirection.bottomToTop:
        final baseHeight = size.height - (fillLevel * size.height);
        path.moveTo(0, baseHeight);
        for (double i = 0; i <= size.width; i++) {
          final waveOffset = math.sin((i / size.width * 2 * math.pi) + (waveAnimation * 2 * math.pi));
          path.lineTo(i, baseHeight + waveOffset * waveHeight);
        }
        path.lineTo(size.width, size.height);
        path.lineTo(0, size.height);
        break;

      case FluidFillDirection.topToBottom:
        final baseHeight = fillLevel * size.height;
        path.moveTo(0, baseHeight);
        for (double i = 0; i <= size.width; i++) {
          final waveOffset = math.sin((i / size.width * 2 * math.pi) + (waveAnimation * 2 * math.pi));
          path.lineTo(i, baseHeight + waveOffset * waveHeight);
        }
        path.lineTo(size.width, 0);
        path.lineTo(0, 0);
        break;

      case FluidFillDirection.leftToRight:
        final baseWidth = fillLevel * size.width;
        path.moveTo(baseWidth, 0);
        for (double i = 0; i <= size.height; i++) {
          final waveOffset = math.sin((i / size.height * 2 * math.pi) + (waveAnimation * 2 * math.pi));
          path.lineTo(baseWidth + waveOffset * waveHeight, i);
        }
        path.lineTo(0, size.height);
        path.lineTo(0, 0);
        break;

      case FluidFillDirection.rightToLeft:
        final baseWidth = size.width - (fillLevel * size.width);
        path.moveTo(baseWidth, 0);
        for (double i = 0; i <= size.height; i++) {
          final waveOffset = math.sin((i / size.height * 2 * math.pi) + (waveAnimation * 2 * math.pi));
          path.lineTo(baseWidth + waveOffset * waveHeight, i);
        }
        path.lineTo(size.width, size.height);
        path.lineTo(size.width, 0);
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _FluidPainter oldDelegate) {
    return oldDelegate.waveAnimation != waveAnimation ||
           oldDelegate.fillLevel != fillLevel ||
           oldDelegate.color != color ||
           oldDelegate.direction != direction;
  }
}
