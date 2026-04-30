import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/button/zo_shimmer_button.dart';

class ExZoShimmerButton extends StatelessWidget {
  const ExZoShimmerButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ZoShimmerButton'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ZoShimmerButton(
          width: 220,
          height: 56,
          sweepDuration: const Duration(milliseconds: 2000),
          pauseBetweenSweeps: const Duration(milliseconds: 1200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [Color(0xFF00897B), Color(0xFF3949AB)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3949AB).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Shimmer button tapped')),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Tap me',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
