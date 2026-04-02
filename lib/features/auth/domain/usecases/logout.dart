import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Logout use case
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}

/// Get cached user use case
class GetCachedUserUseCase implements UseCase<User?, NoParams> {
  final AuthRepository repository;

  GetCachedUserUseCase(this.repository);

  @override
  Future<Either<Failure, User?>> call(NoParams params) async {
    return await repository.getCachedUser();
  }
}