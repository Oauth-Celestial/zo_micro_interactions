import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/text/zo_animated_text.dart';

class ExZoAnimatedText extends StatefulWidget {
  const ExZoAnimatedText({super.key});

  @override
  State<ExZoAnimatedText> createState() => _ExZoAnimatedTextState();
}

class _ExZoAnimatedTextState extends State<ExZoAnimatedText> {
  AnimationController? _controller;
  ZoAnimatedTextType? _type;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: ZoAnimatedText(
                key: ValueKey("animatedText$_type"),
                text: "Zo Animated Text",
                type: _type ?? ZoAnimatedTextType.fancySpring,
                splitByWord: false,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                onLoaded: (c) => _controller = c,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              children: [
                DropdownButton<ZoAnimatedTextType>(
                  value: _type,
                  dropdownColor: Colors.grey[900],
                  isExpanded: true,
                  style: const TextStyle(color: Colors.white),
                  items: ZoAnimatedTextType.values
                      .map(
                        (t) => DropdownMenuItem(
                          value: t,
                          child: Text(t.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() => _type = v!),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _controller?.forward(from: 0),
                  child: const Text("PLAY REVEAL"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
