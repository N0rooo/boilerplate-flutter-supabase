import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/features/chat/data/models/message_model.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/create_chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_messages_stream.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/send_message.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final CreateChatRoom _createChatRoom;
  final GetChatRooms _getChatRooms;

  // final GetChatMessages _getChatMessages;

  List<ChatRoom>? _cachedRooms;

  ChatBloc({
    required CreateChatRoom createChatRoom,
    required GetChatRooms getChatRooms,
  })  : _createChatRoom = createChatRoom,
        _getChatRooms = getChatRooms,
        super(ChatInitial()) {
    on<ChatCreateRoom>(_onCreateRoom);
    on<ChatGetRooms>(_onGetRooms);

    on<ChatGetRoomsRefresh>(_onGetRoomsRefresh);
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
          add(ChatGetRooms(userId: event.participantIds.first));
        }
      },
    );
  }

  void _onGetRooms(ChatGetRooms event, Emitter<ChatState> emit) async {
    if (_cachedRooms != null) {
      emit(ChatGetRoomsSuccess(_cachedRooms!));
      return;
    }
    emit(ChatGetRoomsLoading());
    final res = await _getChatRooms(GetChatRoomsParams(userId: event.userId));
    res.fold(
      (failure) => emit(ChatGetRoomsFailure(failure.message)),
      (rooms) {
        _cachedRooms = rooms;
        emit(ChatGetRoomsSuccess(rooms));
      },
    );
  }

  void _onGetRoomsRefresh(
    ChatGetRoomsRefresh event,
    Emitter<ChatState> emit,
  ) async {
    final currentRooms = _cachedRooms;
    _cachedRooms = null;
    emit(ChatGetRoomsRefreshLoading(currentRooms ?? []));
    //wait 1 second
    await Future.delayed(const Duration(seconds: 1));
    final res = await _getChatRooms(GetChatRoomsParams(userId: event.userId));
    res.fold(
      (failure) => emit(ChatGetRoomsFailure(failure.message)),
      (rooms) {
        _cachedRooms = rooms;
        emit(ChatGetRoomsSuccess(rooms));
      },
    );
  }
}
