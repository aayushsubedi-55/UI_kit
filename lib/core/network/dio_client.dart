import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../session/session_manager.dart';
import 'interceptor/auth_interceptor.dart';
import 'interceptor/logging_interceptor.dart';

/// Builds the single [Dio] instance the app should use for all HTTP calls.
/// Reuse this factory instead of instantiating `Dio()` per feature.
class DioClient {
  static Dio create({required AppConfig config, required SessionManager sessionManager}) {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.apiBaseUrl,
        connectTimeout: AppConfig.connectionTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(sessionManager),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}
