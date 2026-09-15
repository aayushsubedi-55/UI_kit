import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class LocalDatabaseFailure extends Failure {
  const LocalDatabaseFailure({
    String message = "Failed to access local database",
  }) : super(message);
}

class ServerFailure extends Failure {
  final int? statusCode;
  final String? errorCode;

  const ServerFailure({
    String message = "Server error occurred",
    this.statusCode,
    this.errorCode,
  }) : super(message);

  @override
  List<Object> get props => [message, statusCode ?? -1, errorCode ?? ''];
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = "Network error occurred"})
    : super(message);
}
