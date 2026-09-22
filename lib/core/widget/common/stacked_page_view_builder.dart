import 'package:flutter/material.dart';

/// Decouples the scrollable area from the size of the PageView itself.
///
/// Internally it stacks an invisible PageView underneath to own the gesture,
/// then drives a second `follower` controller that you hand to the nested
/// PageView holding the real content. Simplifies layout and reads better to
/// screen readers than one oversized PageView.
class StackedPageViewBuilder extends StatefulWidget {
  const StackedPageViewBuilder({
    super.key,
    this.initialIndex = 0,
    required this.pageCount,
    required this.builder,
    this.onInit,
  });

  final int initialIndex;
  final int pageCount;
  final Widget Function(BuildContext context, PageController controller, PageController follower)
  builder;
  final void Function(PageController controller, PageController follower)? onInit;

  @override
  State<StackedPageViewBuilder> createState() => _StackedPageViewBuilderState();
}

class _StackedPageViewBuilderState extends State<StackedPageViewBuilder> {
  late final _controller = PageController(initialPage: widget.initialIndex);
  late final _follower = PageController(initialPage: widget.initialIndex);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
    widget.onInit?.call(_controller, _follower);
  }

  @override
  void dispose() {
    _controller.dispose();
    _follower.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ExcludeSemantics(
            child: PageView.builder(
              itemCount: widget.pageCount,
              controller: _controller,
              itemBuilder: (_, _) => Container(color: Colors.transparent),
            ),
          ),
        ),
        widget.builder(context, _controller, _follower),
      ],
    );
  }

  void _handleControllerChanged() => _follower.jumpTo(_controller.position.pixels);
}
