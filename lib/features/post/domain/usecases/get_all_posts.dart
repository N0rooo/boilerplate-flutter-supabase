import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/post/domain/entities/post.dart';
import 'package:boilerplate_flutter/features/post/domain/repositories/post_repository.dart';
import 'package:fpdart/src/either.dart';

class GetAllPosts implements UseCase<List<Post>, NoParams> {
  final PostRepository postRepository;
  GetAllPosts(this.postRepository);
  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) async {
    return await postRepository.getAllPosts();
  }
}
