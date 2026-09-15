import '../error/failure.dart';

/// A [Result] is either [Success] with a value or [Error] with a [Failure].
/// Return this from repositories/usecases instead of throwing, so callers
/// must handle the failure path explicitly.
sealed class Result<T> {
  const Result();

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) error,
  }) {
    final self = this;
    if (self is Success<T>) return success(self.data);
    return error((self as Error<T>).failure);
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Error<T> extends Result<T> {
  const Error(this.failure);
  final Failure failure;
}
