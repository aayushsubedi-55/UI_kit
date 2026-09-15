import 'package:go_router/go_router.dart';

abstract class ScreenPaths {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String detail = '/detail/:id';
  static const String pageNotFound = '/page-not-found';

  static String getDetailPath(String id) => '/detail/$id';
}
