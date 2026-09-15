import '../../../../core/state/result.dart';
import '../entities/user_entity.dart';

/// Domain-facing contract. The presentation layer and usecases depend on
/// this interface, never on [AuthRepositoryImpl] directly.
abstract class AuthRepository {
  Future<Result<UserEntity>> login({required String email, required String password});
  Future<Result<void>> logout();
}
