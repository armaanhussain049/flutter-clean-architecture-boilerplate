import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Interceptor for adding authentication token to requests
class AuthInterceptor extends Interceptor {
  final SharedPreferences sharedPreferences;

  AuthInterceptor({required this.sharedPreferences});

  static const String _userKey = 'cached_user';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add auth token if available
    final userString = sharedPreferences.getString(_userKey);
    if (userString != null) {
      try {
        // In a real app, you'd parse the JSON and get the token
        // For simplicity, we'll assume the token is stored separately
        // You could modify UserModel to store token separately
        final userJson = userString; // This is simplified
        // Add token to headers
        // options.headers['Authorization'] = 'Bearer $token';
      } catch (e) {
        // Handle parsing error
      }
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle auth errors (401, 403)
    if (err.response?.statusCode == 401 || err.response?.statusCode == 403) {
      // Clear cached user on auth error
      sharedPreferences.remove(_userKey);
      // You could emit a logout event here
    }

    super.onError(err, handler);
  }
}