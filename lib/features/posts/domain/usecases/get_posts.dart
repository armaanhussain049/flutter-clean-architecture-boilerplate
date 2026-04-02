import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/core/usecases/usecase.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/repositories/posts_repository.dart';

/// Get posts use case with pagination
class GetPostsUseCase implements UseCase<List<Post>, GetPostsParams> {
  final PostsRepository repository;

  GetPostsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(GetPostsParams params) async {
    return await repository.getPosts(
      page: params.page,
      limit: params.limit,
    );
  }
}

/// Parameters for get posts use case
class GetPostsParams {
  final int page;
  final int limit;

  const GetPostsParams({
    required this.page,
    required this.limit,
  });
}