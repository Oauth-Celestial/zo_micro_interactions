import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zo_micro_interactions/utils/zo_sparkle_burst.dart';

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: YouTubeSubscribeButton()),
    ),
  ),
);

// --- 1. THE REUSABLE WRAPPER ---

// --- 3. IMPLEMENTATION ---
class YouTubeSubscribeButton extends StatefulWidget {
  const YouTubeSubscribeButton({super.key});

  @override
  State<YouTubeSubscribeButton> createState() => _YouTubeSubscribeButtonState();
}

class _YouTubeSubscribeButtonState extends State<YouTubeSubscribeButton> {
  bool isSubscribed = false;
  bool isPinkPhase = false;

  void _onTap(AnimationController controller) async {
    if (isSubscribed) {
      setState(() => isSubscribed = false);
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() => isPinkPhase = true); // Pink flash phase
    controller.forward(from: 0.0); // Start the sparkle burst

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() {
        isPinkPhase = false;
        isSubscribed = true; // Settle to dark gray
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SparkleBurstWrapper(
      size: const Size(250, 150), // CUSTOM SIZE PASSED HERE
      builder: (context, controller) {
        return GestureDetector(
          onTap: () => _onTap(controller),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutBack, // Smooth organic growth
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isPinkPhase
                  ? const Color(0xFFFF0050)
                  : (isSubscribed ? const Color(0xFF272727) : Colors.white),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSubscribed || isPinkPhase) ...[
                  const Icon(
                    Icons.notifications_none,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  isSubscribed ? "Subscribed" : "Subscribe",
                  style: TextStyle(
                    color: (isSubscribed || isPinkPhase)
                        ? Colors.white
                        : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                if (isSubscribed) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
