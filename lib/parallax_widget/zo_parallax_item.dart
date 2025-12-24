import 'package:flutter/widgets.dart';
import 'package:zo_micro_interactions/parallax_widget/parallax_flow_delegate.dart';

class ZoParallaxItem extends StatelessWidget {
  ZoParallaxItem({
    super.key,
    required this.child,
    required this.scrollDirection,
    this.borderRadius,
  });

  final Widget child;
  final Axis scrollDirection;
  final GlobalKey _key = GlobalKey();
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: ZoParallaxWidget(
        backgroundKey: _key,
        scrollDirection: scrollDirection,
        child: Container(key: _key, child: child),
      ),
    );
  }
}

class ZoParallaxWidget extends StatelessWidget {
  const ZoParallaxWidget({
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
      delegate: ZoParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: backgroundKey,
        scrollDirection: scrollDirection,
      ),
      children: [child],
    );
  }
}
