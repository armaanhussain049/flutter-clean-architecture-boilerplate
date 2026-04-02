import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/entities/post.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/presentation/bloc/posts_event.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/presentation/bloc/posts_state.dart';

/// Posts page with infinite scroll
class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PostsBloc>().add(FetchPosts());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PostsBloc>().add(LoadMorePosts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is PostsInitial || state is PostsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PostsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PostsBloc>().add(FetchPosts());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is PostsLoaded) {
            return _buildPostsList(state.posts, state.hasReachedMax);
          } else if (state is PostsLoadingMore) {
            return _buildPostsList(state.posts, false, isLoadingMore: true);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPostsList(List<Post> posts, bool hasReachedMax, {bool isLoadingMore = false}) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: hasReachedMax ? posts.length : posts.length + 1,
      itemBuilder: (context, index) {
        if (index >= posts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final post = posts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  post.body,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'User ID: ${post.userId}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}