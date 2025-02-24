part of 'post_bloc.dart';

@immutable
sealed class PostEvent {}

final class PostUpload extends PostEvent {
  final String title;
  final String userId;
  final String content;
  final File image;
  final List<String> topics;

  PostUpload({
    required this.title,
    required this.userId,
    required this.content,
    required this.image,
    required this.topics,
  });
}

final class PostFetchAllPosts extends PostEvent {}
