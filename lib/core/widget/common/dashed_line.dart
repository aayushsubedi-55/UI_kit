import 'package:flutter/material.dart';

class DashedLine extends StatelessWidget {
  const DashedLine({super.key, this.vertical = false, this.color, this.dashPx = 3, this.gapPx = 3});
  final bool vertical;
  final Color? color;
  final double dashPx;
  final double gapPx;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: vertical ? 2 : double.infinity,
      height: vertical ? double.infinity : 2,
      child: CustomPaint(
        painter: _DashedLinePainter(
          vertical,
          color ?? Theme.of(context).colorScheme.onSurface,
          dashPx,
          gapPx,
        ),
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter(this.vertical, this.color, this.dashPx, this.gapPx);
  final bool vertical;
  final Color color;
  final double dashPx;
  final double gapPx;

  @override
  void paint(Canvas canvas, Size size) {
    double pos = 0;
    final paint = Paint()..color = color;
    if (vertical) {
      while (pos < size.height) {
        canvas.drawLine(Offset(0, pos), Offset(0, pos + dashPx), paint);
        pos += dashPx + gapPx;
      }
    } else {
      while (pos < size.width) {
        canvas.drawLine(Offset(pos, 0), Offset(pos + dashPx, 0), paint);
        pos += dashPx + gapPx;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedLinePainter old) =>
      old.vertical != vertical || old.color != color || old.dashPx != dashPx || old.gapPx != gapPx;
}
