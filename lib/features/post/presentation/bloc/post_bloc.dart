import 'dart:io';

import 'package:boilerplate_flutter/core/usecase/usecase.dart';
import 'package:boilerplate_flutter/features/post/domain/entities/post.dart';
import 'package:boilerplate_flutter/features/post/domain/usecases/get_all_posts.dart';
import 'package:boilerplate_flutter/features/post/domain/usecases/upload_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final UploadPost _uploadPost;
  final GetAllPosts _getAllPosts;
  PostBloc({
    required UploadPost uploadPost,
    required GetAllPosts getAllPosts,
  })  : _uploadPost = uploadPost,
        _getAllPosts = getAllPosts,
        super(PostInitial()) {
    on<PostEvent>((_, emit) => emit(PostLoading()));
    on<PostUpload>(_onPostUpload);
    on<PostFetchAllPosts>(_onFetchAllPosts);
  }

  void _onPostUpload(PostUpload event, Emitter<PostState> emit) async {
    final res = await _uploadPost(UploadPostParams(
      title: event.title,
      userId: event.userId,
      content: event.content,
      image: event.image,
      topics: event.topics,
    ));
    res.fold(
        (failure) => emit(PostFailure(
              failure.message,
            )),
        (post) => emit(PostUploadSuccess()));
  }

  void _onFetchAllPosts(
      PostFetchAllPosts event, Emitter<PostState> emit) async {
    // wait 3s
    final res = await _getAllPosts(NoParams());
    res.fold(
        (failure) => emit(PostFailure(
              failure.message,
            )),
        (posts) => emit(PostDisplaySuccess(posts)));
  }
}
