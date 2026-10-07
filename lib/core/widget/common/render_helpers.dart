import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Reports its child's size after layout. Use when you need a real measurement
/// rather than the constraints a LayoutBuilder can give you.
class MeasurableWidget extends SingleChildRenderObjectWidget {
  const MeasurableWidget({super.key, required this.onChange, required Widget super.child});
  final void Function(Size size) onChange;

  @override
  RenderObject createRenderObject(BuildContext context) => MeasureSizeRenderObject(onChange);
}

class MeasureSizeRenderObject extends RenderProxyBox {
  MeasureSizeRenderObject(this.onChange);
  void Function(Size size) onChange;

  Size _prevSize = Size.zero;

  @override
  void performLayout() {
    super.performLayout();
    final newSize = child?.size ?? Size.zero;
    if (_prevSize == newSize) return;
    _prevSize = newSize;
    scheduleMicrotask(() => onChange(newSize));
  }
}

/// Composites its child using one or more [BlendMode]s against what's already
/// painted below it.
class BlendMask extends SingleChildRenderObjectWidget {
  const BlendMask({super.key, required this.blendModes, this.opacity = 1.0, required Widget super.child});
  final List<BlendMode> blendModes;
  final double opacity;

  @override
  RenderObject createRenderObject(BuildContext context) => RenderBlendMask(blendModes, opacity);

  @override
  void updateRenderObject(BuildContext context, RenderBlendMask renderObject) {
    renderObject.blendModes = blendModes;
    renderObject.opacity = opacity;
  }
}

class RenderBlendMask extends RenderProxyBox {
  RenderBlendMask(this.blendModes, this.opacity);
  List<BlendMode> blendModes;
  double opacity;

  @override
  void paint(PaintingContext context, Offset offset) {
    // Complex blend modes can be raster cached incorrectly on the Skia backend.
    context.setWillChangeHint();
    for (final blend in blendModes) {
      context.canvas.saveLayer(
        offset & size,
        Paint()
          ..blendMode = blend
          ..color = Color.fromARGB((opacity * 255).round(), 255, 255, 255),
      );
    }
    super.paint(context, offset);
    context.canvas.restore();
  }
}
