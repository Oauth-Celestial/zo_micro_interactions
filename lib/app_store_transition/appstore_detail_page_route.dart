import 'package:flutter/material.dart';
import 'package:zo_micro_interactions/app_store_transition/detail_screen.dart';

class AppStoreDetailPageRoute extends PageRouteBuilder {
  final String heroTag;
  final Color cardColor;
  final Widget openCardHeader;
  final Widget body;

  final Duration transitionDuration;
  final Curve transitionCurve;
  BorderRadiusGeometry? borderRadius;
  double openCardHeaderHeight;

  AppStoreDetailPageRoute({
    required this.heroTag,
    required this.cardColor,
    required this.openCardHeader,
    required this.body,
    required this.transitionDuration,
    required this.transitionCurve,
    this.borderRadius,
    this.openCardHeaderHeight = 300,
  }) : super(
         opaque: false,
         transitionDuration: transitionDuration,
         pageBuilder: (context, animation, secondaryAnimation) => DetailScreen(
           heroTag: heroTag,
           cardColor: cardColor,
           openCardHeader: openCardHeader,
           body: body,
           transitionCurve: transitionCurve,
           routeAnimation: animation,
           openCardHeaderHeight: openCardHeaderHeight,
           borderRadius: borderRadius,
         ),
       );
}
