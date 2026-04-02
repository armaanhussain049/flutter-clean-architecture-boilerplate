import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/presentation/bloc/posts_event.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/presentation/bloc/posts_state.dart';

/// BLoC for handling posts state
class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUseCase getPostsUseCase;

  PostsBloc({required this.getPostsUseCase}) : super(PostsInitial()) {
    on<FetchPosts>(_onFetchPosts);
    on<LoadMorePosts>(_onLoadMorePosts);
  }

  int _currentPage = 1;
  final int _limit = 10; // Can be from config
  bool _hasReachedMax = false;

  Future<void> _onFetchPosts(
    FetchPosts event,
    Emitter<PostsState> emit,
  ) async {
    _currentPage = 1;
    _hasReachedMax = false;

    emit(PostsLoading());
    final result = await getPostsUseCase(GetPostsParams(
      page: _currentPage,
      limit: _limit,
    ));

    result.fold(
      (failure) => emit(PostsError(failure.message)),
      (posts) {
        _currentPage++;
        _hasReachedMax = posts.length < _limit;
        emit(PostsLoaded(
          posts: posts,
          hasReachedMax: _hasReachedMax,
        ));
      },
    );
  }

  Future<void> _onLoadMorePosts(
    LoadMorePosts event,
    Emitter<PostsState> emit,
  ) async {
    if (_hasReachedMax) return;

    final currentState = state;
    if (currentState is PostsLoaded) {
      emit(PostsLoadingMore(currentState.posts));

      final result = await getPostsUseCase(GetPostsParams(
        page: _currentPage,
        limit: _limit,
      ));

      result.fold(
        (failure) => emit(PostsError(failure.message)),
        (newPosts) {
          if (newPosts.isEmpty) {
            _hasReachedMax = true;
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            _currentPage++;
            final updatedPosts = List<Post>.from(currentState.posts)
              ..addAll(newPosts);
            _hasReachedMax = newPosts.length < _limit;
            emit(PostsLoaded(
              posts: updatedPosts,
              hasReachedMax: _hasReachedMax,
            ));
          }
        },
      );
    }
  }
}