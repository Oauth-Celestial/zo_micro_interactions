import 'package:flutter/material.dart';
import '../utils/zo_sparkle_burst.dart';

/// A celebration popup dialog that enters with a spring animation and
/// emits a burst of particles behind or around the dialog content.
///
/// Use [showZoBurstPopup] to easily display this dialog.
class ZoBurstPopup extends StatefulWidget {
  final Widget child;
  final Color burstColor;
  final Duration entranceDuration;

  const ZoBurstPopup({
    super.key,
    required this.child,
    this.burstColor = const Color(0xFFFFD700),
    this.entranceDuration = const Duration(milliseconds: 600),
  });

  @override
  State<ZoBurstPopup> createState() => _ZoBurstPopupState();
}

class _ZoBurstPopupState extends State<ZoBurstPopup>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _burstController;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: widget.entranceDuration,
    );

    _burstController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleController.forward().then((_) {
      _burstController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _burstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Burst Effect
            SizedBox(
              width: 300,
              height: 300,
              child: AnimatedBuilder(
                animation: _burstController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: SparklePainter(
                      progress: _burstController.value,
                      color: widget.burstColor,
                    ),
                  );
                },
              ),
            ),
            // Dialog Content
            ScaleTransition(
              scale: CurvedAnimation(
                parent: _scaleController,
                curve: Curves.elasticOut,
              ),
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper function to show the burst popup.
Future<T?> showZoBurstPopup<T>({
  required BuildContext context,
  required Widget child,
  Color burstColor = const Color(0xFFFFD700),
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) {
      return ZoBurstPopup(
        burstColor: burstColor,
        child: child,
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
