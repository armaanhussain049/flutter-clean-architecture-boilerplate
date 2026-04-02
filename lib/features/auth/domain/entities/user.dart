import 'package:equatable/equatable.dart';

import 'package:equatable/equatable.dart';

/// User entity representing an authenticated user
/// This is the core business object in the domain layer
/// Contains only essential user information
class User extends Equatable {
  const User({
    required this.id,
    required this.email,
    required this.name,
    this.token,
  });

  /// Unique identifier for the user
  final String id;

  /// User's email address
  final String email;

  /// User's display name
  final String name;

  /// Authentication token (optional, may be null)
  final String? token;

  @override
  List<Object?> get props => [id, email, name, token];
}