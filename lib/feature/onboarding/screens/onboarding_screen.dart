import 'package:flutter/material.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/widget/app_button.dart';

/// Minimal single-page onboarding. Swap the body for a PageView once
/// there's more than one slide.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => Navigator.of(context).pushReplacementNamed(AppRoutes.login),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
