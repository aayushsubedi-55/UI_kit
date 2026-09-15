import 'package:dio/dio.dart';

import 'failure.dart';

class DioExceptionHandler {
  const DioExceptionHandler._();

  static DioExceptionHandler get instance => const DioExceptionHandler._();

  Failure handle(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        return ServerFailure(
          message:
              _messageFromResponse(exception.response) ??
              exception.message ??
              'Server error occurred',
          statusCode: exception.response?.statusCode,
          errorCode: _errorCodeFromResponse(exception.response),
        );
      case DioExceptionType.cancel:
        return const ServerFailure(message: 'Request was cancelled');
      case DioExceptionType.badCertificate:
        return const ServerFailure(message: 'Invalid certificate');
      case DioExceptionType.unknown:
        return NetworkFailure(
          message: exception.message ?? 'Network error occurred',
        );
    }
  }

  String? _messageFromResponse(Response? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'] ?? data['error'];
      if (message is String) return message;
    }
    return null;
  }

  String? _errorCodeFromResponse(Response? response) {
    final data = response?.data;
    if (data is Map<String, dynamic>) {
      final code = data['errorCode'] ?? data['code'];
      if (code != null) return code.toString();
    }
    return null;
  }
}
