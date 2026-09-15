import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/providers/core_providers.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    AuthRemoteDataSource(ref.watch(dioProvider)),
    ref.watch(sessionManagerProvider),
  );
});

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  return LoginUsecase(ref.watch(authRepositoryProvider));
});

/// Holds the logged-in user (or null) plus loading/error state.
/// UI watches this; call `ref.read(authControllerProvider.notifier).login(...)`.
final authControllerProvider = AsyncNotifierProvider<AuthController, UserEntity?>(AuthController.new);

class AuthController extends AsyncNotifier<UserEntity?> {
  @override
  UserEntity? build() => null;

  Future<Failure?> login({required String email, required String password}) async {
    state = const AsyncLoading();
    final result = await ref.read(loginUsecaseProvider).call(LoginParams(email: email, password: password));
    return result.when(
      success: (user) {
        state = AsyncData(user);
        return null;
      },
      error: (failure) {
        state = AsyncError(failure, StackTrace.current);
        return failure;
      },
    );
  }
}
