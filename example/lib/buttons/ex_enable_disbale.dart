import 'package:flutter/material.dart';
// Replace this with your actual import path
import 'package:zo_micro_interactions/button/zo_enable_disable_button.dart';

class ExZoEnableDisableButton extends StatefulWidget {
  const ExZoEnableDisableButton({super.key});

  @override
  State<ExZoEnableDisableButton> createState() =>
      _ExZoEnableDisableButtonState();
}

class _ExZoEnableDisableButtonState extends State<ExZoEnableDisableButton> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    // Listen to text changes to toggle button state
    _controller.addListener(() {
      setState(() {
        _isButtonEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ZoButton Example')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),

            // Your Custom Widget
            ZoEnableDisableButton(
              enabled: _isButtonEnabled,
              text: 'SUBMIT',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action Triggered!')),
                );
              },
              // Styling for the "Enabled" state
              enabledDecoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              enabledTextStyle: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              // Styling for the "Disabled" state
              disabledDecoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              disabledTextStyle: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
