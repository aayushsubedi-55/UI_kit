import 'package:flutter/material.dart';

import '../../style/app_sizes.dart';
import 'circle_buttons.dart';

/// Fixed-height header with a centred title/subtitle, an optional back button
/// and an optional trailing widget. Use in place of an [AppBar] when you want
/// the title to stay centred regardless of what is on either side.
class AppHeader extends StatelessWidget {
  const AppHeader({
    super.key,
    this.title,
    this.subtitle,
    this.showBackBtn = true,
    this.isTransparent = false,
    this.onBack,
    this.trailing,
    this.backIcon = Icons.arrow_back,
    this.backBtnSemantics,
    this.height = 64,
  });

  final String? title;
  final String? subtitle;
  final bool showBackBtn;
  final IconData backIcon;
  final String? backBtnSemantics;
  final bool isTransparent;
  final VoidCallback? onBack;
  final Widget Function(BuildContext context)? trailing;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: isTransparent ? Colors.transparent : theme.colorScheme.surface,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              MergeSemantics(
                child: Semantics(
                  header: true,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (title != null)
                          Text(
                            title!.toUpperCase(),
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                            ),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (subtitle != null)
                          Text(
                            subtitle!.toUpperCase(),
                            textHeightBehavior: const TextHeightBehavior(
                              applyHeightToFirstAscent: false,
                            ),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.tertiary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Center(
                  child: Row(
                    children: [
                      const SizedBox(width: Insets.sm),
                      if (showBackBtn)
                        BackBtn(
                          onPressed: onBack,
                          icon: backIcon,
                          semanticLabel: backBtnSemantics,
                        ),
                      const Spacer(),
                      if (trailing != null) trailing!(context),
                      const SizedBox(width: Insets.sm),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
