import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pracproj/app/app.dart';
import 'package:pracproj/core/providers/core_providers.dart';
import 'package:pracproj/core/services/local_storage_service.dart';
import 'package:pracproj/feature/splash/screens/splash_screen.dart';

void main() {
  testWidgets('App boots to the splash screen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final localStorageService = await LocalStorageService.create();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStorageServiceProvider.overrideWithValue(localStorageService)],
        child: const MyApp(),
      ),
    );

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Once the minimum-display timer fires the splash hands off. No
    // pumpAndSettle: the spinner animates forever, so it never settles.
    await tester.pump(SplashScreen.minVisibleDuration);
    await tester.pump();
    expect(find.byType(SplashScreen), findsNothing);
  });
}
