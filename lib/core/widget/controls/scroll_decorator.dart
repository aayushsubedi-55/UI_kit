import 'dart:math';

import 'package:flutter/material.dart';

import '../common/layout_helpers.dart';

/// Builder function type for use with [ScrollDecorator].
typedef ScrollBuilder = Widget Function(ScrollController controller);

/// Layers decorations over/under a scrolling widget, driven by its
/// [ScrollController]. Use the named constructors for the two common cases:
/// edge fades and a top shadow.
class ScrollDecorator extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ScrollDecorator({
    super.key,
    required this.builder,
    this.fgBuilder,
    this.bgBuilder,
    this.controller,
    this.onInit,
  });

  /// Fades [begin]/[end] in whenever there is content scrolled off that edge.
  ScrollDecorator.fade({
    super.key,
    required this.builder,
    this.controller,
    this.onInit,
    Widget? begin,
    Widget? end,
    bool bg = false,
    Axis direction = Axis.vertical,
    Duration duration = const Duration(milliseconds: 150),
  }) {
    Flex flexBuilder(ScrollController controller) => Flex(
      direction: direction,
      children: [
        if (begin != null)
          AnimatedOpacity(
            duration: duration,
            opacity: controller.hasClients && controller.position.extentBefore > 3 ? 1 : 0,
            child: begin,
          ),
        const Spacer(),
        if (end != null)
          AnimatedOpacity(
            duration: duration,
            opacity: controller.hasClients && controller.position.extentAfter > 3 ? 1 : 0,
            child: end,
          ),
      ],
    );

    bgBuilder = bg ? flexBuilder : null;
    fgBuilder = bg ? null : flexBuilder;
  }

  /// Adds a shadow at the top of a vertical list once it is scrolled down.
  ScrollDecorator.shadow({
    super.key,
    required this.builder,
    this.controller,
    this.onInit,
    Color color = Colors.black54,
  }) {
    bgBuilder = null;
    fgBuilder = (controller) {
      final double ratio = controller.hasClients
          ? min(1, controller.position.extentBefore / 60)
          : 0;
      return IgnorePointerAndSemantics(
        child: Container(
          height: 24,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: ratio * color.a), Colors.transparent],
              stops: [0, ratio],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      );
    };
  }

  /// Controller for the scrolling widget. One is created if null.
  final ScrollController? controller;

  /// Builds the scrolling widget; must use the controller it is handed.
  final ScrollBuilder builder;

  /// Decoration layered in front of the scrolling widget.
  late final ScrollBuilder? fgBuilder;

  /// Decoration layered behind the scrolling widget.
  late final ScrollBuilder? bgBuilder;

  final void Function(ScrollController controller)? onInit;

  @override
  State<ScrollDecorator> createState() => _ScrollDecoratorState();
}

class _ScrollDecoratorState extends State<ScrollDecorator> {
  ScrollController? _controller;

  ScrollController get currentController => (widget.controller ?? _controller)!;

  @override
  void initState() {
    if (widget.controller == null) _controller = ScrollController();
    widget.onInit?.call(currentController);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = widget.builder(currentController);
    return AnimatedBuilder(
      animation: currentController,
      builder: (_, _) => Stack(
        children: [
          if (widget.bgBuilder != null) widget.bgBuilder!(currentController),
          content,
          if (widget.fgBuilder != null) widget.fgBuilder!(currentController),
        ],
      ),
    );
  }
}
