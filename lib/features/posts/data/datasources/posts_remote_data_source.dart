import 'package:dio/dio.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/data/models/post_model.dart';

/// Remote data source for posts
abstract class PostsRemoteDataSource {
  /// Fetch posts from API with pagination
  Future<List<PostModel>> getPosts({
    required int page,
    required int limit,
  });
}

/// Implementation using Dio
class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final Dio client;

  PostsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getPosts({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await client.get(
        '/posts',
        queryParameters: {
          '_page': page,
          '_limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw ServerException(
          message: 'Failed to load posts',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        message: e.response?.data['message'] ?? e.message ?? 'Network error',
        statusCode: e.response?.statusCode,
      );
    }
  }
}

/// Custom exception for server errors
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Status: $statusCode)';
}