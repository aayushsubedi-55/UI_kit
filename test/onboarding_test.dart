import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:pracproj/app/routes/screen_paths.dart';
import 'package:pracproj/core/providers/core_providers.dart';
import 'package:pracproj/core/services/local_storage_service.dart';
import 'package:pracproj/feature/onboarding/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Hosts the screen on a router so `context.go` has somewhere to land.
Future<LocalStorageService> _pumpOnboarding(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await LocalStorageService.create();

  final router = GoRouter(
    initialLocation: ScreenPaths.onboarding,
    routes: [
      GoRoute(
        path: ScreenPaths.onboarding,
        builder: (_, _) => const OnboardingScreen(),
      ),
      GoRoute(
        path: ScreenPaths.login,
        builder: (_, _) => const Scaffold(body: Text('login screen')),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [localStorageServiceProvider.overrideWithValue(storage)],
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  return storage;
}

void main() {
  testWidgets('Next walks all three pages, then Get started finishes', (tester) async {
    final storage = await _pumpOnboarding(tester);

    expect(OnboardingScreen.pages.length, 3);
    expect(find.text(OnboardingScreen.pages[0].title), findsOneWidget);
    expect(find.text('01'), findsOneWidget);
    expect(find.text('03'), findsOneWidget);

    for (var i = 1; i < OnboardingScreen.pages.length; i++) {
      await tester.tap(find.text('NEXT'));
      await tester.pumpAndSettle();
      expect(find.text(OnboardingScreen.pages[i].title), findsOneWidget);
      // On the last page current == total, so '03' renders twice.
      expect(find.text('0${i + 1}'), findsAtLeastNWidgets(1));
    }

    // Last page swaps the label and completes onboarding.
    expect(find.text('NEXT'), findsNothing);
    await tester.tap(find.text('GET STARTED'));
    await tester.pumpAndSettle();

    expect(find.text('login screen'), findsOneWidget);
    expect(storage.getBool('seen_onboarding'), isTrue);
  });

  testWidgets('Skip finishes from the first page', (tester) async {
    final storage = await _pumpOnboarding(tester);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('login screen'), findsOneWidget);
    expect(storage.getBool('seen_onboarding'), isTrue);
  });

  testWidgets('Swiping advances the page and the indicator', (tester) async {
    await _pumpOnboarding(tester);

    await tester.drag(find.byType(PageView), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text(OnboardingScreen.pages[1].title), findsOneWidget);
    expect(find.text('02'), findsOneWidget);
  });
}
