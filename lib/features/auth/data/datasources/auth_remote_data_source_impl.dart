import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/models/user_model.dart';

/// Implementation of AuthRemoteDataSource using Dio
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    // Mock API call - replace with real API
    await Future.delayed(const Duration(seconds: 2));
    if (email == 'test@example.com' && password == 'password') {
      return const UserModel(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        token: 'mock_jwt_token_12345',
      );
    } else {
      throw ServerException(message: 'Invalid credentials', statusCode: 401);
    }
  }

  @override
  Future<void> logout(String token) async {
    // Mock logout - in real app, call API
    await Future.delayed(const Duration(seconds: 1));
    // Simulate successful logout
  }
}