import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/alerts/zo_animated_alert.dart';

class ExZoAlerts extends StatelessWidget {
  const ExZoAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dialog Demo")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                showZoAnimatedDialogue(
                  context: context,
                  animation: AnimatedDialogAnimation.scaleBounce,
                  child: const CustomDialog(),
                );
              },
              child: const Text("Scale Bounce"),
            ),

            ElevatedButton(
              onPressed: () {
                showZoAnimatedDialogue(
                  context: context,
                  animation: AnimatedDialogAnimation.slideUp,
                  child: const CustomDialog(),
                );
              },
              child: const Text("Slide Up"),
            ),
            ElevatedButton(
              onPressed: () {
                showZoAnimatedDialogue(
                  context: context,
                  animation: AnimatedDialogAnimation.scaleFade,
                  child: const CustomDialog(),
                );
              },
              child: const Text("Scale Fade"),
            ),

            ElevatedButton(
              onPressed: () {
                showZoAnimatedDialogue(
                  context: context,
                  animation: AnimatedDialogAnimation.fade,
                  child: const CustomDialog(),
                );
              },
              child: const Text("Fade"),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  const CustomDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 25,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Custom Dialog",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              "Reusable dialog with fluid animations.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
