import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

/// Animation types matching ZoAnimatedText effects
/// Using simple progress calculation instead of complex staggered intervals
enum SimpleCharAnimationType {
  fadeBlur, // Fade in with blur effect
  slideUp, // Slide up with fade (using FractionalTranslation)
  chaos, // Random positions with fade
  flipUp, // 3D flip up effect
  swirl, // Rotate + scale + fade
  syncFade, // All characters fade together (same as fadeBlur)
  fancySpring, // Spring physics with blur, rotation, scale
}

/// Simple example demonstrating character-by-character animation
///
/// HOW IT WORKS:
/// ============
///
/// 1. TEXT SPLITTING:
///    - The input text is split into individual characters
///    - Each character becomes a separate widget that can be animated independently
///
/// 2. ANIMATION CONTROLLER:
///    - A single AnimationController manages the overall animation timeline (0.0 to 1.0)
///    - This controller runs from 0.0 (start) to 1.0 (end) over the duration
///
/// 3. STAGGERED INTERVALS:
///    - Each character gets its own "time window" within the animation
///    - Character 0 starts at 0.0, Character 1 starts slightly later, etc.
///    - This creates the cascading/staggered effect
///
/// 4. INTERVAL CALCULATION:
///    - Example: "Hello" (5 chars) with stagger = 0.1
///    - Total weight = 1.0 + (5-1) * 0.1 = 1.4
///    - Each char gets: 1.0 / 1.4 ≈ 71% of the timeline
///    - Char 0: animates from 0.0 to 0.71
///    - Char 1: animates from 0.07 to 0.78
///    - Char 2: animates from 0.14 to 0.85
///    - etc.
///
/// 5. INDIVIDUAL CHARACTER ANIMATION:
///    - Each character listens to the controller
///    - Maps the controller value (0.0-1.0) to its own interval
///    - Applies transformations (opacity, translate, etc.) based on its animation value
///
/// KEY CONCEPTS:
/// - Single controller, multiple intervals (efficient!)
/// - Stagger creates the sequential effect
/// - Each character's animation is independent but synchronized
class SimpleCharAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Duration duration;
  final double
  stagger; // Optional: Not used in simple sequential version, but kept for compatibility
  final SimpleCharAnimationType type; // Animation type

  const SimpleCharAnimation({
    super.key,
    required this.text,
    this.style,
    this.duration = const Duration(milliseconds: 2000),
    this.stagger =
        0.1, // Not used in simple version - each char gets equal progress
    this.type = SimpleCharAnimationType.fadeBlur,
  });

  @override
  State<SimpleCharAnimation> createState() => _SimpleCharAnimationState();
}

