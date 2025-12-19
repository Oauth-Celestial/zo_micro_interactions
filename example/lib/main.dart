import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/parallax_widget/zo_parallax_item.dart';

void main() {
  runApp(const ParallaxApp());
}

class ParallaxApp extends StatelessWidget {
  const ParallaxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ParallaxExampleScreen(),
    );
  }
}

class ParallaxExampleScreen extends StatelessWidget {
  const ParallaxExampleScreen({super.key});

  final List<String> imageUrls = const [
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1470770841072-f978cf4d019e?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?auto=format&fit=crop&w=800&q=80',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flexible Parallax')),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Horizontal Parallax (PageView)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // --- HORIZONTAL EXAMPLE ---
          SizedBox(
            height: 250,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.8),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: ParallaxItem(
                  child: Image.network(imageUrls[index], fit: BoxFit.cover),
                  scrollDirection: Axis.horizontal,
                ),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Vertical Parallax (ListView)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          // --- VERTICAL EXAMPLE ---
          ...imageUrls.map(
            (url) => SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ParallaxItem(
                  child: Image.network(url, fit: BoxFit.cover),
                  scrollDirection: Axis.vertical,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- ITEM COMPONENT ---
