part of 'user_search_bloc.dart';

@immutable
sealed class UserSearchEvent {}

final class SearchUsersByName extends UserSearchEvent {
  final String query;
  SearchUsersByName(this.query);
}
