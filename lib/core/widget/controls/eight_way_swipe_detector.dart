import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'trackpad_listener.dart';

/// Reports swipes as a normalized 8-way direction vector (each axis -1, 0
/// or 1). Also handles trackpad scrolling.
class EightWaySwipeDetector extends StatefulWidget {
  const EightWaySwipeDetector({
    super.key,
    required this.child,
    this.threshold = 50,
    required this.onSwipe,
  });

  final Widget child;
  final double threshold;
  final void Function(Offset dir)? onSwipe;

  @override
  State<EightWaySwipeDetector> createState() => _EightWaySwipeDetectorState();
}

class _EightWaySwipeDetectorState extends State<EightWaySwipeDetector> {
  Offset _startPos = Offset.zero;
  Offset _endPos = Offset.zero;
  bool _isSwiping = false;

  void _resetSwipe() {
    _startPos = _endPos = Offset.zero;
    _isSwiping = false;
  }

  void _maybeTriggerSwipe() {
    if (!_isSwiping) return;
    var moveDelta = _endPos - _startPos;
    final distance = moveDelta.distance;
    if (distance >= max(widget.threshold, 1)) {
      // Normalize to -1..1, then round to snap onto one of the 8 directions.
      moveDelta /= distance;
      widget.onSwipe?.call(
        Offset(moveDelta.dx.roundToDouble(), moveDelta.dy.roundToDouble()),
      );
      _resetSwipe();
    }
  }

  void _handleSwipeStart(DragStartDetails d) {
    _isSwiping = d.kind != null;
    _startPos = _endPos = d.localPosition;
  }

  void _handleSwipeUpdate(DragUpdateDetails d) {
    _endPos = d.localPosition;
    _maybeTriggerSwipe();
  }

  void _handleSwipeEnd(DragEndDetails d) {
    _maybeTriggerSwipe();
    _resetSwipe();
  }

  @override
  Widget build(BuildContext context) {
    return TrackpadListener(
      scrollSensitivity: 70,
      onScroll: (delta) => widget.onSwipe?.call(delta),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onPanStart: _handleSwipeStart,
        onPanUpdate: _handleSwipeUpdate,
        onPanCancel: _resetSwipe,
        onPanEnd: _handleSwipeEnd,
        // Trackpad is deliberately omitted; TrackpadListener handles it.
        supportedDevices: const {
          PointerDeviceKind.mouse,
          PointerDeviceKind.stylus,
          PointerDeviceKind.touch,
          PointerDeviceKind.unknown,
        },
        child: widget.child,
      ),
    );
  }
}
