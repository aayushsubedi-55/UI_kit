import 'package:flutter/material.dart';

import 'controls/app_btn.dart';
import 'controls/app_loading_indicator.dart';

/// Standard full-width primary button with a built-in loading state.
///
/// Thin wrapper over [AppBtn], which supplies the press/hover/focus chrome and
/// semantics. Drop to [AppBtn] directly when you need a custom child.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSecondary;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = isSecondary ? scheme.onSecondaryContainer : scheme.onPrimary;
    return AppBtn(
      onPressed: isLoading ? null : onPressed,
      semanticLabel: label,
      isSecondary: isSecondary,
      expand: expand,
      minimumSize: Size(expand ? double.infinity : 0, 48),
      child: isLoading
          ? AppLoadingIndicator(size: 18, color: fg)
          : Text(
              label.toUpperCase(),
              textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
            ),
    );
  }
}
