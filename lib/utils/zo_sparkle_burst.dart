import 'dart:math' as math;

import 'package:flutter/material.dart';

typedef SparkleBuilder =
    Widget Function(BuildContext context, AnimationController controller);

class SparkleBurstWrapper extends StatefulWidget {
  final SparkleBuilder builder;
  final Color sparkleColor;
  final Size size; // User can now pass custom size

  const SparkleBurstWrapper({
    super.key,
    required this.builder,
    this.sparkleColor = const Color(0xFFFF0050),
    this.size = const Size(200, 200), // Default size
  });

  @override
  State<SparkleBurstWrapper> createState() => _SparkleBurstWrapperState();
}

class _SparkleBurstWrapperState extends State<SparkleBurstWrapper>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Sparkle Layer restricted to user-defined size
        SizedBox(
          width: widget.size.width,
          height: widget.size.height,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: SparklePainter(
                  progress: _controller.value,
                  color: widget.sparkleColor,
                ),
              );
            },
          ),
        ),
        // Child button
        widget.builder(context, _controller),
      ],
    );
  }
}

// --- 2. DYNAMIC STAR PAINTER ---
class SparklePainter extends CustomPainter {
  final double progress;
  final Color color;

  SparklePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0 || progress >= 1) return;

    final paint = Paint()..color = color.withOpacity(1 - progress);
    final center = Offset(size.width / 2, size.height / 2);

    // Radius scales based on the provided size
    final double maxRadius = size.width / 2;
    final double radius = (maxRadius * 0.3) + (progress * (maxRadius * 0.7));

    for (int i = 0; i < 30; i++) {
      double angle = (i * 45) * math.pi / 180;
      Offset particlePos = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );

      Path path = Path();
      double s = 8 * (1 - progress); // Particle size shrinks as it travels

      path.moveTo(particlePos.dx, particlePos.dy - s);
      path.lineTo(particlePos.dx + s / 1.5, particlePos.dy);
      path.lineTo(particlePos.dx, particlePos.dy + s);
      path.lineTo(particlePos.dx - s / 1.5, particlePos.dy);
      path.close();

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(SparklePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
