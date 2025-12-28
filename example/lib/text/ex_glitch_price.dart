import 'dart:math';
import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/text/zo_glitch_price.dart';

class ExZoGlitchPrice extends StatefulWidget {
  const ExZoGlitchPrice({super.key});
  @override
  State<ExZoGlitchPrice> createState() => _ExZoGlitchPriceState();
}

class _ExZoGlitchPriceState extends State<ExZoGlitchPrice> {
  double _price = 54200.50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Just pass the price; the widget handles the rest internally
            ZoGlitchPriceText(
              price: _price,
              profitColor: Colors.green,
              lossColor: Colors.red,
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () =>
                  setState(() => _price += (Random().nextDouble() * 100) - 50),
              child: const Text("Update Price"),
            ),
          ],
        ),
      ),
    );
  }
}
