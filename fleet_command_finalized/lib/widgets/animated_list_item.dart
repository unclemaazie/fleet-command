import 'package:flutter/material.dart';

import '../vendor/animate.dart';

class AnimatedListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration delay;

  const AnimatedListItem({
    super.key,
    required this.child,
    required this.index,
    this.delay = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    return child
        
        .fadeIn(delay: Duration(milliseconds: index * 50))
        .slideY(
          begin: 0.2,
          end: 0,
          delay: Duration(milliseconds: index * 50),
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
  }
}
