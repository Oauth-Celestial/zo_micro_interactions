import 'package:flutter/widgets.dart';
import 'package:zo_micro_interactions/parallax_widget/parallax_flow_delegate.dart';

class ParallaxItem extends StatelessWidget {
  ParallaxItem({
    super.key,
    required this.imageUrl,
    required this.scrollDirection,
  });

  final String imageUrl;
  final Axis scrollDirection;
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ParallaxWidget(
          backgroundKey: _key,
          scrollDirection: scrollDirection,
          child: Image.network(imageUrl, key: _key, fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class ParallaxWidget extends StatelessWidget {
  const ParallaxWidget({
    super.key,
    required this.backgroundKey,
    required this.child,
    this.scrollDirection = Axis.horizontal,
  });

  final GlobalKey backgroundKey;
  final Widget child;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: backgroundKey,
        scrollDirection: scrollDirection,
      ),
      children: [child],
    );
  }
}
