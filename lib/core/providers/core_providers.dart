import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../network/dio_client.dart';
import '../services/local_storage_service.dart';
import '../session/session_manager.dart';

/// Central place for app-wide singletons. Feature providers should depend
/// on these instead of constructing their own Dio/storage instances.
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.fromEnvironment(Environment.development);
});

final sessionManagerProvider = Provider<SessionManager>((ref) {
  return SessionManager();
});

final dioProvider = Provider<Dio>((ref) {
  return DioClient.create(
    config: ref.watch(appConfigProvider),
    sessionManager: ref.watch(sessionManagerProvider),
  );
});

/// Override this in [ProviderScope.overrides] at startup with the awaited
/// instance from [LocalStorageService.create] (see app/bootstrap).
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  throw UnimplementedError('localStorageServiceProvider must be overridden in main()');
});
