import 'package:dio/dio.dart';

import '../../config/app_config.dart';
import '../../logger/app_logger.dart';

/// Logs every request/response/error when [AppConfig.enableDetailedLogging] is on.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConfig.enableDetailedLogging) {
      AppLogger.debug('--> ${options.method} ${options.uri}\nheaders: ${options.headers}\nbody: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.enableDetailedLogging) {
      AppLogger.debug('<-- ${response.statusCode} ${response.requestOptions.uri}\nbody: ${response.data}');
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      '<-- ERROR ${err.requestOptions.uri}',
      error: err.message,
      stackTrace: err.stackTrace,
    );
    handler.next(err);
  }
}
