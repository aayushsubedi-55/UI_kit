import '../state/result.dart';

/// Base contract for a single-purpose business action. One usecase = one
/// verb (e.g. `LoginUsecase`, `LogoutUsecase`) — keep them small.
abstract class UseCase<T, Params> {
  Future<Result<T>> call(Params params);
}

/// Use as the [Params] type for usecases that take no arguments.
class NoParams {
  const NoParams();
}
