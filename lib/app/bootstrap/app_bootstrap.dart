import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/logger/app_logger.dart';
import '../../core/providers/core_providers.dart';
import '../../core/services/local_storage_service.dart';
import '../app.dart';

/// Everything that has to happen before `runApp`. Call `AppBootstrap.run()`
/// from `main()` instead of inlining setup there.
class AppBootstrap {
  AppBootstrap._();

  static Future<void> run() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      AppLogger.error(details.exceptionAsString(), error: details.exception, stackTrace: details.stack);
    };

    final localStorageService = await LocalStorageService.create();

    runApp(
      ProviderScope(
        overrides: [
          localStorageServiceProvider.overrideWithValue(localStorageService),
        ],
        child: const MyApp(),
      ),
    );
  }
}
