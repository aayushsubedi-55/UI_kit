import 'package:flutter/material.dart';

/// Gradient-filled container. Non-interactive by design -- it's a decoration.
class GradientContainer extends StatelessWidget {
  const GradientContainer(
    this.colors,
    this.stops, {
    super.key,
    this.child,
    this.width,
    this.height,
    this.alignment,
    this.begin,
    this.end,
    this.blendMode,
    this.borderRadius,
  });

  final List<Color> colors;
  final List<double> stops;
  final double? width;
  final double? height;
  final Widget? child;
  final Alignment? begin;
  final Alignment? end;
  final Alignment? alignment;
  final BlendMode? blendMode;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin ?? Alignment.centerLeft,
          end: end ?? Alignment.centerRight,
          colors: colors,
          stops: stops,
        ),
        backgroundBlendMode: blendMode,
        borderRadius: borderRadius,
      ),
      child: child,
    ),
  );
}

class HzGradient extends GradientContainer {
  const HzGradient(
    super.colors,
    super.stops, {
    super.key,
    super.child,
    super.width,
    super.height,
    super.alignment,
    super.blendMode,
    super.borderRadius,
  });
}

class VtGradient extends GradientContainer {
  const VtGradient(
    super.colors,
    super.stops, {
    super.key,
    super.child,
    super.width,
    super.height,
    super.alignment,
    super.blendMode,
    super.borderRadius,
  }) : super(begin: Alignment.topCenter, end: Alignment.bottomCenter);
}

/// Fades list content into the background color. Stack this over the top or
/// bottom edge of a list; pass `bottomUp: true` for the bottom one.
class ListOverscrollGradient extends StatelessWidget {
  const ListOverscrollGradient({super.key, this.size = 100, this.color, this.bottomUp = false});
  final bool bottomUp;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).scaffoldBackgroundColor;
    return VtGradient(
      [c.withValues(alpha: bottomUp ? 0 : 1), c.withValues(alpha: bottomUp ? 1 : 0)],
      const [0, 1],
      height: size,
    );
  }
}
