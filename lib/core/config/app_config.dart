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
        return AppConfig(
          environment: env,
          apiBaseUrl: 'https://dev.api.example.com',
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
