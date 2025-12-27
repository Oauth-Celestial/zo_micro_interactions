import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TypewriterPage()));

class TypewriterPage extends StatelessWidget {
  final List<String> texts = ["Short.", "Clean.", "Natural.", "No Packages."];

  Stream<String> textStream() async* {
    int i = 0;
    while (true) {
      String full = texts[i % texts.length];
      // Typing phase
      for (int l = 0; l <= full.length; l++) {
        yield full.substring(0, l);
        await Future.delayed(const Duration(milliseconds: 100));
      }
      await Future.delayed(const Duration(seconds: 2)); // Pause
      // Deleting phase
      for (int l = full.length; l >= 0; l--) {
        yield full.substring(0, l);
        await Future.delayed(const Duration(milliseconds: 50));
      }
      i++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: StreamBuilder<String>(
          stream: textStream(),
          builder: (context, snapshot) {
            return Text(
              "${snapshot.data ?? ''}|", // Simple "|" as a cursor
              style: const TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }
}
