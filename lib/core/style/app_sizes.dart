import 'package:flutter/material.dart';

/// Spacing / radius / duration scale ported from the Wonderous `$styles` object.
///
/// Wonderous builds these at runtime through get_it so it can rescale for
/// tablets. We don't need that here, so they're plain consts.
abstract class Insets {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 16;
  static const double md = 24;
  static const double lg = 32;
  static const double xl = 48;
  static const double xxl = 56;
  static const double offset = 80;
}

abstract class Corners {
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 32;
}

abstract class Times {
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration med = Duration(milliseconds: 600);
  static const Duration slow = Duration(milliseconds: 900);
  static const Duration extraSlow = Duration(milliseconds: 1300);
  static const Duration pageTransition = Duration(milliseconds: 200);
}

abstract class Sizes {
  static const double maxContentWidth1 = 800;
  static const double maxContentWidth2 = 600;
  static const double maxContentWidth3 = 500;
  static const Size minAppSize = Size(380, 650);
}

abstract class AppShadows {
  static const List<Shadow> textSoft = [
    Shadow(color: Color(0x40000000), offset: Offset(0, 2), blurRadius: 4),
  ];
  static const List<Shadow> text = [
    Shadow(color: Color(0x99000000), offset: Offset(0, 2), blurRadius: 2),
  ];
  static const List<Shadow> textStrong = [
    Shadow(color: Color(0x99000000), offset: Offset(0, 4), blurRadius: 6),
  ];
}
