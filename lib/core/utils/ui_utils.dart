import 'package:flutter/cupertino.dart';

class ContextUtils {
  static Offset? getGlobalPos(BuildContext context, [Offset offset = Offset.zero]) {
    final rb = context.findRenderObject() as RenderBox?;
    if (rb?.hasSize == true) return rb?.localToGlobal(offset);
    return null;
  }

  static Size? getSize(BuildContext context) {
    final rb = context.findRenderObject() as RenderBox?;
    if (rb?.hasSize == true) return rb?.size;
    return null;
  }
}

class PageRoutes {
  static const Duration kDefaultDuration = Duration(milliseconds: 300);

  /// Opaque routes use Cupertino so we get the 'swipe right to go back' gesture;
  /// transparent ones fade in over whatever is below.
  static Route<T> dialog<T>(
    Widget child, {
    Duration duration = kDefaultDuration,
    bool opaque = false,
  }) {
    if (opaque) return CupertinoPageRoute(builder: (_) => child);
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      opaque: opaque,
      fullscreenDialog: true,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}
