import 'package:equatable/equatable.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/entities/post.dart';

/// States for PostsBloc
abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

/// Initial state
class PostsInitial extends PostsState {}

/// Loading state for initial fetch
class PostsLoading extends PostsState {}

/// Loading state for pagination
class PostsLoadingMore extends PostsState {
  const PostsLoadingMore(this.posts);

  final List<Post> posts;

  @override
  List<Object> get props => [posts];
}

/// Loaded state with posts
class PostsLoaded extends PostsState {
  const PostsLoaded({
    required this.posts,
    required this.hasReachedMax,
  });

  final List<Post> posts;
  final bool hasReachedMax;

  PostsLoaded copyWith({
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return PostsLoaded(
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [posts, hasReachedMax];
}

/// Error state
class PostsError extends PostsState {
  const PostsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}