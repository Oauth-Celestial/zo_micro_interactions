import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/button/zo_breathing_button.dart';

class ExZoBreathingButton extends StatelessWidget {
  const ExZoBreathingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('ZoBreathingButton'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ZoBreathingButton(
          width: 220,
          height: 56,
          breathDuration: const Duration(milliseconds: 2800),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF7043), Color(0xFFC2185B)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC2185B).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Breathing button tapped')),
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
