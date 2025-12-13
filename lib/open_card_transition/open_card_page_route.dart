import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/open_card_transition/detail_screen.dart';

class OpenCardDetailPageRoute extends PageRouteBuilder {
  final String heroTag;

  final Widget openCardHeader;
  final Widget body;

  final Duration pageTransitionDuration;
  final Curve transitionCurve;

  double openCardHeaderHeight;

  OpenCardDetailPageRoute({
    required this.heroTag,

    required this.openCardHeader,
    required this.body,
    required this.pageTransitionDuration,
    required this.transitionCurve,

    this.openCardHeaderHeight = 300,
  }) : super(
         opaque: false,
         transitionDuration: pageTransitionDuration,
         pageBuilder: (context, animation, secondaryAnimation) =>
             ZoOpenCardDetailPage(
               heroTag: heroTag,

               openCardHeader: openCardHeader,
               body: body,
               transitionCurve: transitionCurve,
               routeAnimation: animation,
               openCardHeaderHeight: openCardHeaderHeight,
             ),
       );
}
