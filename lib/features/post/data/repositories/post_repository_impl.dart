import 'dart:io';

import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:boilerplate_flutter/core/error/exceptions.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/network/connection_checker.dart';
import 'package:boilerplate_flutter/features/post/data/datasources/post_local_data_source.dart';
import 'package:boilerplate_flutter/features/post/data/datasources/post_remote_data_source.dart';
import 'package:boilerplate_flutter/features/post/data/models/post_model.dart';
import 'package:boilerplate_flutter/features/post/domain/entities/post.dart';
import 'package:boilerplate_flutter/features/post/domain/repositories/post_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource postRemoteDataSource;
  final PostLocalDataSource postLocalDataSource;
  final ConnectionChecker connectionChecker;
  PostRepositoryImpl(this.postRemoteDataSource, this.postLocalDataSource,
      this.connectionChecker);
  @override
  Future<Either<Failure, Post>> uploadPost({
    required File image,
    required String userId,
    required String title,
    required String content,
    required List<String> topics,
  }) async {
    try {
      if (!await connectionChecker.isConnected) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      PostModel postModel = PostModel(
        id: const Uuid().v1(),
        userId: userId,
        title: title,
        content: content,
        topics: topics,
        imageUrl: '',
        updatedAt: DateTime.now(),
      );

      final imageUrl = await postRemoteDataSource.uploadPostImage(
        image: image,
        post: postModel,
      );

      postModel = postModel.copyWith(
        imageUrl: imageUrl,
      );

      final uploadedPost = await postRemoteDataSource.uploadPost(postModel);
      return right(uploadedPost);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    try {
      if (!await connectionChecker.isConnected) {
        final posts = postLocalDataSource.loadPosts();
        return right(posts);
      }
      final posts = await postRemoteDataSource.getAllPosts();
      postLocalDataSource.uploadLocalPosts(posts: posts);
      return right(posts);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
