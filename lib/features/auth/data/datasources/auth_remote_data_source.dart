import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/models/user_model.dart';

/// Remote data source for authentication
abstract class AuthRemoteDataSource {
  /// Perform login and return user with token
  Future<UserModel> login(String email, String password);

  /// Logout from remote server
  Future<void> logout(String token);
}

/// Implementation using Dio
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await client.post(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException(
          message: response.data['message'] ?? 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }

  @override
  Future<void> logout(String token) async {
    try {
      await client.post(
        '/auth/logout',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Logout failed',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

/// Custom exception for server errors
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}