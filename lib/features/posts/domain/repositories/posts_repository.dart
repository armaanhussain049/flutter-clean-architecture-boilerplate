import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/entities/post.dart';

/// Repository interface for posts operations
abstract class PostsRepository {
  /// Get paginated posts
  Future<Either<Failure, List<Post>>> getPosts({
    required int page,
    required int limit,
  });

  /// Get cached posts if available
  Future<Either<Failure, List<Post>?>> getCachedPosts();

  /// Cache posts locally
  Future<Either<Failure, void>> cachePosts(List<Post> posts);
}