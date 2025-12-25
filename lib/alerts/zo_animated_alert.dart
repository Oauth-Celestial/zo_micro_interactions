import 'package:flutter/widgets.dart';

enum AnimatedDialogAnimation { scaleBounce, fade, slideUp, scaleFade }

void showZoAnimatedDialogue({
  required BuildContext context,
  required Widget child,

  AnimatedDialogAnimation animation = AnimatedDialogAnimation.scaleBounce,

  bool barrierDismissible = true,

  Color barrierColor = const Color(0x66000000),
  Duration transitionDuration = const Duration(milliseconds: 350),
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: "dialog",
    barrierColor: barrierColor,
    transitionDuration: transitionDuration,

    transitionBuilder:
        (context, animationCtrl, secondaryAnimation, dialogChild) {
          switch (animation) {
            /// 🔹 SCALE BOUNCE (0 → 1.1 → 1.0)
            case AnimatedDialogAnimation.scaleBounce:
              final scaleAnimation =
                  TweenSequence<double>([
                    TweenSequenceItem(
                      tween: Tween(begin: 0.0, end: 1.1),
                      weight: 30,
                    ),
                    TweenSequenceItem(
                      tween: Tween(begin: 1.1, end: 1.0),
                      weight: 70,
                    ),
                  ]).animate(
                    CurvedAnimation(
                      parent: animationCtrl,
                      curve: Curves.easeInOutCubic,
                    ),
                  );

              return Transform.scale(
                scale: scaleAnimation.value,
                child: Opacity(
                  opacity: animationCtrl.value,
                  child: dialogChild,
                ),
              );

            /// 🔹 FADE
            case AnimatedDialogAnimation.fade:
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: animationCtrl,
                  curve: Curves.easeInOut,
                ),
                child: dialogChild,
              );

            case AnimatedDialogAnimation.slideUp:
              final slideAnimation =
                  Tween<Offset>(
                    begin: const Offset(0, 0.25),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animationCtrl,
                      curve: Curves.easeOutCubic,
                    ),
                  );

              return SlideTransition(
                position: slideAnimation,
                child: FadeTransition(
                  opacity: animationCtrl,
                  child: dialogChild,
                ),
              );

            case AnimatedDialogAnimation.scaleFade:
              final scale = Tween<double>(begin: 0.9, end: 1.0).animate(
                CurvedAnimation(parent: animationCtrl, curve: Curves.easeOut),
              );

              return Transform.scale(
                scale: scale.value,
                child: FadeTransition(
                  opacity: animationCtrl,
                  child: dialogChild,
                ),
              );
          }
        },

    pageBuilder: (_, _, _) {
      return Center(child: child);
    },
  );
}
