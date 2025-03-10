import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_users_info.dart';
import 'package:meta/meta.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUsersInfo _getUsersInfo;
  final Map<String, User> _usersCache = {};

  Map<String, User> get usersCache => Map.unmodifiable(_usersCache);
  bool hasUser(String userId) => _usersCache.containsKey(userId);
  User? getUser(String userId) => _usersCache[userId];

  UserBloc({
    required GetUsersInfo getUsersInfo,
  })  : _getUsersInfo = getUsersInfo,
        super(UserInitial()) {
    on<UserGetInfo>(_onGetUserInfo);
  }

  void _onGetUserInfo(UserGetInfo event, Emitter<UserState> emit) async {
    emit(UserGetInfoLoading());
    final missingUserIds = event.userIds
        .where((userId) => !_usersCache.containsKey(userId))
        .toList();

    if (missingUserIds.isEmpty) {
      final userList = _usersCache.values.toList();
      emit(UserGetInfoSuccess(userList));
      return;
    }

    final result = await _getUsersInfo(
      GetUsersInfoParams(userIds: missingUserIds),
    );
    result.fold(
      (failure) {
        emit(UserGetInfoFailure(failure.message));
      },
      (users) {
        _usersCache.addAll({for (var user in users) user.id: user});
        final userList = _usersCache.values.toList();
        emit(UserGetInfoSuccess(userList));
      },
    );
  }
}
