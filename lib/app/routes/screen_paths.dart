abstract class ScreenPaths {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String detail = '/detail/:id';
  static const String pageNotFound = '/page-not-found';

  static String getDetailPath(String id) => '/detail/$id';
}
