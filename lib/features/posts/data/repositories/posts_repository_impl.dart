import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/core/network/network_info.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/data/models/post_model.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/repositories/posts_repository.dart';

/// Implementation of PostsRepository
class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts({
    required int page,
    required int limit,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final posts = await remoteDataSource.getPosts(page: page, limit: limit);
        await localDataSource.cachePosts(posts);
        return Right(posts);
      } on ServerException catch (e) {
        return Left(ServerFailure(message: e.message));
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      // Try to get cached posts when offline
      try {
        final cachedPosts = await localDataSource.getCachedPosts();
        if (cachedPosts != null && cachedPosts.isNotEmpty) {
          return Right(cachedPosts);
        } else {
          return Left(NetworkFailure(message: 'No internet connection and no cached data'));
        }
      } catch (e) {
        return Left(CacheFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, List<Post>?>> getCachedPosts() async {
    try {
      final posts = await localDataSource.getCachedPosts();
      return Right(posts);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cachePosts(List<Post> posts) async {
    try {
      final postModels = posts.map((post) => PostModel(
        id: post.id,
        userId: post.userId,
        title: post.title,
        body: post.body,
      )).toList();
      await localDataSource.cachePosts(postModels);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}