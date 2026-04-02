import 'dart:convert';

import 'package:flutter_clean_architecture_boilerplate/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for authentication
abstract class AuthLocalDataSource {
  /// Cache the authenticated user
  Future<void> cacheUser(UserModel user);

  /// Get the cached user
  Future<UserModel?> getCachedUser();

  /// Clear cached user (logout)
  Future<void> clearCachedUser();
}

/// Implementation using SharedPreferences
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  static const String _userKey = 'cached_user';

  @override
  Future<void> cacheUser(UserModel user) async {
    final userJson = user.toJson();
    await sharedPreferences.setString(_userKey, userJson.toString());
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final userString = sharedPreferences.getString(_userKey);
    if (userString != null) {
      final userJson = json.decode(userString) as Map<String, dynamic>;
      return UserModel.fromJson(userJson);
    }
    return null;
  }

  @override
  Future<void> clearCachedUser() async {
    await sharedPreferences.remove(_userKey);
  }
}