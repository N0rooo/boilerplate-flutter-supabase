import 'dart:io';

import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/features/post/domain/entities/post.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class PostRepository {
  Future<Either<Failure, Post>> uploadPost({
    required File image,
    required String userId,
    required String title,
    required String content,
    required List<String> topics,
  });

  Future<Either<Failure, List<Post>>> getAllPosts();
}
