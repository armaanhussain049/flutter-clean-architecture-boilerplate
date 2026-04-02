import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/core/network/network_info.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/models/user_model.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/repositories/auth_repository.dart';

/// Implementation of AuthRepository
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        final userModel = await remoteDataSource.login(email, password);
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return Left(NetworkFailure(message: 'No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Get cached user to get token
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null && cachedUser.token != null) {
        if (await networkInfo.isConnected) {
          await remoteDataSource.logout(cachedUser.token!);
        }
      }
      await localDataSource.clearCachedUser();
      return const Right(null);
    } catch (e) {
      // Even if remote logout fails, clear local cache
      await localDataSource.clearCachedUser();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, User?>> getCachedUser() async {
    try {
      final userModel = await localDataSource.getCachedUser();
      return Right(userModel);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}