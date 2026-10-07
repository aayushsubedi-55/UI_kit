import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// Mouse-draggable, bouncy scrolling everywhere, with a visible scrollbar only
/// on desktop/web. Pass to `MaterialApp.scrollBehavior`.
class AppScrollBehavior extends ScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {...super.dragDevices, PointerDeviceKind.mouse};

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) => const BouncingScrollPhysics();

  @override
  Widget buildScrollbar(BuildContext context, Widget child, ScrollableDetails details) {
    final isMobile =
        !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (isMobile) return child;
    return RawScrollbar(
      controller: details.controller,
      thumbVisibility: true,
      thickness: 8,
      interactive: true,
      child: child,
    );
  }
}
