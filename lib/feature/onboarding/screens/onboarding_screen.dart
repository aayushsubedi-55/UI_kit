import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/screen_paths.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/widget/app_button.dart';

/// Minimal single-page onboarding. Swap the body for a PageView once
/// there's more than one slide.
class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  static const _seenOnboardingKey = 'seen_onboarding';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Welcome', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text('Tell users what this app does here.', textAlign: TextAlign.center),
              const SizedBox(height: 32),
              AppButton(
                label: 'Get started',
                onPressed: () async {
                  await ref.read(localStorageServiceProvider).setBool(_seenOnboardingKey, true);
                  if (context.mounted) {
                    context.go(ScreenPaths.login);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
