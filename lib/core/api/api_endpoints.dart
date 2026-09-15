/// Relative endpoint paths, joined with [AppConfig.apiBaseUrl] by Dio's
/// baseUrl. Group by feature so this stays easy to scan as it grows.
class ApiEndpoints {
  ApiEndpoints._();

  // Auth
  static const String login = '/auth/login';
  static const String logout = '/auth/logout';
  static const String refreshToken = '/auth/refresh';
}
