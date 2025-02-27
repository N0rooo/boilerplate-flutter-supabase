import 'dart:async';

import 'package:bloc/bloc.dart';
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

  // final GetChatMessages _getChatMessages;

  List<ChatRoom>? _cachedRooms;

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
  }

  void _onCreateRoom(ChatCreateRoom event, Emitter<ChatState> emit) async {
    emit(ChatCreateRoomLoading());
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
          _cachedRooms = null;
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
        print('failureOrRooms: $failureOrRooms');
        return failureOrRooms.fold(
          (failure) {
            print('failure: $failure');
            return ChatGetRoomsFailure(failure.message);
          },
          (rooms) {
            _cachedRooms = rooms;
            print('rooms: $rooms');
            final allParticipantIds =
                rooms.expand((room) => room.participantIds).toSet().toList();

            print('allParticipantIds: $allParticipantIds');

            return ChatGetRoomsSuccess(rooms);
          },
        );
      },
    );
  }

  Future<void> _loadMissingUsers(List<String> userIds) async {
    print('loadMissingUsers: $userIds');
    _userBloc.add(UserGetInfo(userIds: userIds));
  }
}
