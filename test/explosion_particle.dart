import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(const MaterialApp(home: ExplosionDemo()));

class ExplosionDemo extends StatelessWidget {
  const ExplosionDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: Center(
        child: ExplodingWidget(
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.cyanAccent,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.cyan.withOpacity(0.5), blurRadius: 20),
              ],
            ),
            child: const Icon(Icons.bolt, size: 80, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

class ExplodingWidget extends StatefulWidget {
  final Widget child;
  const ExplodingWidget({super.key, required this.child});

  @override
  State<ExplodingWidget> createState() => _ExplodingWidgetState();
}

class _ExplodingWidgetState extends State<ExplodingWidget>
    with SingleTickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  late AnimationController _controller;
  List<Particle> _particles = [];
  bool _visible = true;
  Offset _origin = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _shatter() async {
    final renderBox =
        _key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (renderBox == null) return;

    // Get the exact position on screen
    final box = _key.currentContext!.findRenderObject() as RenderBox;
    _origin = box.localToGlobal(Offset.zero);

    // Capture Widget
    ui.Image image = await renderBox.toImage(pixelRatio: 1.0);
    ByteData? bytes = await image.toByteData(
      format: ui.ImageByteFormat.rawRgba,
    );
    if (bytes == null) return;

    final List<Particle> temp = [];
    final Random random = Random();

    // Step 5 for better performance/density balance
    for (int y = 0; y < image.height; y += 5) {
      for (int x = 0; x < image.width; x += 5) {
        int index = (y * image.width + x) * 4;
        if (bytes.getUint8(index + 3) > 0) {
          // If not transparent
          temp.add(
            Particle(
              pos: Offset(x.toDouble() + _origin.dx, y.toDouble() + _origin.dy),
              vel: Offset(
                random.nextDouble() * 8 - 4,
                random.nextDouble() * 10 - 7,
              ),
              color: Color.fromARGB(
                255,
                bytes.getUint8(index),
                bytes.getUint8(index + 1),
                bytes.getUint8(index + 2),
              ),
            ),
          );
        }
      }
    }

    setState(() {
      _particles = temp;
      _visible = false;
    });

    _controller.addListener(() {
      for (var p in _particles) {
        p.pos += p.vel;
        p.vel += const Offset(0, 0.2); // Gravity
      }
      setState(() {});
    });
    _controller.forward();

    Future.delayed(Duration(seconds: 5), () {
      _controller.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (_visible)
          GestureDetector(
            onTap: _shatter,
            child: RepaintBoundary(key: _key, child: widget.child),
          ),
        if (!_visible)
          Positioned.fill(
            child: CustomPaint(
              painter: ExplosionPainter(_particles, _controller.value),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Particle {
  Offset pos;
  Offset vel;
  final Color color;
  Particle({required this.pos, required this.vel, required this.color});
}

class ExplosionPainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;
  ExplosionPainter(this.particles, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    for (var p in particles) {
      paint.color = p.color.withOpacity((1.0 - progress).clamp(0, 1));
      canvas.drawPoints(ui.PointMode.points, [p.pos], paint);
    }
  }

  @override
  bool shouldRepaint(ExplosionPainter old) => true;
}
