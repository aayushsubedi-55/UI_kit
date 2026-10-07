import 'package:flutter/material.dart';

/// The app's brand mark: a rounded badge with a stroked "P" monogram.
///
/// Drawn rather than loaded, so it stays crisp at any size and ships no asset.
/// The colors are deliberately fixed brand values rather than theme colors --
/// a logo shouldn't reskin with light/dark mode -- but both are overridable.
///
/// The launcher icon is the same geometry; see `tool/generate_launcher_icon.py`
/// if you change anything here.
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 96,
    this.gradientStart = brandStart,
    this.gradientEnd = brandEnd,
    this.glyphColor = Colors.white,
    this.showBadge = true,
  });

  static const brandStart = Color(0xFF2563EB);
  static const brandEnd = Color(0xFF7C3AED);

  final double size;
  final Color gradientStart;
  final Color gradientEnd;
  final Color glyphColor;

  /// False draws just the monogram, for use on an already-branded surface.
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _AppLogoPainter(
          gradientStart: gradientStart,
          gradientEnd: gradientEnd,
          glyphColor: glyphColor,
          showBadge: showBadge,
        ),
        isComplex: false,
      ),
    );
  }
}

class _AppLogoPainter extends CustomPainter {
  _AppLogoPainter({
    required this.gradientStart,
    required this.gradientEnd,
    required this.glyphColor,
    required this.showBadge,
  });

  final Color gradientStart;
  final Color gradientEnd;
  final Color glyphColor;
  final bool showBadge;

  @override
  void paint(Canvas canvas, Size size) {
    // Geometry is authored in a 100x100 box, then scaled to whatever we get.
    final s = size.shortestSide / 100;

    if (showBadge) {
      final rect = Offset.zero & Size(100 * s, 100 * s);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(24 * s)),
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [gradientStart, gradientEnd],
          ).createShader(rect),
      );
    }

    // The monogram: a stem, a shoulder, a bowl arcing back to the stem.
    final glyph = Path()
      ..moveTo(34 * s, 80 * s)
      ..lineTo(34 * s, 24 * s)
      ..lineTo(58 * s, 24 * s)
      ..arcToPoint(
        Offset(58 * s, 58 * s),
        radius: Radius.circular(17 * s),
        clockwise: true,
      )
      ..lineTo(34 * s, 58 * s);

    canvas.drawPath(
      glyph,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 13 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = glyphColor,
    );
  }

  @override
  bool shouldRepaint(_AppLogoPainter old) =>
      old.gradientStart != gradientStart ||
      old.gradientEnd != gradientEnd ||
      old.glyphColor != glyphColor ||
      old.showBadge != showBadge;
}
