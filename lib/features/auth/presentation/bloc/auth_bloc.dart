import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/usecases/login.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/usecases/logout.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/presentation/bloc/auth_state.dart';

/// BLoC for handling authentication state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCachedUserUseCase getCachedUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.getCachedUserUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckCachedUserRequested>(_onCheckCachedUserRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await logoutUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(AuthInitial()),
    );
  }

  Future<void> _onCheckCachedUserRequested(
    CheckCachedUserRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await getCachedUserUseCase(NoParams());
    result.fold(
      (failure) => emit(AuthInitial()), // If no cached user, stay initial
      (user) => user != null ? emit(AuthAuthenticated(user)) : emit(AuthInitial()),
    );
  }
}