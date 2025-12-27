import 'package:flutter/widgets.dart';

class ZoParallaxFlowDelegate extends FlowDelegate {
  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
  final Axis scrollDirection;

  ZoParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
    required this.scrollDirection,
  }) : super(repaint: scrollable.position);

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    if (scrollDirection == Axis.horizontal) {
      return BoxConstraints.tightFor(height: constraints.maxHeight);
    } else {
      return BoxConstraints.tightFor(width: constraints.maxWidth);
    }
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;

    final listItemOffset = listItemBox.localToGlobal(
      scrollDirection == Axis.horizontal
          ? listItemBox.size.topCenter(Offset.zero)
          : listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    final viewportDimension = scrollable.position.viewportDimension;

    // Determine scroll fraction based on the active axis
    final scrollFraction =
        (scrollDirection == Axis.horizontal
                ? listItemOffset.dx / viewportDimension
                : listItemOffset.dy / viewportDimension)
            .clamp(0.0, 1.0);

    // Create alignment (-1 to 1)
    final alignment = scrollDirection == Axis.horizontal
        ? Alignment(scrollFraction * 2 - 1, 0)
        : Alignment(0, scrollFraction * 2 - 1);

    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect = alignment.inscribe(
      backgroundSize,
      Offset.zero & listItemSize,
    );

    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(
          scrollDirection == Axis.horizontal ? childRect.left : 0,
          scrollDirection == Axis.vertical ? childRect.top : 0,
        ),
      ).transform,
    );
  }

  @override
  bool shouldRepaint(ZoParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey ||
        scrollDirection != oldDelegate.scrollDirection;
  }
}
