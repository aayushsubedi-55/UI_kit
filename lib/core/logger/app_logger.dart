import 'dart:developer' as developer;

import '../config/app_config.dart';

/// Thin wrapper over `dart:developer` so log calls are one-line and can be
/// silenced centrally via [AppConfig.enableLogging].
class AppLogger {
  AppLogger._();

  static void debug(String message, {String name = 'DEBUG'}) =>
      _log(message, name: name);

  static void info(String message, {String name = 'INFO'}) =>
      _log(message, name: name);

  static void warning(String message, {String name = 'WARNING'}) =>
      _log(message, name: name, level: 900);

  static void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(message, name: 'ERROR', level: 1000, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String message, {
    required String name,
    int level = 500,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!AppConfig.enableLogging) return;
    developer.log(
      message,
      name: name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
