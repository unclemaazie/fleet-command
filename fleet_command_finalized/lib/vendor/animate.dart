library vendor_animate;

import 'package:flutter/material.dart';

/// Simple animation extensions - replaces flutter_animate
extension WidgetAnimate on Widget {
  Widget fadeIn({
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return _AnimatedWrapper(
      delay: delay,
      duration: duration,
      builder: (animation) => FadeTransition(
        opacity: animation,
        child: this,
      ),
    );
  }

  Widget slideY({
    double begin = 0.2,
    double end = 0,
    Duration delay = Duration.zero,
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    return _AnimatedWrapper(
      delay: delay,
      duration: duration,
      builder: (animation) => SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, begin),
          end: Offset(0, end),
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        )),
        child: this,
      ),
    );
  }
}

class _AnimatedWrapper extends StatefulWidget {
  final Duration delay;
  final Duration duration;
  final Widget Function(Animation<double>) builder;

  const _AnimatedWrapper({
    required this.delay,
    required this.duration,
    required this.builder,
  });

  @override
  State<_AnimatedWrapper> createState() => _AnimatedWrapperState();
}

class _AnimatedWrapperState extends State<_AnimatedWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => widget.builder(_controller),
    );
  }
}
