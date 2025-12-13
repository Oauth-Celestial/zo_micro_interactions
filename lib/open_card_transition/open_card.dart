import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/open_card_transition/bounce_card_wrapper.dart';

import 'package:zo_micro_interactions/open_card_transition/open_card_page_route.dart';

/// A tappable card widget that expands into a detailed page
/// using a Hero-based open-card transition.
///
/// `ZoOpenCard` is useful for creating App Store–style
/// card-to-detail animations where a compact card
/// smoothly opens into a full-page experience.
class ZoOpenCard extends StatelessWidget {
  /// Hero tag used to link the closed card and the open detail page.
  ///
  /// This must be unique across the screen.
  final String heroTag;

  /// Widget displayed when the card is in its closed state.
  final Widget closedCard;

  /// Header widget shown at the top of the opened detail page.
  ///
  /// Typically contains an image, title, or large hero content.
  final Widget detailPageHeader;

  /// Main body content of the opened detail page.
  ///
  /// ⚠️ This widget must be **non-scrollable**.
  ///
  /// Do NOT use:
  /// - ListView
  /// - GridView
  /// - SingleChildScrollView
  /// - CustomScrollView
  ///
  /// The open card page manages scrolling internally.
  final Widget detailPageBody;

  /// Duration of the open-card transition animation.
  ///
  /// Defaults to 300 milliseconds.
  final Duration transitionDuration;

  /// Animation curve used for the open-card transition.
  ///
  /// Defaults to [Curves.easeOutBack] for a subtle bounce effect.
  final Curve transitionCurve;

  /// Height of the card when it is in the closed state.
  ///
  /// Defaults to `350`.
  final double closedCardHeight;

  /// Height of the header section in the opened detail page.
  ///
  /// Defaults to `300`.
  final double openCardHeaderHeight;

  /// Creates a [ZoOpenCard].
  ///
  /// The [heroTag], [closedCard], [detailPageHeader],
  /// and [detailPageBody] parameters are required.
  const ZoOpenCard({
    super.key,
    required this.heroTag,
    required this.closedCard,
    required this.detailPageHeader,
    required this.detailPageBody,
    this.closedCardHeight = 350,
    this.openCardHeaderHeight = 300,

    this.transitionDuration = const Duration(milliseconds: 300),
    this.transitionCurve = Curves.easeOutBack,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyCardWrapper(
      onTap: () {
        Navigator.of(context).push(
          OpenCardDetailPageRoute(
            heroTag: heroTag,

            openCardHeader: detailPageHeader,
            body: detailPageBody,
            pageTransitionDuration: transitionDuration,
            transitionCurve: transitionCurve,

            openCardHeaderHeight: openCardHeaderHeight,
          ),
        );
      },
      child: Hero(
        tag: heroTag,
        child: Material(
          color: Colors.transparent,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 16.0,
            ),
            child: Container(
              color: Colors.transparent,
              height: closedCardHeight,
              child: closedCard,
            ),
          ),
        ),
      ),
    );
  }
}
