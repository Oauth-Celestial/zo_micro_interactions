import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(child: BouncingBall()),
      ),
    );
  }
}

class BouncingBall extends StatefulWidget {
  const BouncingBall({super.key});

  @override
  State<BouncingBall> createState() => _BouncingBallState();
}

class _BouncingBallState extends State<BouncingBall>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final Random _random = Random();

  static const double radius = 40; // try changing this

  Offset? position;
  late Offset velocity;

  Size? canvasSize;

  @override
  void initState() {
    super.initState();

    velocity = Offset(_random.nextBool() ? 4 : -4, _random.nextBool() ? 5 : -5);

    _ticker = createTicker(_update)..start();
  }

  void _update(Duration _) {
    if (canvasSize == null || position == null) return;

    final width = canvasSize!.width;
    final height = canvasSize!.height;

    double nextX = position!.dx + velocity.dx;
    double nextY = position!.dy + velocity.dy;

    // Horizontal bounce
    if (nextX <= radius || nextX >= width - radius) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }

    // Vertical bounce
    if (nextY <= radius || nextY >= height - radius) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }

    setState(() {
      position = Offset(
        nextX.clamp(radius, width - radius),
        nextY.clamp(radius, height - radius),
      );
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) {
        canvasSize = constraints.biggest;

        // Safe initialization
        position ??= Offset(
          radius + _random.nextDouble() * (canvasSize!.width - 2 * radius),
          radius + _random.nextDouble() * (canvasSize!.height - 2 * radius),
        );

        return CustomPaint(
          painter: BallPainter(position!, radius),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class BallPainter extends CustomPainter {
  final Offset position;
  final double radius;

  BallPainter(this.position, this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    paint.maskFilter = MaskFilter.blur(BlurStyle.solid, 20);

    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(covariant BallPainter oldDelegate) {
    return oldDelegate.position != position;
  }
}
