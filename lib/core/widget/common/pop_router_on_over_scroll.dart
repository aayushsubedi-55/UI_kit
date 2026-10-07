import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Pops the current route when the user drags a list past its top edge --
/// the "pull down to dismiss" gesture. Requires bouncing physics to trigger
/// (see [AppScrollBehavior]).
class PopRouterOnOverScroll extends StatefulWidget {
  const PopRouterOnOverScroll({
    super.key,
    required this.child,
    required this.controller,
    this.threshold = 70,
  });

  final ScrollController controller;
  final Widget child;
  final double threshold;

  @override
  State<PopRouterOnOverScroll> createState() => _PopRouterOnOverScrollState();
}

class _PopRouterOnOverScrollState extends State<PopRouterOnOverScroll> {
  bool _isPointerDown = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleScrollChanged);
  }

  @override
  void didUpdateWidget(covariant PopRouterOnOverScroll oldWidget) {
    if (widget.controller != oldWidget.controller) {
      oldWidget.controller.removeListener(_handleScrollChanged);
      widget.controller.addListener(_handleScrollChanged);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleScrollChanged);
    super.dispose();
  }

  bool _checkPointerIsDown(ScrollUpdateNotification d) => _isPointerDown = d.dragDetails != null;

  @override
  Widget build(BuildContext context) => NotificationListener<ScrollUpdateNotification>(
    onNotification: _checkPointerIsDown,
    child: widget.child,
  );

  void _handleScrollChanged() {
    if (!widget.controller.hasClients) return;
    if (widget.controller.position.pixels < -widget.threshold && _isPointerDown) {
      widget.controller.removeListener(_handleScrollChanged);
      context.pop();
    }
  }
}