class _SimpleCharAnimationState extends State<SimpleCharAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<String> _characters;

  @override
  void initState() {
    super.initState();

    // Step 1: Create an AnimationController
    // This controls the overall animation timeline (0.0 to 1.0)
    _controller = AnimationController(vsync: this, duration: widget.duration);

    // Step 2: Split text into individual characters
    _characters = widget.text.split('');

    // Start the animation automatically
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: List.generate(_characters.length, (index) {
        // Step 3: SIMPLE VERSION - Divide progress equally among characters!
        //
        // Progress goes from 0.0 to 1.0 (like 0% to 100%)
        // If we have 10 characters, each gets 10% of the progress
        //
        // Example with 10 characters:
        // - Character 0: animates from 0.0 to 0.1 (0% to 10%)
        // - Character 1: animates from 0.1 to 0.2 (10% to 20%)
        // - Character 2: animates from 0.2 to 0.3 (20% to 30%)
        // - ... and so on
        //
        // Special case: syncFade - all characters animate together (0.0 to 1.0)
        final bool isSync = widget.type == SimpleCharAnimationType.syncFade;

        final double start = isSync ? 0.0 : (index / _characters.length);
        final double end = isSync ? 1.0 : ((index + 1) / _characters.length);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Step 4: How animated should THIS character be right now?
            //
            // The controller tells us: "What time is it?" (0.0 to 1.0)
            // We need to figure out: "How far along is THIS character's animation?"
            //
            // If it's too early (before start): not animated yet (0.0)
            // If it's too late (after end): fully animated (1.0)
            // If it's in between: calculate how far along (0.0 to 1.0)

            final double currentTime = _controller.value;

            double charValue;
            if (currentTime < start) {
              // Too early - character hasn't started animating yet
              charValue = 0.0;
            } else if (currentTime > end) {
              // Too late - character is done animating
              charValue = 1.0;
            } else {
              // Right in the middle - calculate progress
              // Example: if start=0.2, end=0.6, currentTime=0.4
              // Progress = (0.4 - 0.2) / (0.6 - 0.2) = 0.5 (halfway!)
              charValue = (currentTime - start) / (end - start);
            }

            // Step 5: Apply easing curve to make it feel natural!
            // Curves.easeOutCubic: starts fast, slows down at the end (feels natural)
            final double easedValue = Curves.easeOutCubic.transform(charValue);

            // Step 6: Apply different animation types based on the enum
            return _buildAnimatedCharacter(easedValue, index);
          },
        );
      }),
    );
  }

  /// Build the animated character based on the animation type
  /// Using simple progress calculation (easedValue) instead of complex staggered intervals
  Widget _buildAnimatedCharacter(double easedValue, int index) {
    final childText = Text(_characters[index], style: widget.style);
    final inv = 1.0 - easedValue; // Inverse value for exit animations
    final currentValue = easedValue; // Using eased value for consistency

    switch (widget.type) {
      case SimpleCharAnimationType.fancySpring:
        // Spring physics animation with blur, rotation, and scale
        const springDesc = SpringDescription(
          mass: 0.8,
          stiffness: 300,
          damping: 10,
        );
        const maxOffset = 50.0;
        const maxRotation = 45.0;
        const minScale = 0.3;
        const maxBlur = 14.0;

        // Use character index as seed for consistent random values
        final random = math.Random(_characters[index].hashCode);
        final initialY = (random.nextDouble() * 2 - 1) * maxOffset;
        final initialRotation = (random.nextDouble() * 2 - 1) * maxRotation;

        final springCurve = SpringSimulation(springDesc, 0, 1, 0);
        final springValue = springCurve.x(currentValue);

        final currentY = initialY * (1 - springValue);
        final currentRotation = initialRotation * (1 - springValue);
        final currentScale = minScale + (1 - minScale) * springValue;
        final blurAmount = (1 - springValue) * maxBlur;

        return Transform(
          transform: Matrix4.identity()
            ..translate(0.0, currentY)
            ..rotateZ(currentRotation * math.pi / 180)
            ..scale(currentScale),
          alignment: Alignment.center,
          child: Opacity(
            opacity: springValue.clamp(0.0, 1.0),
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: blurAmount,
                sigmaY: blurAmount,
              ),
              child: childText,
            ),
          ),
        );

      case SimpleCharAnimationType.fadeBlur:
      case SimpleCharAnimationType.syncFade:
        // Fade in with blur effect
        return Opacity(
          opacity: currentValue,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 10 * inv, sigmaY: 10 * inv),
            child: childText,
          ),
        );

      case SimpleCharAnimationType.slideUp:
        // Slide up with fade (using FractionalTranslation like original)
        return FractionalTranslation(
          translation: Offset(0, 0.5 * inv),
          child: Opacity(opacity: currentValue, child: childText),
        );

      case SimpleCharAnimationType.chaos:
        // Random positions with fade
        final rnd = math.Random(_characters[index].hashCode);
        final x = (rnd.nextDouble() * 200 - 100) * inv;
        final y = (rnd.nextDouble() * 200 - 100) * inv;
        return Transform.translate(
          offset: Offset(x, y),
          child: Opacity(opacity: currentValue, child: childText),
        );

      case SimpleCharAnimationType.flipUp:
        // 3D flip up effect
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(inv * math.pi / 2),
          alignment: Alignment.bottomCenter,
          child: Opacity(
            opacity: currentValue.clamp(0.0, 1.0),
            child: childText,
          ),
        );

      case SimpleCharAnimationType.swirl:
        // Rotate + scale + fade
        return Transform.rotate(
          angle: inv * math.pi,
          child: Transform.scale(
            scale: currentValue,
            child: Opacity(opacity: currentValue, child: childText),
          ),
        );
    }
  }
}

/// Example usage widget
class ExSimpleCharAnimation extends StatefulWidget {
  const ExSimpleCharAnimation({super.key});

  @override
  State<ExSimpleCharAnimation> createState() => _ExSimpleCharAnimationState();
}

class _ExSimpleCharAnimationState extends State<ExSimpleCharAnimation> {
  int _key = 0; // Key to force widget rebuild and restart animation
  SimpleCharAnimationType _selectedType = SimpleCharAnimationType.fadeBlur;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Simple character animation example
            // Using a key to restart animation when key changes
            SimpleCharAnimation(
              key: ValueKey("$_key$_selectedType"),
              text:
                  "Hello World! Hello World! Hello World! Hello World! Hello World!",
              type: _selectedType,
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
              duration: const Duration(milliseconds: 2000),
              stagger: 0.1,
            ),

            const SizedBox(height: 60),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                children: [
                  Text(
                    "Simple character-by-character animation example",
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  // Dropdown to select animation type
                  DropdownButton<SimpleCharAnimationType>(
                    value: _selectedType,
                    dropdownColor: Colors.grey[900],
                    isExpanded: true,
                    style: const TextStyle(color: Colors.white),
                    items: SimpleCharAnimationType.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(t.name.toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() {
                      _selectedType = v!;
                    }),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () {
                      // Change key to force widget rebuild and restart animation
                      setState(() {
                        _key++;
                      });
                    },
                    child: const Text("Restart Animation"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
