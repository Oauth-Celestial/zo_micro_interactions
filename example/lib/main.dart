import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:zo_micro_interactions/zo_micro_interactions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Store Card Transition Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  Widget _buildClosedCardContent(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpenCardHeader(Color color, String title) {
    return Container(
      color: color,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0, left: 20.0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBodyContent(String title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            'This card now features the subtle pop-in, fade, and slide animation from the Dribbble shot immediately after the Hero transition completes. Notice the smooth movement of this text.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),

          const Text(
            'End of Article.',
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color cardColor1 = Colors.deepOrange;
    const Color cardColor2 = Colors.blueGrey;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'FRIDAY, DEC 12',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Featured Stories',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),

          // --- Custom Card 1 ---
          AppStoreCardTransition(
            heroTag: 'game_day',
            cardColor: cardColor1,
            closedCard: _buildClosedCardContent(
              'Cosmic Run',
              'Game of the Day',
            ),
            openCardHeader: _buildOpenCardHeader(cardColor1, 'Cosmic Run'),
            body: _buildBodyContent('Cosmic Run: The Final Review'),
          ),

          // --- Custom Card 2 ---
          AppStoreCardTransition(
            heroTag: 'ai_future',
            cardColor: cardColor2,
            closedCard: _buildClosedCardContent(
              'The AI Future',
              'Must-Read Article',
            ),
            openCardHeader: _buildOpenCardHeader(cardColor2, 'The AI Future'),
            body: _buildBodyContent('Decoding the Future of Neural Networks'),
          ),
        ],
      ),
    );
  }
}
