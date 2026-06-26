import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/zo_micro_interactions.dart';

class ExWrappersScreen extends StatefulWidget {
  const ExWrappersScreen({super.key});

  @override
  State<ExWrappersScreen> createState() => _ExWrappersScreenState();
}

class _ExWrappersScreenState extends State<ExWrappersScreen> {
  bool _isShaking = false;
  bool _isJiggling = false;
  bool _isPulsing = true;

  Widget _buildBox(String text, Color color) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wrapper Micro-Interactions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          const Text('Tap Bounce Wrapper', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ZoTapBounceWrapper(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bounced!'), duration: Duration(milliseconds: 500)));
            },
            child: _buildBox('Tap Me (Spring Bounce)', Colors.blueAccent),
          ),
          const SizedBox(height: 32),

          const Text('Particle Burst Wrapper', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ZoParticleBurstWrapper(
            particleColor: Colors.orangeAccent,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Boom!'), duration: Duration(milliseconds: 500)));
            },
            child: _buildBox('Tap Me (Explosion)', Colors.deepOrange),
          ),
          const SizedBox(height: 32),

          const Text('Shake Error Wrapper', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ZoShakeWrapper(
            shake: _isShaking,
            child: GestureDetector(
              onTap: () {
                setState(() => _isShaking = true);
                Future.delayed(const Duration(milliseconds: 600), () {
                  if (mounted) setState(() => _isShaking = false);
                });
              },
              child: _buildBox('Tap to Shake (Error)', Colors.redAccent),
            ),
          ),
          const SizedBox(height: 32),

          const Text('Jiggle Wrapper', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ZoJiggleWrapper(
                  isJiggling: _isJiggling,
                  child: _buildBox('Jiggling...', Colors.purpleAccent),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => setState(() => _isJiggling = !_isJiggling),
                child: Text(_isJiggling ? 'Stop' : 'Start'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          const Text('Pulse Attention Wrapper', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ZoPulseWrapper(
                  isPulsing: _isPulsing,
                  child: _buildBox('Pulsing...', Colors.teal),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => setState(() => _isPulsing = !_isPulsing),
                child: Text(_isPulsing ? 'Stop' : 'Start'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          const Text('3D Tilt Wrapper', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Text('Hover pointer over the card to tilt it', style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Zo3DTiltWrapper(
            child: Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.blue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  'Hover me in Web/Desktop',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }
}
