import 'package:flutter/material.dart';

import '../../core/style/app_sizes.dart';
import '../../core/widget/common/layout_helpers.dart';

class PageNotFound extends StatelessWidget {
  const PageNotFound(String string, {super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.errorContainer,
      body: DefaultTextColor(
        color: theme.colorScheme.onErrorContainer,
        child: CenteredBox(
          width: Sizes.maxContentWidth3,
          padding: const EdgeInsets.all(Insets.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Explicit color: textTheme styles carry their own, which would
              // win over the surrounding DefaultTextColor.
              Text(
                '404 - Page Not Found',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onErrorContainer,
                ),
              ),
              const SizedBox(height: Insets.sm),
              Text('The page "$url" does not exist.', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
