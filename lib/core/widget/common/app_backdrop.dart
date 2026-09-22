import 'dart:ui';

import 'package:flutter/material.dart';

/// Blurs whatever is painted behind it. Set [useBlur] to false (e.g. from a
/// "reduce effects" setting, or on low-end devices) to fall back to a cheap
/// translucent fill instead.
class AppBackdrop extends StatelessWidget {
  const AppBackdrop({super.key, this.strength = 1, this.useBlur = true, this.fallbackColor, this.child});

  final double strength;
  final bool useBlur;
  final Color? fallbackColor;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final normalStrength = clampDouble(strength, 0, 1);
    if (useBlur) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: normalStrength * 15, sigmaY: normalStrength * 15),
        child: child ?? const SizedBox.expand(),
      );
    }
    final base = fallbackColor ?? Theme.of(context).colorScheme.surface;
    final fill = Container(color: base.withValues(alpha: .8 * normalStrength));
    if (child == null) return fill;
    return Stack(children: [child!, Positioned.fill(child: fill)]);
  }
}
