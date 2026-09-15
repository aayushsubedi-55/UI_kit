import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/screen_paths.dart';
import '../../../core/providers/core_providers.dart';

const _seenOnboardingKey = 'seen_onboarding';

/// Decides where to send the user (onboarding / login / home) then gets
/// out of the way. Keep this screen free of business logic.
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

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
    final seenOnboarding = ref.read(localStorageServiceProvider).getBool(_seenOnboardingKey) ?? false;
    final isLoggedIn = await ref.read(sessionManagerProvider).isLoggedIn;
    if (!mounted) return;

    final path = !seenOnboarding
        ? ScreenPaths.onboarding
        : isLoggedIn
        ? ScreenPaths.home
        : ScreenPaths.login;
    context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
