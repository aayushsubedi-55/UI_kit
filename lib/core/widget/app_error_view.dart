import 'package:flutter/material.dart';

import '../error/failure.dart';
import '../style/app_sizes.dart';
import 'controls/app_btn.dart';

/// Renders a [Failure] with a retry action. Use this for any screen's
/// error state instead of a bespoke `Text(error.toString())`.
class AppErrorView extends StatelessWidget {
  const AppErrorView({super.key, required this.failure, this.onRetry});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: Insets.lg,
            ),
            const SizedBox(height: Insets.xs),
            Text(failure.message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: Insets.sm),
              AppBtn.from(onPressed: onRetry, text: 'Retry', icon: Icons.refresh),
            ],
          ],
        ),
      ),
    );
  }
}
