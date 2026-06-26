import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// A premium wrapper that tilts the [child] in 3D space tracking the pointer.
/// 
/// Highly effective on Web and Desktop environments for cards and images, 
/// reminiscent of Apple TV focus interactions.
class Zo3DTiltWrapper extends StatefulWidget {
  final Widget child;
  
  /// The maximum tilt angle in degrees. Defaults to 15.0.
  final double maxTiltDegrees;
  
  /// Whether to add a subtle dynamic shadow that moves opposite to the tilt.
  final bool dynamicShadow;

  const Zo3DTiltWrapper({
    super.key,
    required this.child,
    this.maxTiltDegrees = 15.0,
    this.dynamicShadow = true,
  });

  @override
  State<Zo3DTiltWrapper> createState() => _Zo3DTiltWrapperState();
}

class _Zo3DTiltWrapperState extends State<Zo3DTiltWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _resetController;
  
  // Ratios from -1.0 to 1.0 representing pointer position relative to center
  double _xRatio = 0.0;
  double _yRatio = 0.0;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _resetController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _resetController.addListener(() {
      setState(() {
        _xRatio = _xRatio * (1 - _resetController.value);
        _yRatio = _yRatio * (1 - _resetController.value);
      });
    });
  }

  @override
  void dispose() {
    _resetController.dispose();
    super.dispose();
  }

  void _onHover(PointerEvent event, Size size) {
    if (size.width == 0 || size.height == 0) return;
    
    _resetController.stop();
    setState(() {
      _isHovering = true;
      // Map pointer local position to -1.0 to 1.0
      _xRatio = ((event.localPosition.dx / size.width) * 2) - 1;
      _yRatio = ((event.localPosition.dy / size.height) * 2) - 1;
      
      // Clamp values just in case
      _xRatio = _xRatio.clamp(-1.0, 1.0);
      _yRatio = _yRatio.clamp(-1.0, 1.0);
    });
  }

  void _onExit(PointerExitEvent event) {
    setState(() {
      _isHovering = false;
    });
    _resetController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          _onHover(event, renderBox.size);
        }
      },
      onExit: _onExit,
      child: AnimatedContainer(
        duration: _isHovering ? Duration.zero : const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Apply 3D Transform
            final tiltX = _yRatio * widget.maxTiltDegrees * (3.1415927 / 180);
            final tiltY = -_xRatio * widget.maxTiltDegrees * (3.1415927 / 180);

            final matrix = Matrix4.identity()
              ..setEntry(3, 2, 0.001) // perspective
              ..rotateX(tiltX)
              ..rotateY(tiltY);

            Widget content = Transform(
              transform: matrix,
              alignment: FractionalOffset.center,
              child: widget.child,
            );

            if (widget.dynamicShadow) {
              final shadowOffsetX = -_xRatio * 15;
              final shadowOffsetY = -_yRatio * 15;
              
              content = AnimatedContainer(
                duration: _isHovering ? Duration.zero : const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((_isHovering ? 40 : 0)),
                      blurRadius: 20,
                      spreadRadius: -5,
                      offset: Offset(shadowOffsetX, shadowOffsetY),
                    )
                  ]
                ),
                child: content,
              );
            }

            return content;
          },
        ),
      ),
    );
  }
}
