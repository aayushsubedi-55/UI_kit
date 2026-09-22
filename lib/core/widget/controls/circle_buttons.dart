import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../style/app_sizes.dart';
import '../common/keyboard_listeners.dart';
import 'app_btn.dart';

/// Round tap target wrapping an arbitrary child.
class CircleBtn extends StatelessWidget {
  const CircleBtn({
    super.key,
    required this.child,
    required this.onPressed,
    required this.semanticLabel,
    this.border,
    this.bgColor,
    this.size,
  });

  static const double defaultSize = 48;

  final VoidCallback? onPressed;
  final Color? bgColor;
  final BorderSide? border;
  final Widget child;
  final double? size;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final sz = size ?? defaultSize;
    return AppBtn(
      onPressed: onPressed,
      semanticLabel: semanticLabel,
      minimumSize: Size(sz, sz),
      padding: EdgeInsets.zero,
      circular: true,
      bgColor: bgColor,
      border: border,
      child: child,
    );
  }
}

/// Round icon button. [safe] wraps it in a padded [SafeArea] for use as a
/// floating overlay on top of full-bleed content.
class CircleIconBtn extends StatelessWidget {
  const CircleIconBtn({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.semanticLabel,
    this.border,
    this.bgColor,
    this.color,
    this.size,
    this.iconSize,
    this.flipIcon = false,
  });

  static const double defaultIconSize = 24;

  final IconData icon;
  final VoidCallback? onPressed;
  final BorderSide? border;
  final Color? bgColor;
  final Color? color;
  final String semanticLabel;
  final double? size;
  final double? iconSize;
  final bool flipIcon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return CircleBtn(
      onPressed: onPressed,
      border: border,
      size: size,
      bgColor: bgColor ?? scheme.primary,
      semanticLabel: semanticLabel,
      child: Transform.scale(
        scaleX: flipIcon ? -1 : 1,
        child: Icon(icon, size: iconSize ?? defaultIconSize, color: color ?? scheme.onPrimary),
      ),
    );
  }

  Widget safe() => _SafeAreaWithPadding(child: this);
}

/// Back button that also responds to the Escape key. Falls back to
/// [onFallback] (or does nothing) when there is nothing to pop.
class BackBtn extends StatelessWidget {
  const BackBtn({
    super.key,
    this.icon = Icons.arrow_back,
    this.onPressed,
    this.onFallback,
    this.semanticLabel,
    this.bgColor,
    this.iconColor,
  });

  // ignore: prefer_const_constructors_in_immutables
  BackBtn.close({
    super.key,
    this.onPressed,
    this.onFallback,
    this.bgColor,
    this.iconColor,
    this.semanticLabel = 'Close',
  }) : icon = Icons.close;

  final Color? bgColor;
  final Color? iconColor;
  final IconData icon;
  final VoidCallback? onPressed;
  final VoidCallback? onFallback;
  final String? semanticLabel;

  void _handlePressed(BuildContext context) {
    if (onPressed != null) return onPressed!();
    final nav = Navigator.of(context);
    if (nav.canPop()) {
      nav.pop();
    } else {
      onFallback?.call();
    }
  }

  bool _handleKeyDown(BuildContext context, KeyDownEvent event) {
    if (event.logicalKey != LogicalKeyboardKey.escape) return false;
    _handlePressed(context);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FullscreenKeyboardListener(
      onKeyDown: (event) => _handleKeyDown(context, event),
      child: CircleIconBtn(
        icon: icon,
        bgColor: bgColor,
        color: iconColor,
        onPressed: () => _handlePressed(context),
        semanticLabel: semanticLabel ?? 'Back',
      ),
    );
  }

  Widget safe() => _SafeAreaWithPadding(child: this);
}

class _SafeAreaWithPadding extends StatelessWidget {
  const _SafeAreaWithPadding({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
    bottom: false,
    child: Padding(padding: const EdgeInsets.all(Insets.sm), child: child),
  );
}
