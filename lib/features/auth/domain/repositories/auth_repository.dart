import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/entities/user.dart';

/// Repository interface for authentication operations
/// Defines the contract for authentication-related data operations
/// Implementations will handle both remote API calls and local caching
abstract class AuthRepository {
  /// Authenticate user with email and password
  /// Returns authenticated User or Failure
  Future<Either<Failure, User>> login(String email, String password);

  /// Logout current user
  /// Clears authentication state and cached data
  Future<Either<Failure, void>> logout();

  /// Get cached user if available (for auto-login)
  /// Returns cached User or null if not found
  Future<Either<Failure, User?>> getCachedUser();
}