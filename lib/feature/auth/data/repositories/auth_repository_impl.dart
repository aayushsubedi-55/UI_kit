import 'package:dio/dio.dart';

import '../../../../core/error/dio_exception_handler.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../core/state/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

/// Bridges the domain contract to the data source, converting thrown
/// [DioException]s into [Result.error] so nothing above this layer
/// needs a try/catch.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._sessionManager);

  final AuthRemoteDataSource _remoteDataSource;
  final SessionManager _sessionManager;

  @override
  Future<Result<UserEntity>> login({required String email, required String password}) async {
    try {
      final result = await _remoteDataSource.login(email: email, password: password);
      await _sessionManager.saveToken(result.token);
      return Success(result.user);
    } on DioException catch (e) {
      return Error(DioExceptionHandler.instance.handle(e));
    }
  }

  @override
  Future<Result<void>> logout() async {
    try {
      await _remoteDataSource.logout();
      await _sessionManager.clear();
      return const Success(null);
    } on DioException catch (e) {
      return Error(DioExceptionHandler.instance.handle(e));
    }
  }
}
