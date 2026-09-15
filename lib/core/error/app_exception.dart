class AppException implements Exception {
  final String message;
  final int? statusCode;
  final String? errorCode;

  const AppException(this.message, {this.statusCode, this.errorCode});

  @override
  String toString() {
    return 'AppException: $message (Status Code: $statusCode, Error Code: $errorCode)';
  }
}
