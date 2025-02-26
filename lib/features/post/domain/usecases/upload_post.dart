// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/post/domain/entities/post.dart';
import 'package:boilerplate_flutter/features/post/domain/repositories/post_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadPost implements UseCase<Post, UploadPostParams> {
  final PostRepository postRepository;
  UploadPost(this.postRepository);

  @override
  Future<Either<Failure, Post>> call(UploadPostParams params) async {
    return await postRepository.uploadPost(
        image: params.image,
        userId: params.userId,
        title: params.title,
        content: params.content,
        topics: params.topics);
  }
}

class UploadPostParams {
  final String title;
  final String userId;
  final String content;
  final File image;
  final List<String> topics;

  UploadPostParams({
    required this.title,
    required this.userId,
    required this.content,
    required this.image,
    required this.topics,
  });
}
