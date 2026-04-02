import 'package:equatable/equatable.dart';

/// Events for PostsBloc
abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

/// Event to fetch initial posts
class FetchPosts extends PostsEvent {}

/// Event to load more posts (pagination)
class LoadMorePosts extends PostsEvent {}