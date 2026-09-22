/// Shared widget library, ported from the Wonderous reference app
/// (github.com/gskinnerTeam/flutter-wonderous-app, BSD-3-Clause).
///
/// Wonder-specific pieces and the `$styles` / get_it machinery were dropped:
/// these all read from the ambient [Theme] and the consts in
/// `core/style/app_sizes.dart`, and add no new package dependencies.
library;

export 'app_button.dart';
export 'app_error_view.dart';
export 'common/app_backdrop.dart';
export 'common/app_scroll_behavior.dart';
export 'common/curved_clippers.dart';
export 'common/dashed_line.dart';
export 'common/gradient_container.dart';
export 'common/keyboard_listeners.dart';
export 'common/layout_helpers.dart';
export 'common/lazy_indexed_stack.dart';
export 'common/opening_card.dart';
export 'common/pop_router_on_over_scroll.dart';
export 'common/render_helpers.dart';
export 'common/stacked_page_view_builder.dart';
export 'controls/app_btn.dart';
export 'controls/app_header.dart';
export 'controls/app_loading_indicator.dart';
export 'controls/circle_buttons.dart';
export 'controls/diagonal_text_page_indicator.dart';
export 'controls/eight_way_swipe_detector.dart';
export 'controls/previous_next_navigation.dart';
export 'controls/scroll_decorator.dart';
export 'controls/simple_checkbox.dart';
export 'controls/trackpad_listener.dart';
