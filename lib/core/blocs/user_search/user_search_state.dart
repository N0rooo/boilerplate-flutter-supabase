part of 'user_search_bloc.dart';

@immutable
sealed class UserSearchState {}

final class UserSearchInitial extends UserSearchState {}

final class UserSearchLoading extends UserSearchState {}

final class UserSearchSuccess extends UserSearchState {
  final List<User> users;
  UserSearchSuccess(this.users);
}

final class UserSearchEmpty extends UserSearchState {}

final class UserSearchFailure extends UserSearchState {
  final String message;
  UserSearchFailure(this.message);
}
