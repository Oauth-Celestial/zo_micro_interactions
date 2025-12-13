import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/app_store_transition/appstore_detail_page_route.dart';
import 'package:zo_micro_interactions/app_store_transition/bounce_card_wrapper.dart';

class AppStoreCardTransition extends StatelessWidget {
  final String heroTag;
  final Widget closedCard;
  final Widget openCardHeader;
  final Widget body;
  final Color cardColor;
  final Duration transitionDuration;
  final Curve transitionCurve;
  final double cardHeight;
  BorderRadiusGeometry? borderRadius;
  double openCardHeaderHeight;

  AppStoreCardTransition({
    super.key,
    required this.heroTag,
    required this.closedCard,
    required this.openCardHeader,
    required this.body,
    this.cardHeight = 350,
    this.openCardHeaderHeight = 300,
    this.borderRadius,
    required this.cardColor,

    this.transitionDuration = const Duration(milliseconds: 600),
    this.transitionCurve = Curves.easeOutBack,
  });

  @override
  Widget build(BuildContext context) {
    borderRadius ??= BorderRadius.circular(20);

    return BouncyCardWrapper(
      onTap: () {
        Navigator.of(context).push(
          AppStoreDetailPageRoute(
            heroTag: heroTag,
            cardColor: cardColor,
            openCardHeader: openCardHeader,
            body: body,
            transitionDuration: transitionDuration,
            transitionCurve: transitionCurve,
            borderRadius: borderRadius,
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
              height: cardHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),

                color: cardColor,
              ),
              child: closedCard,
            ),
          ),
        ),
      ),
    );
  }
}
