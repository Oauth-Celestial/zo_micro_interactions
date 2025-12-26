import 'dart:math' as math;

import 'package:flutter/material.dart';

Widget flipShuttleBuilder(
  BuildContext flightContext,
  Animation<double> animation,
  HeroFlightDirection flightDirection,
  BuildContext fromHeroContext,
  BuildContext toHeroContext,
) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, child) {
      // Rotation from 0 to Pi (180 degrees)
      final rotation = animation.value * math.pi;
      final isUnder = animation.value > 0.5;

      return Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Perspective
          ..rotateY(rotation),
        alignment: Alignment.center,
        child: isUnder
            ? Transform(
                transform: Matrix4.rotationY(math.pi),
                alignment: Alignment.center,
                child: toHeroContext.widget,
              )
            : fromHeroContext.widget,
      );
    },
  );
}
