part of 'post_bloc.dart';

@immutable
sealed class PostState {}

final class PostInitial extends PostState {}

final class PostLoading extends PostState {}

final class PostFailure extends PostState {
  final String error;
  PostFailure(this.error);
}

final class PostDisplaySuccess extends PostState {
  final List<Post> posts;
  PostDisplaySuccess(this.posts);
}

final class PostUploadSuccess extends PostState {}
