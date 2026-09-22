import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n/generated/app_localizations.dart';
import '../../../app/routes/screen_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/style/app_sizes.dart';
import '../../../core/widget/common/app_logo.dart';
import '../../../core/widget/controls/app_loading_indicator.dart';

const _seenOnboardingKey = 'seen_onboarding';

/// Decides where to send the user (onboarding / login / home) then gets
/// out of the way. Keep this screen free of business logic.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  /// Floor on how long the brand mark stays up, so a fast start-up doesn't
  /// flash a frame of logo and vanish. Drop to `Duration.zero` to disable.
  static const minVisibleDuration = Duration(milliseconds: 1200);

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _redirect());
  }

  Future<void> _redirect() async {
    // Started first so it runs alongside the lookups below: the splash costs
    // us whichever is slower, not the sum of the two.
    final minVisible = Future.delayed(SplashScreen.minVisibleDuration);

    final seenOnboarding =
        ref.read(localStorageServiceProvider).getBool(_seenOnboardingKey) ?? false;

    // Only touch secure storage when the answer can actually change the route.
    final String path;
    if (!seenOnboarding) {
      path = ScreenPaths.onboarding;
    } else {
      final isLoggedIn = await ref.read(sessionManagerProvider).isLoggedIn;
      path = isLoggedIn ? ScreenPaths.home : ScreenPaths.login;
    }

    await minVisible;
    if (!mounted) return;
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // Neutral ground so the logo's own brand gradient reads cleanly.
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const AppLogo(size: 112),
            const SizedBox(height: Insets.md),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: Insets.xl),
            const AppLoadingIndicator(size: 28, color: AppLogo.brandStart),
          ],
        ),
      ),
    );
  }
}
