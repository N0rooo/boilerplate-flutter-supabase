import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_messages_stream.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_users_info.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/send_message.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/user/user_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesStream _getMessagesStream;
  final SendMessage _sendMessage;
  final GetUsersInfo _getUsersInfo;
  final UserBloc _userBloc;
  StreamSubscription<Either<Failure, List<Message>>>? _messagesSubscription;
  StreamSubscription<UserState>? _userStateSubscription;

  List<Message>? _pendingMessages;

  MessageBloc({
    required GetMessagesStream getMessagesStream,
    required SendMessage sendMessage,
    required GetUsersInfo getUsersInfo,
    required UserBloc userBloc,
  })  : _getMessagesStream = getMessagesStream,
        _sendMessage = sendMessage,
        _getUsersInfo = getUsersInfo,
        _userBloc = userBloc,
        super(MessageInitial()) {
    on<MessageGetMessages>(_onGetMessages);
    on<MessageSendMessage>(_onSendMessage);
    on<MessageMessagesUpdated>(_onMessagesUpdated);

    _userStateSubscription = _userBloc.stream.listen((userState) {
      if (userState is UserGetInfoSuccess && _pendingMessages != null) {
        final allUsersLoaded = _pendingMessages!
            .every((message) => _userBloc.hasUser(message.senderId));

        if (allUsersLoaded) {
          add(MessageMessagesUpdated(_pendingMessages!));
          _pendingMessages = null;
        }
      }
    });
  }

  void _onMessagesUpdated(
    MessageMessagesUpdated event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageGetMessagesSuccess(event.messages, _userBloc.usersCache));
  }

  Future<void> _onGetMessages(
      MessageGetMessages event, Emitter<MessageState> emit) async {
    emit(MessageGetMessagesLoading());

    _messagesSubscription?.cancel();

    await emit.forEach(
      _getMessagesStream(GetMessagesStreamParams(chatRoomId: event.chatRoomId)),
      onData: (Either<Failure, List<Message>> failureOrMessages) {
        return failureOrMessages.fold(
          (failure) => MessageGetMessagesFailure(failure.message),
          (messages) {
            final List<String> missingUserIds = messages
                .where((message) => !_userBloc.hasUser(message.senderId))
                .map((message) => message.senderId)
                .toSet()
                .toList();

            if (missingUserIds.isEmpty) {
              return MessageGetMessagesSuccess(
                messages,
                _userBloc.usersCache,
              );
            } else {
              _pendingMessages = messages;
              _userBloc.add(UserGetInfo(userIds: missingUserIds));
              return MessageGetMessagesLoading();
            }
          },
        );
      },
    );
  }

  void _onSendMessage(
    MessageSendMessage event,
    Emitter<MessageState> emit,
  ) async {
    final currentMessages = state is MessageGetMessagesSuccess
        ? (state as MessageGetMessagesSuccess).messages
        : [];

    final List<Message> updatedMessages = [
      event.tempMessage,
      ...currentMessages
    ];
    emit(MessageSendMessageLoading(updatedMessages, _userBloc.usersCache));
    await Future.delayed(const Duration(milliseconds: 500));

    final res = await _sendMessage(SendMessageParams(
      chatRoomId: event.chatRoomId,
      senderId: event.senderId,
      content: event.content,
    ));
    res.fold(
      (failure) => emit(MessageSendMessageFailure(failure.message)),
      (message) => emit(
          MessageSendMessageSuccess(updatedMessages, _userBloc.usersCache)),
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    _userStateSubscription?.cancel();
    return super.close();
  }
}
