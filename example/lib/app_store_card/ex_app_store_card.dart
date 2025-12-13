import 'package:flutter/material.dart';

import 'package:zo_micro_interactions/open_card_transition/open_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Today'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'FRIDAY, DEC 12',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured Stories',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ),

          // -------- CARD 1 --------
          ZoOpenCard(
            heroTag: 'cosmic_run',

            closedCard: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: const DecorationImage(
                  image: NetworkImage(
                    'https://images.unsplash.com/photo-1511512578047-dfb367046420',
                  ),
                  fit: BoxFit.cover,
                ),
              ),

              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Game of the Day',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  Spacer(),
                  Text(
                    'Cosmic Run',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            detailPageHeader: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1511512578047-dfb367046420',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withOpacity(0.35)),
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Cosmic Run',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            detailPageBody: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Cosmic Run: The Final Review',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'A fast-paced space runner with stunning visuals, tight controls, '
                    'and addictive gameplay loops. Easily one of the best mobile games this year.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                  SizedBox(height: 24),
                  Text('End of Article.', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ),

          // -------- CARD 2 --------
          ZoOpenCard(
            heroTag: 'ai_future',
            openCardHeaderHeight: 200,
            closedCardHeight: 200,
            closedCard: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1534759846116-5799c33ce22a',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withOpacity(0.35)),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Must-Read Article',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Spacer(),
                      Text(
                        'The AI Future',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            detailPageHeader: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1534759846116-5799c33ce22a',
                  fit: BoxFit.cover,
                ),
                Container(color: Colors.black.withOpacity(0.35)),
                const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 16),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'The AI Future',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            detailPageBody: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Decoding the Future of Neural Networks',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'From generative models to autonomous systems, '
                    'this deep dive explores where AI is heading—and what it means for developers.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
