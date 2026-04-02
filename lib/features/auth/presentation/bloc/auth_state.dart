import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/entities/user.dart';

/// States for AuthBloc
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// Initial state when app starts
class AuthInitial extends AuthState {}

/// Loading state during authentication operations
class AuthLoading extends AuthState {}

/// State when user is authenticated
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

/// State when authentication fails
class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}