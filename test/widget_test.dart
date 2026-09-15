import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pracproj/app/app.dart';
import 'package:pracproj/core/providers/core_providers.dart';
import 'package:pracproj/core/services/local_storage_service.dart';

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

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
