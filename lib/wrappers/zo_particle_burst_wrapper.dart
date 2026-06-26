import 'package:flutter/material.dart';
import '../utils/zo_sparkle_burst.dart';

/// A wrapper that triggers a delightful particle burst around the [child] when tapped.
/// 
/// Enhances primary actions like favoriting, adding to cart, or claiming rewards.
class ZoParticleBurstWrapper extends StatelessWidget {
  final Widget child;
  
  /// Callback when the wrapper is tapped.
  final VoidCallback? onTap;
  
  /// Base color of the particles. Defaults to orange.
  final Color particleColor;
  
  /// The size of the burst area. Defaults to 200x200.
  final Size burstSize;

  const ZoParticleBurstWrapper({
    super.key,
    required this.child,
    this.onTap,
    this.particleColor = Colors.orange,
    this.burstSize = const Size(200, 200),
  });

  @override
  Widget build(BuildContext context) {
    return SparkleBurstWrapper(
      sparkleColor: particleColor,
      size: burstSize,
      builder: (context, controller) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            controller.forward(from: 0.0);
            onTap?.call();
          },
          child: child,
        );
      },
    );
  }
}
