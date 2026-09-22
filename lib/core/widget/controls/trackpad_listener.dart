import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Turns continuous trackpad scrolling into discrete -1/0/1 direction ticks,
/// so a trackpad can drive the same handlers as a swipe.
class TrackpadListener extends StatefulWidget {
  const TrackpadListener({super.key, this.child, this.scrollSensitivity = 100, this.onScroll});

  final Widget? child;
  final double scrollSensitivity;
  final ValueChanged<Offset>? onScroll;

  @override
  State<TrackpadListener> createState() => _TrackpadListenerState();
}

class _TrackpadListenerState extends State<TrackpadListener> {
  Offset _scrollOffset = Offset.zero;

  void _handleTrackpadEvent(PointerSignalEvent event) {
    if (event is PointerScrollEvent && event.kind == PointerDeviceKind.trackpad) {
      var newScroll = _scrollOffset + event.scrollDelta;
      newScroll = Offset(
        newScroll.dx.clamp(-widget.scrollSensitivity, widget.scrollSensitivity),
        newScroll.dy.clamp(-widget.scrollSensitivity, widget.scrollSensitivity),
      );
      _scrollOffset = newScroll;
      _update();
    }
  }

  void _update() {
    var directionScroll = Offset.zero;
    final sensitivity = widget.scrollSensitivity;
    if (_scrollOffset.dy >= sensitivity) {
      _scrollOffset += Offset(0.0, -sensitivity);
      directionScroll += const Offset(0.0, -1.0);
    } else if (_scrollOffset.dy <= -sensitivity) {
      _scrollOffset += Offset(0.0, sensitivity);
      directionScroll += const Offset(0.0, 1.0);
    }
    if (_scrollOffset.dx >= sensitivity) {
      _scrollOffset += Offset(-sensitivity, 0.0);
      directionScroll += const Offset(-1.0, 0.0);
    } else if (_scrollOffset.dx <= -sensitivity) {
      _scrollOffset += Offset(sensitivity, 0.0);
      directionScroll += const Offset(1.0, 0.0);
    }
    if (directionScroll != Offset.zero) widget.onScroll?.call(directionScroll);
  }

  @override
  Widget build(BuildContext context) =>
      Listener(onPointerSignal: _handleTrackpadEvent, child: widget.child);
}
