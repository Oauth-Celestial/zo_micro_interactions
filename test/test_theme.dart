import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() => runApp(const ThemeSwitcherApp());

class ThemeSwitcherApp extends StatefulWidget {
  const ThemeSwitcherApp({super.key});

  @override
  State<ThemeSwitcherApp> createState() => _ThemeSwitcherAppState();
}

class _ThemeSwitcherAppState extends State<ThemeSwitcherApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: _themeMode,
      home: ThemeRevealSwitcher(
        onToggle: toggleTheme,
        child: const ExampleDashboard(),
      ),
    );
  }
}

/// The Wrapper that handles the screenshot and the clipping animation
class ThemeRevealSwitcher extends StatefulWidget {
  final Widget child;
  final VoidCallback onToggle;

  const ThemeRevealSwitcher({
    super.key,
    required this.child,
    required this.onToggle,
  });

  static _ThemeRevealSwitcherState? of(BuildContext context) =>
      context.findAncestorStateOfType<_ThemeRevealSwitcherState>();

  @override
  State<ThemeRevealSwitcher> createState() => _ThemeRevealSwitcherState();
}

class _ThemeRevealSwitcherState extends State<ThemeRevealSwitcher>
    with SingleTickerProviderStateMixin {
  final GlobalKey _screenKey = GlobalKey();
  ui.Image? _oldScreenshot;
  late AnimationController _controller;
  Offset _revealOrigin = Offset.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  Future<void> triggerUpdate(GlobalKey triggerKey) async {
    if (_controller.isAnimating) return;

    // 1. Find the position of the widget that triggered this
    final RenderBox? triggerBox =
        triggerKey.currentContext?.findRenderObject() as RenderBox?;
    final RenderRepaintBoundary? boundary =
        _screenKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (triggerBox == null || boundary == null) return;

    // Calculate the center point of the trigger widget
    final Offset offset = triggerBox.localToGlobal(Offset.zero);
    _revealOrigin = Offset(
      offset.dx + (triggerBox.size.width / 2),
      offset.dy + (triggerBox.size.height / 2),
    );

    // 2. Capture the current screen state
    try {
      // Ensure the frame is ready for capture
      if (boundary.debugNeedsPaint) {
        await WidgetsBinding.instance.endOfFrame;
      }

      final double pixelRatio = View.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: pixelRatio);

      setState(() {
        _oldScreenshot = image;
      });

      // 3. Switch the theme and play animation
      widget.onToggle();
      _controller.forward(from: 0).then((_) {
        setState(() => _oldScreenshot = null);
      });
    } catch (e) {
      // Fallback: Just toggle if capture fails
      widget.onToggle();
      debugPrint("Capture failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // The Live Application (New Theme)
        RepaintBoundary(key: _screenKey, child: widget.child),

        // The Snapshot Overlay (Old Theme)
        if (_oldScreenshot != null)
          IgnorePointer(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return ClipPath(
                  clipper: InvertedCircularRevealClipper(
                    fraction: CurvedAnimation(
                      parent: _controller,
                      curve: Curves.easeInOutCirc,
                    ).value,
                    center: _revealOrigin,
                  ),
                  child: RawImage(
                    image: _oldScreenshot,
                    fit: BoxFit.fill,
                    // Ensure the image fills the entire view
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Draws the screen then subtracts a circle from the center point
class InvertedCircularRevealClipper extends CustomClipper<Path> {
  final double fraction;
  final Offset center;

  InvertedCircularRevealClipper({required this.fraction, required this.center});

  @override
  Path getClip(Size size) {
    final path = Path();
    final maxRadius = _calculateDistance(center, size);

    // Add full screen rect
    path.addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Add the expanding hole (The circle reveal)
    path.addOval(Rect.fromCircle(center: center, radius: maxRadius * fraction));

    // PathFillType.evenOdd makes the oval act as a hole in the rectangle
    return path..fillType = PathFillType.evenOdd;
  }

  double _calculateDistance(Offset p, Size size) {
    double d1 = p.distance;
    double d2 = (p - Offset(size.width, 0)).distance;
    double d3 = (p - Offset(0, size.height)).distance;
    double d4 = (p - Offset(size.width, size.height)).distance;
    return [d1, d2, d3, d4].reduce((a, b) => a > b ? a : b);
  }

  @override
  bool shouldReclip(InvertedCircularRevealClipper oldClipper) =>
      fraction != oldClipper.fraction || center != oldClipper.center;
}

// --- Dashboard Implementation ---

class ExampleDashboard extends StatelessWidget {
  const ExampleDashboard({super.key});

  // Unique key for the toggle button
  static final GlobalKey _toggleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Origin Theme Switcher"),
        actions: [
          // This is the button that triggers the origin reveal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              key: _toggleKey,
              onPressed: () {
                ThemeRevealSwitcher.of(context)?.triggerUpdate(_toggleKey);
              },
              icon: Icon(
                isDark ? Icons.wb_sunny_rounded : Icons.nightlight_round,
              ),
              style: IconButton.styleFrom(
                backgroundColor: theme.colorScheme.primaryContainer,
                foregroundColor: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Market Overview", style: theme.textTheme.headlineMedium),
            const SizedBox(height: 20),
            ...List.generate(
              3,
              (index) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(child: Text("${index + 1}")),
                  title: Text("Stock Asset Analysis #$index"),
                  subtitle: const Text("Real-time data synchronization..."),
                  trailing: const Icon(Icons.trending_up, color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text("Graphic Data Visualization")),
            ),
          ],
        ),
      ),
    );
  }
}
