import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/button/zo_breathing_button.dart';
import 'package:zo_micro_interactions/button/zo_morph_button.dart';
import 'package:zo_micro_interactions/button/zo_shimmer_button.dart';
import 'package:zo_micro_interactions/button/zo_spring_button.dart';

/// Gallery of tap targets with small, polished motion languages.
class ExMicroButtons extends StatelessWidget {
  const ExMicroButtons({super.key});

  static BoxDecoration _demoDecoration(double radius) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(radius),
      gradient: const LinearGradient(
        colors: [Color(0xFF5C6BC0), Color(0xFF8E24AA)],
      ),
    );
  }

  static Widget _label(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    void ping(String name) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$name tapped')));
    }

    const w = 220.0;
    const h = 52.0;
    const radius = 26.0;

    final deco = _demoDecoration(radius);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Micro-interaction buttons'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        children: [
          Text(
            'Same footprint — different motion.',
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
          const SizedBox(height: 24),
          _label('ZoMorphButton', 'Soft outline drift + press scale'),
          Center(
            child: ZoMorphButton(
              width: w,
              height: h,
              decoration: deco,
              onTap: () => ping('Morph'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _InlineCta('Continue'),
              ),
            ),
          ),
          const SizedBox(height: 28),
          _label('ZoSpringButton', 'Spring settle on release'),
          Center(
            child: ZoSpringButton(
              width: w,
              height: h,
              decoration: deco,
              onTap: () => ping('Spring'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _InlineCta('Save'),
              ),
            ),
          ),
          const SizedBox(height: 28),
          _label('ZoShimmerButton', 'Periodic gloss sweep'),
          Center(
            child: ZoShimmerButton(
              width: w,
              height: h,
              decoration: deco,
              onTap: () => ping('Shimmer'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _InlineCta('Upgrade'),
              ),
            ),
          ),
          const SizedBox(height: 28),
          _label('ZoBreathingButton', 'Idle breath + press dip'),
          Center(
            child: ZoBreathingButton(
              width: w,
              height: h,
              decoration: deco,
              onTap: () => ping('Breathing'),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: _InlineCta('Notify me'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineCta extends StatelessWidget {
  final String text;

  const _InlineCta(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
