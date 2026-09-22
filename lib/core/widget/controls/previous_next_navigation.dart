import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../style/app_sizes.dart';
import '../common/keyboard_listeners.dart';
import 'circle_buttons.dart';

/// Desktop/web affordance for paged content: overlays prev/next buttons and
/// wires up arrow keys and the mouse wheel. Renders nothing extra on mobile,
/// where swiping is the expected gesture.
class PreviousNextNavigation extends StatefulWidget {
  const PreviousNextNavigation({
    super.key,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.child,
    this.maxWidth = 1000,
    this.nextBtnColor,
    this.previousBtnColor,
    this.listenToMouseWheel = true,
  });

  final VoidCallback? onPreviousPressed;
  final VoidCallback? onNextPressed;
  final Color? nextBtnColor;
  final Color? previousBtnColor;
  final Widget child;
  final double? maxWidth;
  final bool listenToMouseWheel;

  @override
  State<PreviousNextNavigation> createState() => _PreviousNextNavigationState();
}

class _PreviousNextNavigationState extends State<PreviousNextNavigation> {
  static const _scrollCooldown = Duration(milliseconds: 300);
  DateTime _lastMouseScrollTime = DateTime.now();

  bool get _isMobile =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  bool _handleKeyDown(KeyDownEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft && widget.onPreviousPressed != null) {
      widget.onPreviousPressed!();
      return true;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight && widget.onNextPressed != null) {
      widget.onNextPressed!();
      return true;
    }
    return false;
  }

  void _handleMouseScroll(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    // Ignore events that arrive too close together; a wheel emits many.
    if (DateTime.now().difference(_lastMouseScrollTime) < _scrollCooldown) return;
    _lastMouseScrollTime = DateTime.now();
    if (event.scrollDelta.dy > 0) {
      widget.onPreviousPressed?.call();
    } else if (event.scrollDelta.dy < 0) {
      widget.onNextPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isMobile) return widget.child;
    return Listener(
      onPointerSignal: widget.listenToMouseWheel ? _handleMouseScroll : null,
      child: FullscreenKeyboardListener(
        onKeyDown: _handleKeyDown,
        child: Stack(
          children: [
            widget.child,
            Center(
              child: SizedBox(
                width: widget.maxWidth ?? double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.sm),
                  child: Row(
                    children: [
                      CircleIconBtn(
                        icon: Icons.arrow_back,
                        onPressed: widget.onPreviousPressed,
                        semanticLabel: 'Previous',
                        bgColor: widget.previousBtnColor,
                      ),
                      const Spacer(),
                      CircleIconBtn(
                        icon: Icons.arrow_forward,
                        onPressed: widget.onNextPressed,
                        semanticLabel: 'Next',
                        bgColor: widget.nextBtnColor,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
