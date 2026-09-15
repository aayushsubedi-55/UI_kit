import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../models/user_model.dart';

/// Talks to the API only. Throws [DioException] on failure — the
/// repository is responsible for turning that into a [Failure].
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<({UserModel user, String token})> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: {'email': email, 'password': password},
    );
    final data = response.data as Map<String, dynamic>;
    return (user: UserModel.fromJson(data['user'] as Map<String, dynamic>), token: data['token'] as String);
  }

  Future<void> logout() => _dio.post(ApiEndpoints.logout);
}
