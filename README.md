# zo_micro_interactions

[![pub package](https://img.shields.io/pub/v/zo_micro_interactions.svg)](https://pub.dev/packages/zo_micro_interactions)
[![pub points](https://img.shields.io/pub/points/zo_micro_interactions?color=2E8B57&label=pub%20points)](https://pub.dev/packages/zo_micro_interactions)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

**Zo Micro Interactions** A curated set of high-quality Flutter micro-interactions designed for modern, polished apps.

## Getting started

First, add zo_micro_interactions as a dependency in your pubspec.yaml file

```yaml
dependencies:
  flutter:
    sdk: flutter
  zo_micro_interactions : ^[version]
```

## Import the package

```dart
import 'package:zo_micro_interactions/zo_micro_interactions.dart';
```

# Usage

Open Card Animation

![Simulator Screen Recording - iPhone 15 Pro - 2025-12-13 at 16 28 47 (online-video-cutter com)](https://github.com/user-attachments/assets/0bf03c35-6f5a-4e6c-ace7-141f85b60828)

```dart
ZoOpenCard(
  heroTag: 'cosmic_run',

  closedCard: Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: NetworkImage(
           "your-url",
        ),
        fit: BoxFit.cover,
      ),
    ),
    padding: const EdgeInsets.all(16),
    child: const Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        'Cosmic Run',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ),

  detailPageHeader: Image.network(
     "your-url",
    fit: BoxFit.cover,
  ),

  detailPageBody: const Padding(
    padding: EdgeInsets.all(20),
    child: Text(
      'A fast-paced space runner with stunning visuals and addictive gameplay.',
      style: TextStyle(fontSize: 16),
    ),
  ),
);
```

- **`heroTag`**
  - A unique identifier used by Flutter’s `Hero` widget.
  - Links the closed card and the opened detail page for a smooth transition.

- **`closedCard`**
  - The widget displayed when the card is in its collapsed state.
  - Typically used to show a preview such as an image, title, or summary.

- **`detailPageHeader`**
  - The header section of the opened detail page.
  - Usually contains a hero image or prominent title that expands from the card.

- **`detailPageBody`**
  - The main content of the opened detail page.
  - Must be **non-scrollable** — scrolling is handled internally by `ZoOpenCard`.
  - Use layout widgets like `Column`, `Padding`, and `Text`.
Feel free to post a feature requests or report a bug [issues](https://github.com/Oauth-Celestial/zo_micro_interactions/issues).

## My Other packages

- [zo_animated_border](https://pub.dev/packages/zo_animated_border): A package that provides a modern way to create gradient borders with animation in Flutter
- [zo_screenshot](https://pub.dev/packages/zo_screenshot): The zo_screenshot plugin helps restrict screenshots and screen recording in Flutter apps, enhancing security and privacy by preventing unauthorized screen captures.
- [zo_collection_animation](https://pub.dev/packages/zo_collection_animation): A lightweight Flutter package to create smooth collect animations for coins carts
- [connectivity_watcher](https://pub.dev/packages/connectivity_watcher): A Flutter package to monitor internet connectivity with subsecond response times, even on mobile networks.
- [ultimate_extension](https://pub.dev/packages/ultimate_extension): Enhances Dart collections and objects with utilities for advanced data manipulation and simpler coding.
- [theme_manager_plus](https://pub.dev/packages/theme_manager_plus): Allows customization of your app's theme with your own theme class, eliminating the need for traditional
- [date_util_plus](https://pub.dev/packages/date_util_plus): A powerful Dart API designed to augment and simplify date and time handling in your Dart projects.
- [pick_color](https://pub.dev/packages/pick_color): A Flutter package that allows you to extract colors and hex codes from images with a simple touch.
