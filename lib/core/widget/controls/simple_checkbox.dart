import 'package:flutter/material.dart';

import '../../style/app_sizes.dart';
import '../../utils/app_haptics.dart';

/// Checkbox with an inline label and haptic feedback on toggle.
class SimpleCheckbox extends StatelessWidget {
  const SimpleCheckbox({
    super.key,
    required this.active,
    required this.onToggled,
    required this.label,
  });

  final bool active;
  final String label;
  final void Function(bool? value) onToggled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(Corners.sm)),
          ),
          value: active,
          visualDensity: const VisualDensity(horizontal: 0.5, vertical: 0.5),
          onChanged: (value) {
            AppHaptics.mediumImpact();
            onToggled(value);
          },
        ),
        const SizedBox(width: Insets.xs),
        Flexible(child: Text(label, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
