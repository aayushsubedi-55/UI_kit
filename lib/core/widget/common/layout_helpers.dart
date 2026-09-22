import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Center + SizedBox + Padding in one, for the very common
/// "constrain this and center it" case.
class CenteredBox extends StatelessWidget {
  const CenteredBox({super.key, required this.child, this.width, this.height, this.padding});
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding ?? EdgeInsets.zero,
    child: Center(child: SizedBox(width: width, height: height, child: child)),
  );
}

/// Pins text scaling for subtrees whose layout can't absorb the user's
/// system font-size setting (tight badges, page indicators, etc).
class StaticTextScale extends StatelessWidget {
  const StaticTextScale({super.key, required this.child, this.scale = 1});
  final Widget child;
  final double scale;

  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(scale)),
    child: child,
  );
}

class DefaultTextColor extends StatelessWidget {
  const DefaultTextColor({super.key, required this.color, required this.child});
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
    style: DefaultTextStyle.of(context).style.copyWith(color: color),
    child: child,
  );
}

class LightText extends StatelessWidget {
  const LightText({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DefaultTextColor(color: Colors.white, child: child);
}

class DarkText extends StatelessWidget {
  const DarkText({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => DefaultTextColor(color: Colors.black, child: child);
}

/// Colored box that fades via its own color alpha. Cheaper than wrapping
/// in an Opacity layer.
class FadeColorTransition extends StatelessWidget {
  const FadeColorTransition({super.key, required this.animation, required this.color});
  final Animation<double> animation;
  final Color color;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: animation,
    builder: (_, _) => Container(color: color.withValues(alpha: animation.value)),
  );
}

/// Blocks hit-testing but keeps the subtree visible to screen readers.
class IgnorePointerKeepSemantics extends SingleChildRenderObjectWidget {
  const IgnorePointerKeepSemantics({super.key, super.child});

  @override
  RenderIgnorePointerKeepSemantics createRenderObject(BuildContext context) =>
      RenderIgnorePointerKeepSemantics();
}

class RenderIgnorePointerKeepSemantics extends RenderProxyBox {
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) => false;
}

/// Purely decorative subtree: no touch, no semantics.
class IgnorePointerAndSemantics extends StatelessWidget {
  const IgnorePointerAndSemantics({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(child: IgnorePointer(child: child));
}
