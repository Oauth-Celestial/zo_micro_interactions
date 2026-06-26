import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/zo_micro_interactions.dart';

class ExNewInteractions extends StatefulWidget {
  const ExNewInteractions({super.key});

  @override
  State<ExNewInteractions> createState() => _ExNewInteractionsState();
}

class _ExNewInteractionsState extends State<ExNewInteractions> {
  bool _switchValue = false;
  bool _isLiked = false;
  double _counterValue = 100.0;
  bool _isFluidFilled = false;
  bool _isFluidLeftToRight = false;
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
            color: color.withValues(alpha: 0.4),
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
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('New Interactions'),
        backgroundColor: Colors.grey.shade900,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 60),
        children: [
          _label('ZoBurstPopup', 'Spring-loaded popup with particle burst'),
          Center(
            child: ElevatedButton(
              onPressed: () {
                showZoBurstPopup(
                  context: context,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, color: Colors.green, size: 64),
                        SizedBox(height: 16),
                        Text(
                          'Success!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Show Burst Popup'),
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoSlideToConfirm', 'High-friction slider button'),
          ZoSlideToConfirm(
            onConfirm: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Action Confirmed!')),
              );
            },
          ),
          const SizedBox(height: 28),

          _label('ZoAnimatedCounter', 'Smooth rolling numbers'),
          Center(
            child: Column(
              children: [
                ZoAnimatedCounter(
                  value: _counterValue,
                  prefix: '\$',
                  fractionDigits: 2,
                  textStyle: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.remove_circle),
                      onPressed: () => setState(() => _counterValue -= 15.50),
                    ),
                    IconButton(
                      color: Colors.white,
                      icon: const Icon(Icons.add_circle),
                      onPressed: () => setState(() => _counterValue += 15.50),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoFlipCard', '3D interactive card flip'),
          Center(
            child: SizedBox(
              width: 200,
              height: 100,
              child: ZoFlipCard(
                direction: Axis.horizontal,
                front: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Front (Tap me)', style: TextStyle(color: Colors.white)),
                ),
                back: Container(
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Text('Back', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoLikeButton', 'Icon toggle with scale and particle burst'),
          Center(
            child: ZoLikeButton(
              isLiked: _isLiked,
              size: 48,
              onToggle: (val) {
                setState(() => _isLiked = val);
              },
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoAnimatedSwitch', 'Smooth morphing toggle switch'),
          Center(
            child: ZoAnimatedSwitch(
              value: _switchValue,
              onChanged: (val) {
                setState(() => _switchValue = val);
              },
              activeIcon: Icons.dark_mode,
              inactiveIcon: Icons.light_mode,
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoSkeletonLoader', 'Continuous shimmer placeholder'),
          ZoSkeletonLoader(
            width: double.infinity,
            height: 80,
            borderRadius: 12,
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade700,
          ),
          const SizedBox(height: 28),

          _label('ZoInteractiveButton (Shimmer)', 'Shimmer variation'),
          Center(
            child: ZoInteractiveButton(
              variant: ZoButtonVariant.shimmer,
              baseColor: Colors.deepPurple,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Shimmer Tap!')));
              },
              child: const Text('Shimmer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoInteractiveButton (Heartbeat)', 'Heartbeat pulsing variation'),
          Center(
            child: ZoInteractiveButton(
              variant: ZoButtonVariant.heartbeat,
              baseColor: Colors.redAccent,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Heartbeat Tap!')));
              },
              child: const Text('Heartbeat', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoInteractiveButton (Fluid B->T)', 'Fills bottom to top'),
          Center(
            child: ZoInteractiveButton(
              variant: ZoButtonVariant.fluidFill,
              isActive: _isFluidFilled,
              fluidFillDirection: FluidFillDirection.bottomToTop,
              baseColor: Colors.grey.shade800,
              activeColor: Colors.lightBlue,
              onTap: () {
                setState(() {
                  _isFluidFilled = !_isFluidFilled;
                });
              },
              child: Text(
                _isFluidFilled ? 'Filled' : 'Empty',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 28),

          _label('ZoInteractiveButton (Fluid L->R)', 'Fills left to right'),
          Center(
            child: ZoInteractiveButton(
              variant: ZoButtonVariant.fluidFill,
              isActive: _isFluidLeftToRight,
              fluidFillDirection: FluidFillDirection.leftToRight,
              baseColor: Colors.grey.shade800,
              activeColor: Colors.teal,
              onTap: () {
                setState(() {
                  _isFluidLeftToRight = !_isFluidLeftToRight;
                });
              },
              child: Text(
                _isFluidLeftToRight ? 'Filled' : 'Empty',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          const Divider(color: Colors.grey, height: 60),
          const Text(
            'Wrapper Interactions',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),

          _label('ZoTapBounceWrapper', 'Spring bounce on tap'),
          ZoTapBounceWrapper(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bounced!'), duration: Duration(milliseconds: 500)));
            },
            child: _buildBox('Tap Me (Spring Bounce)', Colors.blueAccent),
          ),
          const SizedBox(height: 28),

          _label('ZoParticleBurstWrapper', 'Explosion of particles on tap'),
          ZoParticleBurstWrapper(
            particleColor: Colors.orangeAccent,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Boom!'), duration: Duration(milliseconds: 500)));
            },
            child: _buildBox('Tap Me (Explosion)', Colors.deepOrange),
          ),
          const SizedBox(height: 28),

          _label('ZoShakeWrapper', 'Wiggle horizontally on error'),
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
          const SizedBox(height: 28),

          _label('ZoJiggleWrapper', 'Continuous wobble rotation'),
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
          const SizedBox(height: 28),

          _label('ZoPulseWrapper', 'Continuous scaling loop'),
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
          const SizedBox(height: 28),

          _label('Zo3DTiltWrapper', 'Parallax tilt following pointer'),
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
        ],
      ),
    );
  }
}
