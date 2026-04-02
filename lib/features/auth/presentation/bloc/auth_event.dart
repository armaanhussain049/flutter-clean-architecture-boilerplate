import 'package:equatable/equatable.dart';

/// Events for AuthBloc
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

/// Event for user login request
class LoginRequested extends AuthEvent {
  const LoginRequested(this.email, this.password);

  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// Event for user logout request
class LogoutRequested extends AuthEvent {}

/// Event to check for cached user on app start
class CheckCachedUserRequested extends AuthEvent {}