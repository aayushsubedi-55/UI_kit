import '../../../../core/state/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginParams {
  const LoginParams({required this.email, required this.password});
  final String email;
  final String password;
}

/// Example of one usecase per action. Keep the logic here thin — this is
/// where you'd add validation or orchestration across repositories.
class LoginUsecase implements UseCase<UserEntity, LoginParams> {
  LoginUsecase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Result<UserEntity>> call(LoginParams params) {
    return _repository.login(email: params.email, password: params.password);
  }
}
