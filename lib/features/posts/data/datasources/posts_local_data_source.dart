import 'dart:convert';

import 'package:flutter_clean_architecture_boilerplate/features/posts/data/models/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for posts caching
abstract class PostsLocalDataSource {
  /// Cache posts locally
  Future<void> cachePosts(List<PostModel> posts);

  /// Get cached posts
  Future<List<PostModel>?> getCachedPosts();
}

/// Implementation using SharedPreferences
class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostsLocalDataSourceImpl({required this.sharedPreferences});

  static const String _postsKey = 'cached_posts';

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    final postsJson = posts.map((post) => post.toJson()).toList();
    await sharedPreferences.setString(_postsKey, json.encode(postsJson));
  }

  @override
  Future<List<PostModel>?> getCachedPosts() async {
    final postsString = sharedPreferences.getString(_postsKey);
    if (postsString != null) {
      final List<dynamic> postsJson = json.decode(postsString);
      return postsJson.map((json) => PostModel.fromJson(json)).toList();
    }
    return null;
  }
}