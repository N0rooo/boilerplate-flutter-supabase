part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

class UserGetInfo extends UserEvent {
  final List<String> userIds;

  UserGetInfo({required this.userIds});
}
