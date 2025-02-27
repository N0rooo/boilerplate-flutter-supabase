part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserGetInfoLoading extends UserState {}

final class UserGetInfoSuccess extends UserState {
  final List<User> users;

  UserGetInfoSuccess(this.users);
}

final class UserGetInfoFailure extends UserState {
  final String message;

  UserGetInfoFailure(this.message);
}
