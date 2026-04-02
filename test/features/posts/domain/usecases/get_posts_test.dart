import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/repositories/posts_repository.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_test/flutter_test.dart';

// Mock repository implementation for testing
class MockPostsRepository implements PostsRepository {
  List<Post>? mockPosts;
  Failure? mockFailure;

  @override
  Future<Either<Failure, List<Post>>> getPosts({
    required int page,
    required int limit,
  }) async {
    if (mockFailure != null) {
      return Left(mockFailure!);
    }
    return Right(mockPosts!);
  }

  @override
  Future<Either<Failure, List<Post>?>> getCachedPosts() async {
    return Right(mockPosts);
  }

  @override
  Future<Either<Failure, void>> cachePosts(List<Post> posts) async {
    return const Right(null);
  }
}

void main() {
  late GetPostsUseCase useCase;
  late MockPostsRepository mockRepository;

  setUp(() {
    mockRepository = MockPostsRepository();
    useCase = GetPostsUseCase(mockRepository);
  });

  const tPosts = [
    Post(id: 1, userId: 1, title: 'Test Title 1', body: 'Test Body 1'),
    Post(id: 2, userId: 1, title: 'Test Title 2', body: 'Test Body 2'),
  ];

  test('should return posts when getPosts is successful', () async {
    // Arrange
    mockRepository.mockPosts = tPosts;

    // Act
    final result = await useCase(const GetPostsParams(page: 1, limit: 10));

    // Assert
    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should not return failure'),
      (posts) => expect(posts, tPosts),
    );
  });

  test('should return failure when getPosts fails', () async {
    // Arrange
    mockRepository.mockFailure = const ServerFailure(message: 'Server error');

    // Act
    final result = await useCase(const GetPostsParams(page: 1, limit: 10));

    // Assert
    expect(result.isLeft(), true);
    result.fold(
      (failure) => expect(failure.message, 'Server error'),
      (posts) => fail('Should not return posts'),
    );
  });
}