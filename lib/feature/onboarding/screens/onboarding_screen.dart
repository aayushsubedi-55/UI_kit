import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/screen_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/style/app_sizes.dart';
import '../../../core/widget/app_button.dart';
import '../../../core/widget/common/layout_helpers.dart';
import '../../../core/widget/controls/app_btn.dart';
import '../../../core/widget/controls/diagonal_text_page_indicator.dart';
import '../../../core/widget/controls/previous_next_navigation.dart';

/// One onboarding slide. Add or remove entries in [OnboardingScreen.pages];
/// the indicator and the button labels follow automatically.
class OnboardingPage {
  const OnboardingPage({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  static const _seenOnboardingKey = 'seen_onboarding';

  static const pages = [
    OnboardingPage(
      icon: Icons.explore_outlined,
      title: 'Welcome',
      body: 'Tell users what this app does here, in one short sentence.',
    ),
    OnboardingPage(
      icon: Icons.bolt_outlined,
      title: 'Stay in flow',
      body: 'Describe the one thing that makes this faster than the alternative.',
    ),
    OnboardingPage(
      icon: Icons.lock_outline,
      title: 'Your data, your call',
      body: 'Close with the promise that earns the sign-up on the next screen.',
    ),
  ];

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _controller = PageController();
  int _index = 0;

  bool get _isLastPage => _index == OnboardingScreen.pages.length - 1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goTo(int index) {
    if (index < 0 || index >= OnboardingScreen.pages.length) return;
    _controller.animateToPage(index, duration: Times.fast, curve: Curves.easeOut);
  }

  Future<void> _finish() async {
    await ref
        .read(localStorageServiceProvider)
        .setBool(OnboardingScreen._seenOnboardingKey, true);
    if (mounted) context.go(ScreenPaths.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(Insets.xs),
                child: AppBtn.basic(
                  onPressed: _finish,
                  semanticLabel: 'Skip onboarding',
                  padding: const EdgeInsets.all(Insets.xs),
                  child: Text('Skip', style: Theme.of(context).textTheme.labelLarge),
                ),
              ),
            ),
            Expanded(
              // Adds arrow-key and prev/next button navigation on desktop and
              // web; renders nothing extra on mobile, where swiping is enough.
              child: PreviousNextNavigation(
                onPreviousPressed: _index > 0 ? () => _goTo(_index - 1) : null,
                onNextPressed: _isLastPage ? null : () => _goTo(_index + 1),
                child: PageView.builder(
                  controller: _controller,
                  itemCount: OnboardingScreen.pages.length,
                  onPageChanged: (i) => setState(() => _index = i),
                  itemBuilder: (_, i) => _PageView(page: OnboardingScreen.pages[i]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Insets.md),
              child: CenteredBox(
                width: Sizes.maxContentWidth3,
                child: Column(
                  children: [
                    DiagonalTextPageIndicator(
                      current: _index + 1,
                      total: OnboardingScreen.pages.length,
                    ),
                    const SizedBox(height: Insets.md),
                    AppButton(
                      label: _isLastPage ? 'Get started' : 'Next',
                      onPressed: _isLastPage ? _finish : () => _goTo(_index + 1),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView({required this.page});

  final OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CenteredBox(
      width: Sizes.maxContentWidth3,
      padding: const EdgeInsets.symmetric(horizontal: Insets.md),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(page.icon, size: Insets.offset, color: theme.colorScheme.primary),
          const SizedBox(height: Insets.lg),
          Text(page.title, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
          const SizedBox(height: Insets.sm),
          Text(
            page.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
