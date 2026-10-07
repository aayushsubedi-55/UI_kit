import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Listens for key events app-wide, but only while its route is the top one.
/// Unlike a focus-scoped listener this keeps working when focus is elsewhere.
class FullscreenKeyboardListener extends StatefulWidget {
  const FullscreenKeyboardListener({
    super.key,
    required this.child,
    this.onKeyDown,
    this.onKeyUp,
    this.onKeyRepeat,
  });

  final Widget child;
  final bool Function(KeyDownEvent event)? onKeyDown;
  final bool Function(KeyUpEvent event)? onKeyUp;
  final bool Function(KeyRepeatEvent event)? onKeyRepeat;

  @override
  State<FullscreenKeyboardListener> createState() => _FullscreenKeyboardListenerState();
}

class _FullscreenKeyboardListenerState extends State<FullscreenKeyboardListener> {
  @override
  void initState() {
    super.initState();
    ServicesBinding.instance.keyboard.addHandler(_handleKey);
  }

  @override
  void dispose() {
    ServicesBinding.instance.keyboard.removeHandler(_handleKey);
    super.dispose();
  }

  bool _handleKey(KeyEvent event) {
    // Ignore keys while another route (a dialog?) is on top of us.
    if (ModalRoute.of(context)?.isCurrent == false) return false;

    return switch (event) {
      KeyDownEvent() => widget.onKeyDown?.call(event) ?? false,
      KeyUpEvent() => widget.onKeyUp?.call(event) ?? false,
      KeyRepeatEvent() => widget.onKeyRepeat?.call(event) ?? false,
      _ => false,
    };
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class ArrowDir {
  ArrowDir(this.hz, this.vt);
  int hz;
  int vt;

  bool get isNotZero => hz != 0 || vt != 0;
}

/// Reports arrow-key presses as an 8-way [ArrowDir]. `vt` is +1 for up.
class KeyboardArrowsListener extends StatefulWidget {
  const KeyboardArrowsListener({super.key, required this.child, required this.onArrow});
  final Widget child;
  final void Function(ArrowDir dir) onArrow;

  @override
  State<KeyboardArrowsListener> createState() => _KeyboardArrowsListenerState();
}

class _KeyboardArrowsListenerState extends State<KeyboardArrowsListener> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => KeyboardListener(
    autofocus: true,
    focusNode: _focusNode,
    onKeyEvent: _handleKey,
    child: widget.child,
  );

  void _handleKey(KeyEvent event) {
    if (event is! KeyDownEvent) return;
    final dir = ArrowDir(0, 0);
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      dir.hz = -1;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      dir.hz = 1;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      dir.vt = 1;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      dir.vt = -1;
    }
    if (dir.isNotZero) widget.onArrow(dir);
  }
}
