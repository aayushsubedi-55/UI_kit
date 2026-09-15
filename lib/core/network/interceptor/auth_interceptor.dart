import 'package:dio/dio.dart';

import '../../constants/api_constant.dart';
import '../../session/session_manager.dart';

/// Attaches the bearer token (when present) to every outgoing request.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionManager);

  final SessionManager _sessionManager;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _sessionManager.getToken();
    if (token != null) {
      options.headers[ApiConstant.authorization] = '${ApiConstant.bearer} $token';
    }
    handler.next(options);
  }
}
