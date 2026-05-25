library vendor_slidable;

import 'package:flutter/material.dart';

/// Simple Slidable implementation - replaces flutter_slidable
class SimpleSlidable extends StatefulWidget {
  final Widget child;
  final List<SlidableAction> actions;

  const SimpleSlidable({
    super.key,
    required this.child,
    required this.actions,
  });

  @override
  State<SimpleSlidable> createState() => _SimpleSlidableState();
}

class _SimpleSlidableState extends State<SimpleSlidable>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _dragExtent = 0;
  static const double _maxDrag = 150;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _dragExtent -= details.primaryDelta!;
    _dragExtent = _dragExtent.clamp(0, _maxDrag);
    _controller.value = _dragExtent / _maxDrag;
    setState(() {});
  }

  void _onDragEnd(DragEndDetails details) {
    if (_dragExtent > _maxDrag * 0.5) {
      _controller.animateTo(1.0);
      _dragExtent = _maxDrag;
    } else {
      _controller.animateTo(0.0);
      _dragExtent = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      child: Stack(
        children: [
          // Actions background
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: widget.actions.map((action) {
                return Container(
                  width: _maxDrag / widget.actions.length,
                  decoration: BoxDecoration(
                    color: action.backgroundColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: IconButton(
                    icon: Icon(action.icon, color: action.foregroundColor),
                    onPressed: () {
                      action.onPressed(context);
                      _controller.animateTo(0.0);
                      _dragExtent = 0;
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          // Main content
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(-_maxDrag * _controller.value, 0),
                child: widget.child,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SlidableAction {
  final VoidCallback Function(BuildContext) onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;
  final BorderRadius borderRadius;

  SlidableAction({
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
    this.borderRadius = BorderRadius.zero,
  });
}

class ActionPane {
  final Widget motion;
  final List<SlidableAction> children;

  ActionPane({
    required this.motion,
    required this.children,
  });
}

class ScrollMotion extends StatelessWidget {
  const ScrollMotion({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
