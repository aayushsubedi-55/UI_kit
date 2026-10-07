import 'dart:math';

import 'package:flutter/material.dart';

import '../common/layout_helpers.dart';

/// "01 / 12" page counter split by a diagonal rule. Text scaling is pinned
/// because the two halves are positioned by hand.
class DiagonalTextPageIndicator extends StatelessWidget {
  const DiagonalTextPageIndicator({
    super.key,
    required this.current,
    required this.total,
    this.fontSize = 26,
    this.color,
  });

  final int current;
  final int total;
  final double fontSize;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? Theme.of(context).colorScheme.onSurface;
    final textStyle = Theme.of(
      context,
    ).textTheme.titleLarge!.copyWith(fontSize: fontSize, height: 1, color: c);
    final size = fontSize * 1.5;

    return StaticTextScale(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: fontSize * .4).copyWith(top: fontSize * .2),
        child: Stack(
          children: [
            ClipPath(
              clipper: _DiagonalClipper(leftSide: true),
              child: Transform.translate(
                offset: Offset(-fontSize * .7, 0),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Text(
                    _pad(current),
                    style: textStyle,
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ),
            ClipPath(
              clipper: _DiagonalClipper(leftSide: false),
              child: Transform.translate(
                offset: Offset(fontSize * .45, fontSize * .6),
                child: SizedBox(
                  width: size,
                  height: size,
                  child: Opacity(opacity: .5, child: Text(_pad(total), style: textStyle)),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Transform.rotate(
                  angle: pi * -.25,
                  child: Container(height: 2, color: c),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _pad(int value) => value.toString().padLeft(2, '0');
}

class _DiagonalClipper extends CustomClipper<Path> {
  _DiagonalClipper({required this.leftSide});
  final bool leftSide;

  @override
  Path getClip(Size size) {
    const double lineGap = 2;
    if (leftSide) {
      return Path()
        ..lineTo(size.width - lineGap, 0)
        ..lineTo(-lineGap, size.height)
        ..lineTo(-lineGap, 0)
        ..addRect(Rect.fromLTRB(-size.width * .5, 0, 0, size.height))
        ..addRect(Rect.fromLTRB(-size.width * .5, -size.height * .5, size.width, 0));
    }
    return Path()
      ..moveTo(size.width + lineGap, 0)
      ..lineTo(size.width, size.height + lineGap)
      ..lineTo(lineGap, size.height + lineGap)
      ..lineTo(size.width + lineGap, 0)
      ..addRect(Rect.fromLTRB(size.width, 0, size.width * 1.5, size.height * 1.5));
  }

  @override
  bool shouldReclip(covariant _DiagonalClipper oldClipper) => oldClipper.leftSide != leftSide;
}
