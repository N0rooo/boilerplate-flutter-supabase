import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/create_chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_chat_room.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/user/user_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CreateChatRoom _createChatRoom;
  final GetChatRooms _getChatRooms;
  final UserBloc _userBloc;
  StreamSubscription<Either<Failure, List<ChatRoom>>>? _chatRoomsSubscription;
  StreamSubscription<UserState>? _userStateSubscription;

  List<ChatRoom>? _pendingRooms;

  ChatBloc({
    required CreateChatRoom createChatRoom,
    required GetChatRooms getChatRooms,
    required UserBloc userBloc,
  })  : _createChatRoom = createChatRoom,
        _getChatRooms = getChatRooms,
        _userBloc = userBloc,
        super(ChatInitial()) {
    on<ChatCreateRoom>(_onCreateRoom);
    on<ChatGetRooms>(_onGetRooms);
    on<ChatRoomsUpdated>(_onRoomsUpdated);

    _userStateSubscription = _userBloc.stream.listen((userState) {
      if (userState is UserGetInfoSuccess && _pendingRooms != null) {
        final allUsersLoaded = _pendingRooms!
            .expand((room) => room.participantIds)
            .every((userId) => _userBloc.hasUser(userId));

        if (allUsersLoaded) {
          final updatedRooms = _pendingRooms!.map((room) {
            final participants = room.participantIds
                .map((id) => _userBloc.getUser(id))
                .whereType<User>()
                .toList();
            return room.withParticipants(participants);
          }).toList();

          add(ChatRoomsUpdated(updatedRooms));
          _pendingRooms = null;
        }
      }
    });
  }

  void _onRoomsUpdated(ChatRoomsUpdated event, Emitter<ChatState> emit) {
    emit(ChatGetRoomsSuccess(event.rooms));
  }

  void _onCreateRoom(ChatCreateRoom event, Emitter<ChatState> emit) async {
    emit(ChatCreateRoomLoading());

    print(event.participantIds);
    final res = await _createChatRoom(CreateChatRoomParams(
      name: event.name,
      participantIds: event.participantIds,
    ));

    await res.fold(
      (failure) async {
        emit(ChatCreateRoomFailure(failure.message));
      },
      (room) async {
        emit(ChatCreateRoomSuccess(room));

        if (!emit.isDone) {
          _pendingRooms = null;
          add(ChatGetRooms(viewerId: event.participantIds.first));
        }
      },
    );
  }

  Future<void> _onGetRooms(ChatGetRooms event, Emitter<ChatState> emit) async {
    emit(ChatGetRoomsLoading());

    _chatRoomsSubscription?.cancel();

    await emit.forEach(
      _getChatRooms(GetChatRoomsParams(viewerId: event.viewerId)),
      onData: (Either<Failure, List<ChatRoom>> failureOrRooms) {
        return failureOrRooms.fold(
          (failure) => ChatGetRoomsFailure(failure.message),
          (rooms) {
            final allParticipantIds =
                rooms.expand((room) => room.participantIds).toSet().toList();

            final missingUserIds = allParticipantIds
                .where((userId) => !_userBloc.hasUser(userId))
                .toList();

            if (missingUserIds.isEmpty) {
              final updatedRooms = rooms.map((room) {
                final participants = room.participantIds
                    .map((id) => _userBloc.getUser(id))
                    .whereType<User>()
                    .toList();
                return room.withParticipants(participants);
              }).toList();
              return ChatGetRoomsSuccess(updatedRooms);
            } else {
              _pendingRooms = rooms;
              _userBloc.add(UserGetInfo(userIds: missingUserIds));
              return ChatGetRoomsLoading();
            }
          },
        );
      },
    );
  }

  @override
  Future<void> close() {
    _chatRoomsSubscription?.cancel();
    _userStateSubscription?.cancel();
    return super.close();
  }
}
