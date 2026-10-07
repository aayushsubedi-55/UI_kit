import 'package:flutter/material.dart';

import '../../style/app_sizes.dart';
import 'render_helpers.dart';

/// Cross-fades between a collapsed and expanded child while animating the
/// card's box to the new child's measured size.
class OpeningCard extends StatefulWidget {
  const OpeningCard({
    super.key,
    required this.closedBuilder,
    required this.openBuilder,
    required this.isOpen,
    this.background,
    this.padding,
    this.duration = Times.fast,
  });

  final Widget Function(BuildContext) closedBuilder;
  final Widget Function(BuildContext) openBuilder;
  final Widget? background;
  final bool isOpen;
  final EdgeInsets? padding;
  final Duration duration;

  @override
  State<OpeningCard> createState() => _OpeningCardState();
}

class _OpeningCardState extends State<OpeningCard> {
  Size _size = Size.zero;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Size>(
      duration: widget.duration,
      curve: Curves.easeOut,
      tween: Tween(begin: _size, end: _size),
      builder: (_, value, child) => Stack(
        children: [
          if (widget.background != null) Positioned.fill(child: widget.background!),
          Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: SizedBox(width: value.width, height: value.height, child: child),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: widget.duration,
        child: ClipRect(
          key: ValueKey(widget.isOpen),
          child: OverflowBox(
            minWidth: 0.0,
            maxWidth: double.infinity,
            minHeight: 0.0,
            maxHeight: double.infinity,
            child: MeasurableWidget(
              onChange: (size) => setState(() => _size = size),
              child: widget.isOpen ? widget.openBuilder(context) : widget.closedBuilder(context),
            ),
          ),
        ),
      ),
    );
  }
}
