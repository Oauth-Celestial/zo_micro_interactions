import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/text/zo_glitch_text.dart';

class HyperTextDemo extends StatefulWidget {
  const HyperTextDemo({super.key});

  @override
  State<HyperTextDemo> createState() => _HyperTextDemoState();
}

class _HyperTextDemoState extends State<HyperTextDemo> {
  String _headerText = "TERMINAL ACCESS";
  bool _trigger = false;
  AnimationController? firstController, secondController;

  void _handleRefresh() {
    setState(() {
      _trigger = !_trigger;
      _headerText = _trigger ? "TheZerone" : "ZoMicroInteraction";
      firstController?.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050505),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ZoGlitchText(
              text: _headerText,
              autoStart: true,
              onLoaded: (animationController) {
                firstController = animationController;
              },
              style: const TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
                fontFamily: 'monospace',
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            ZoGlitchText(
              text: "FETCHING SECURE DATA ",
              duration: const Duration(seconds: 2),
              autoStart: true,
              style: TextStyle(
                fontSize: 14,
                color: Colors.cyanAccent.withOpacity(0.5),
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 60),
            OutlinedButton(
              onPressed: _handleRefresh,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.cyanAccent,
              ),
              child: const Text("EXECUTE COMMAND"),
            ),
          ],
        ),
      ),
    );
  }
}
