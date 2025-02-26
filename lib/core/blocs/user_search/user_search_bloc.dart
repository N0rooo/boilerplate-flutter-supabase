import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/usecases/user/search_users.dart';
import 'package:meta/meta.dart';

part 'user_search_event.dart';
part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final SearchUsers _searchUsers;

  UserSearchBloc({required SearchUsers searchUsers})
      : _searchUsers = searchUsers,
        super(UserSearchInitial()) {
    on<UserSearchEvent>((_, emit) => emit(UserSearchLoading()));
    on<SearchUsersByName>(_onSearchUsers);
  }

  void _onSearchUsers(
    SearchUsersByName event,
    Emitter<UserSearchState> emit,
  ) async {
    final result = await _searchUsers(event.query);

    result.fold(
      (failure) => emit(UserSearchFailure(failure.message)),
      (users) => users.isEmpty
          ? emit(UserSearchEmpty())
          : emit(UserSearchSuccess(users)),
    );
  }
}
