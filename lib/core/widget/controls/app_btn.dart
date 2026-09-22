import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../style/app_sizes.dart';
import '../common/layout_helpers.dart';

/// The base button every other button here is built on.
///
/// Over a plain [TextButton] it adds: a required semantic label, an opacity
/// press effect, a hover wash on web, and a high-contrast focus ring for
/// keyboard users. Colors come from the active [Theme].
class AppBtn extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  AppBtn({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.hoverEffect = true,
    this.child,
    this.padding,
    this.expand = false,
    this.isSecondary = false,
    this.circular = false,
    this.minimumSize,
    this.bgColor,
    this.border,
    this.focusNode,
    this.onFocusChanged,
  }) : _builder = null;

  /// Convenience constructor for the common "text and/or icon" button.
  AppBtn.from({
    super.key,
    required this.onPressed,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.hoverEffect = true,
    this.padding,
    this.expand = false,
    this.isSecondary = false,
    this.minimumSize,
    this.bgColor,
    this.border,
    this.focusNode,
    this.onFocusChanged,
    String? semanticLabel,
    String? text,
    IconData? icon,
    double? iconSize,
  }) : child = null,
       circular = false {
    assert(semanticLabel != null || text != null, 'AppBtn.from needs text or semanticLabel');
    this.semanticLabel = semanticLabel ?? text ?? '';
    _builder = (context) {
      if (text == null && icon == null) return const SizedBox.shrink();
      // No explicit style: build() installs a DefaultTextStyle with the right
      // foreground color for the button's background.
      final txt = text == null
          ? null
          : Text(
              text.toUpperCase(),
              textHeightBehavior: const TextHeightBehavior(applyHeightToFirstAscent: false),
            );
      final icn = icon == null ? null : Icon(icon, size: iconSize ?? 18);
      if (txt != null && icn != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [txt, const SizedBox(width: Insets.xs), icn],
        );
      }
      return (txt ?? icn)!;
    };
  }

  /// Chrome-less button: transparent, no padding. Use for tappable areas that
  /// should not look like buttons.
  // ignore: prefer_const_constructors_in_immutables
  AppBtn.basic({
    super.key,
    required this.onPressed,
    required this.semanticLabel,
    this.enableFeedback = true,
    this.pressEffect = true,
    this.hoverEffect = true,
    this.child,
    this.padding = EdgeInsets.zero,
    this.isSecondary = false,
    this.circular = false,
    this.minimumSize,
    this.focusNode,
    this.onFocusChanged,
  }) : expand = false,
       bgColor = Colors.transparent,
       border = null,
       _builder = null;

  // interaction
  final VoidCallback? onPressed;
  late final String semanticLabel;
  final bool enableFeedback;
  final FocusNode? focusNode;
  final void Function(bool hasFocus)? onFocusChanged;

  // content
  late final Widget? child;
  late final WidgetBuilder? _builder;

  // layout
  final EdgeInsets? padding;
  final bool expand;
  final bool circular;
  final Size? minimumSize;

  // style
  final bool isSecondary;
  final BorderSide? border;
  final Color? bgColor;
  final bool pressEffect;
  final bool hoverEffect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final defaultColor = isSecondary ? scheme.secondaryContainer : scheme.primary;
    final textColor = isSecondary ? scheme.onSecondaryContainer : scheme.onPrimary;
    final side = border ?? BorderSide.none;

    Widget content = _builder?.call(context) ?? child ?? const SizedBox.shrink();
    if (expand) content = Center(child: content);

    final OutlinedBorder shape = circular
        ? CircleBorder(side: side)
        : RoundedRectangleBorder(side: side, borderRadius: BorderRadius.circular(Corners.md));

    final style = ButtonStyle(
      minimumSize: ButtonStyleButton.allOrNull<Size>(minimumSize ?? Size.zero),
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      splashFactory: NoSplash.splashFactory,
      backgroundColor: ButtonStyleButton.allOrNull<Color>(bgColor ?? defaultColor),
      // Disabled because _ButtonPressEffect provides the press feedback.
      overlayColor: ButtonStyleButton.allOrNull<Color>(Colors.transparent),
      shape: ButtonStyleButton.allOrNull<OutlinedBorder>(shape),
      padding: ButtonStyleButton.allOrNull<EdgeInsetsGeometry>(
        padding ?? const EdgeInsets.all(Insets.md),
      ),
      enableFeedback: enableFeedback,
    );

    Widget button = _CustomFocusBuilder(
      focusNode: focusNode,
      onFocusChanged: onFocusChanged,
      builder: (context, focus) => Stack(
        children: [
          Opacity(
            opacity: onPressed == null ? 0.5 : 1.0,
            child: TextButton(
              onPressed: onPressed,
              style: style,
              focusNode: focus,
              child: DefaultTextStyle(
                style: (theme.textTheme.labelLarge ?? DefaultTextStyle.of(context).style).copyWith(
                  color: textColor,
                ),
                child: IconTheme.merge(
                  data: IconThemeData(color: textColor),
                  child: content,
                ),
              ),
            ),
          ),
          if (focus.hasFocus)
            Positioned.fill(
              child: IgnorePointerAndSemantics(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Corners.md),
                    border: Border.all(color: scheme.tertiary, width: 3),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (pressEffect && onPressed != null) button = _ButtonPressEffect(button);
    if (hoverEffect && kIsWeb) button = _ButtonHoverEffect(button, circular);

    if (semanticLabel.isEmpty) return button;
    return Semantics(
      label: semanticLabel,
      button: true,
      container: true,
      onTap: () => onPressed?.call(),
      child: ExcludeSemantics(child: button),
    );
  }
}

/// Transparency-based press feedback.
class _ButtonPressEffect extends StatefulWidget {
  const _ButtonPressEffect(this.child);
  final Widget child;

  @override
  State<_ButtonPressEffect> createState() => _ButtonPressEffectState();
}

class _ButtonPressEffectState extends State<_ButtonPressEffect> {
  bool _isDown = false;

  @override
  Widget build(BuildContext context) => GestureDetector(
    excludeFromSemantics: true,
    onTapDown: (_) => setState(() => _isDown = true),
    onTapUp: (_) => setState(() => _isDown = false), // TextButton usually swallows this
    onTapCancel: () => setState(() => _isDown = false),
    behavior: HitTestBehavior.translucent,
    child: Opacity(opacity: _isDown ? 0.7 : 1, child: ExcludeSemantics(child: widget.child)),
  );
}

/// Light wash on mouse-over, web only.
class _ButtonHoverEffect extends StatefulWidget {
  const _ButtonHoverEffect(this.child, this.isCircular);
  final Widget child;
  final bool isCircular;

  @override
  State<_ButtonHoverEffect> createState() => _ButtonHoverEffectState();
}

class _ButtonHoverEffectState extends State<_ButtonHoverEffect> {
  bool _isOver = false;

  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _isOver = true),
    onExit: (_) => setState(() => _isOver = false),
    child: AnimatedContainer(
      foregroundDecoration: BoxDecoration(
        color: Colors.white.withAlpha(_isOver ? 30 : 0),
        borderRadius: BorderRadius.circular(widget.isCircular ? 9999 : Corners.md),
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: widget.child,
    ),
  );
}

class _CustomFocusBuilder extends StatefulWidget {
  const _CustomFocusBuilder({required this.builder, this.focusNode, this.onFocusChanged});
  final Widget Function(BuildContext context, FocusNode focus) builder;
  final void Function(bool hasFocus)? onFocusChanged;
  final FocusNode? focusNode;

  @override
  State<_CustomFocusBuilder> createState() => _CustomFocusBuilderState();
}

class _CustomFocusBuilderState extends State<_CustomFocusBuilder> {
  late final FocusNode _focusNode = widget.focusNode ?? FocusNode();
  late final bool _ownsNode = widget.focusNode == null;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    if (_ownsNode) _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    widget.onFocusChanged?.call(_focusNode.hasFocus);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context, _focusNode);
}
