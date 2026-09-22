import 'package:flutter/foundation.dart';

enum Environment { development, staging, production }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;

  AppConfig({required this.environment, required this.apiBaseUrl});

  static Duration get connectionTimeout => const Duration(seconds: 30);
  static Duration get receiveTimeout => const Duration(seconds: 30);
  static Duration get sendTimeout => const Duration(seconds: 90);

  static const bool enableLogging = true;
  static const bool enableDetailedLogging = true;

  factory AppConfig.fromEnvironment(Environment env) {
    switch (env) {
      case Environment.development:
        // The local backend in ../backend. An Android emulator reaches the
        // host machine at 10.0.2.2, not localhost -- localhost there is the
        // emulator itself. On a physical device use your machine's LAN IP.
        return AppConfig(
          environment: env,
          apiBaseUrl: defaultTargetPlatform == TargetPlatform.android && !kIsWeb
              ? 'http://10.0.2.2:3000'
              : 'http://localhost:3000',
        );
      case Environment.staging:
        return AppConfig(
          environment: env,
          apiBaseUrl: 'https://staging.api.example.com',
        );
      case Environment.production:
        return AppConfig(
          environment: env,
          apiBaseUrl: 'https://api.example.com',
        );
    }
  }
}
