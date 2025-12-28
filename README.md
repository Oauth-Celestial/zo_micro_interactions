
<img width="3312" heigth="600" alt="micro_banner" src="https://github.com/user-attachments/assets/5f1be0f4-ce28-4597-a272-059292526a3d" />

[![pub package](https://img.shields.io/pub/v/zo_micro_interactions.svg)](https://pub.dev/packages/zo_micro_interactions)
[![pub points](https://img.shields.io/pub/points/zo_micro_interactions?color=2E8B57&label=pub%20points)](https://pub.dev/packages/zo_micro_interactions)
[![License: MIT](https://img.shields.io/badge/license-MIT-purple.svg)](https://opensource.org/licenses/MIT)

**Zo Micro Interactions** Add life to your Flutter apps with a curated set of high-quality, motion-rich interactions.

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

# Text Animation

## 1. Animated Text

<img src="https://github.com/Oauth-Celestial/zo_micro_interactions/blob/dev/gifs/text_effect.gif?raw=true" height= 150px >

```dart
ZoAnimatedText(
  key: ValueKey('animatedText$_type'),
  text: 'Zo Animated Text',
  type: _type ?? ZoAnimatedTextType.fancySpring,
  splitByWord: false,
  style: const TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  ),
  onLoaded: (controller) => _controller = controller,
),

```

## 2.Glitch Text

<img src="https://github.com/Oauth-Celestial/zo_micro_interactions/blob/dev/gifs/glitch_text.gif?raw=true" height =280>

```dart
ZoGlitchText(
  text: 'ZoMicroInteraction',
  autoStart: true,
  onLoaded: (animationController) {
    firstController = animationController;
  },
  style: const TextStyle(
    fontSize: 42,
    fontWeight: FontWeight.bold,
    color: Colors.cyanAccent,
    fontFamily: 'monospace',
    letterSpacing: 2,
  ),
),
```

## 3.Glitch Price Text

<img src="https://github.com/Oauth-Celestial/zo_micro_interactions/blob/dev/gifs/glitch_price.gif?raw=true"  height =280>

```dart
ZoGlitchPriceText(
  price: 54200.50,
  profitColor: Colors.green,
  lossColor: Colors.red,
),
```

# Alert

![Alert](https://github.com/user-attachments/assets/da4f0840-51a4-4742-ba22-b983ef4240f8)

```dart
showZoAnimatedDialogue(
  context: context,
  animation: AnimatedDialogAnimation.scaleBounce,
  child: const CustomDialog(),
);
```

# Button

<img src="https://github.com/Oauth-Celestial/zo_micro_interactions/blob/dev/gifs/disable_button.gif?raw=true" height =280>

```dart
ZoEnableDisableButton(
  enabled: _isButtonEnabled,
  text: 'SUBMIT',
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Action Triggered!'),
      ),
    );
  },

  
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
```

# Bounce Widget

<img src="https://github.com/Oauth-Celestial/zo_micro_interactions/blob/dev/gifs/bounce_widget.gif?raw=true" height =280>

```dart
ZoBounceWidget(
  onTap: () => print('Button Pressed'),
  child: Container(
    padding: const EdgeInsets.symmetric(
      horizontal: 40,
      vertical: 16,
    ),
    decoration: BoxDecoration(
      color: Colors.black,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Text(
      'Get Started',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
),


```

# Parallax Effect

<img src="https://github.com/Oauth-Celestial/zo_micro_interactions/blob/dev/gifs/parallax.gif?raw=true" height =280>

```dart
SizedBox(
  height: 250,
  child: PageView.builder(
    controller: PageController(
      viewportFraction: 0.8,
    ),
    itemCount: imageUrls.length,
    itemBuilder: (context, index) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: ZoParallaxItem(
        scrollDirection: Axis.horizontal,
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrls[index],
          fit: BoxFit.cover,
        ),
      ),
    ),
  ),
),
```

# Open Card Animation

<img src="https://github.com/Oauth-Celestial/zo_micro_interactions/blob/dev/gifs/app_store.gif?raw=true" height =280>

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
