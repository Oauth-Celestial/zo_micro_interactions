import 'dart:ui';

import 'package:flutter/material.dart';

class DetailScreen extends StatefulWidget {
  final String heroTag;
  final Color cardColor;
  final Widget openCardHeader;
  final Widget body;
  final Curve transitionCurve;
  final Animation<double> routeAnimation;
  BorderRadiusGeometry? borderRadius;
  double openCardHeaderHeight;

  DetailScreen({
    required this.heroTag,
    required this.cardColor,
    required this.openCardHeader,
    required this.body,
    required this.transitionCurve,
    required this.routeAnimation,
    this.openCardHeaderHeight = 300,
    this.borderRadius,
  });

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();

  // Animation controllers and animations for the subtle content pop-in
  late AnimationController _subtleAnimationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _translateAnimation;

  @override
  void initState() {
    super.initState();

    // Controller for the subtle pop-in effect (500ms duration)
    _subtleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    // 1. Scale Animation: Starts slightly large (1.005) and scales down to normal (1.0)
    _scaleAnimation = Tween<double>(begin: 1.005, end: 1.0).animate(
      CurvedAnimation(
        parent: _subtleAnimationController,
        curve: Curves.easeOutCubic,
      ),
    );

    // 2. Fade Animation: Fades in from fully transparent (0.0) to opaque (1.0)
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _subtleAnimationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
      ),
    );

    // 3. Translate Animation: Slides up slightly from 5% below (Offset(0, 0.05))
    _translateAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _subtleAnimationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
          ),
        );

    // Listen to the primary route animation (Hero transition)
    widget.routeAnimation.addListener(_handlePopInAnimation);
  }

  void _handlePopInAnimation() {
    // Check if the Hero animation is finished
    if (widget.routeAnimation.value > 0.3) {
      // Start the subtle content animation
      _subtleAnimationController.forward();
      widget.routeAnimation.removeListener(_handlePopInAnimation);
    }
  }

  @override
  void dispose() {
    widget.routeAnimation.removeListener(_handlePopInAnimation);
    _subtleAnimationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 2),
            child: Container(color: Colors.transparent),
          ),

          Hero(
            tag: widget.heroTag,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Material(
                color: Colors.transparent,

                clipBehavior: Clip.antiAlias,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: <Widget>[
                    SliverAppBar(
                      backgroundColor: widget.cardColor,
                      expandedHeight: widget.openCardHeaderHeight,
                      pinned: true,
                      automaticallyImplyLeading: false,
                      actions: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            child: const CircleAvatar(
                              backgroundColor: Colors.black54,
                              radius: 14,
                              child: Icon(
                                Icons.close,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        // Apply fade and slide to the header content
                        background: SlideTransition(
                          position: _translateAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: widget.openCardHeader,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate([
                        // Apply fade and slide to the body content
                        SlideTransition(
                          position: _translateAnimation,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: widget.body,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
