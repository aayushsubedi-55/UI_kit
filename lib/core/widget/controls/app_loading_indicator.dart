import 'package:flutter/material.dart';

/// Thin circular spinner. Pass [value] for determinate progress; values under
/// 5% fall back to indeterminate so it never looks stalled.
class AppLoadingIndicator extends StatelessWidget {
  const AppLoadingIndicator({super.key, this.value, this.color, this.size = 40});

  final Color? color;
  final double? value;
  final double size;

  @override
  Widget build(BuildContext context) {
    final progress = (value == null || value! < .05) ? null : value;
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        color: color ?? Theme.of(context).colorScheme.primary,
        value: progress,
        strokeWidth: 1.0,
      ),
    );
  }
}
