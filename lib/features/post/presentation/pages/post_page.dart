import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/common/widgets/loader.dart';
import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:boilerplate_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate_flutter/features/post/presentation/bloc/post_bloc.dart';
import 'package:boilerplate_flutter/features/post/presentation/pages/add_new_post_page.dart';
import 'package:boilerplate_flutter/features/post/presentation/widgets/post_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const PostPage(),
      );
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  void _fetchPosts() {
    if (context.read<PostBloc>().state is! PostDisplaySuccess) {
      context.read<PostBloc>().add(PostFetchAllPosts());
    }
  }

  Future<void> _refreshPosts() async {
    context.read<PostBloc>().add(PostFetchAllPosts());
  }

  bool _isOwnPost(String postUserId) {
    return (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id ==
        postUserId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post App'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                AddNewPostPage.route(),
              );
              // Refresh posts if we returned from adding a new post
              if (result == true) {
                context.read<PostBloc>().add(PostFetchAllPosts());
              }
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: BlocConsumer<PostBloc, PostState>(
        listener: (context, state) {
          if (state is PostFailure) {
            showSnackBar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is PostLoading) {
            return const Loader();
          }
          if (state is PostDisplaySuccess) {
            return RefreshIndicator(
              onRefresh: _refreshPosts,
              child: ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return Dismissible(
                    key: Key(post.id),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 40),
                      child: const Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) async {
                      if (_isOwnPost(post.userId)) {
                        return true;
                      }
                      showSnackBar(context, 'You cannot delete this post');

                      return false;
                    },
                    child: PostCard(
                      post: post,
                      color: index % 3 == 0
                          ? AppPallete.gradient1
                          : index % 3 == 1
                              ? AppPallete.gradient2
                              : AppPallete.gradient3,
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
