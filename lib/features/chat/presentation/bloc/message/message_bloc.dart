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

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesStream _getMessagesStream;
  final SendMessage _sendMessage;
  final GetUsersInfo _getUsersInfo;
  StreamSubscription<Either<Failure, List<Message>>>? _messagesSubscription;

  final Map<String, User> _usersCache = {};

  List<Message>? _pendingMessages;

  MessageBloc({
    required GetMessagesStream getMessagesStream,
    required SendMessage sendMessage,
    required GetUsersInfo getUsersInfo,
  })  : _getMessagesStream = getMessagesStream,
        _sendMessage = sendMessage,
        _getUsersInfo = getUsersInfo,
        super(MessageInitial()) {
    on<MessageGetMessages>(_onGetMessages);
    on<MessageSendMessage>(_onSendMessage);
    on<MessageLoadUserInfo>(_onLoadUserInfo);
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
                .where((message) => !_usersCache.containsKey(message.senderId))
                .map((message) => message.senderId)
                .toSet()
                .toList();

            if (missingUserIds.isEmpty) {
              return MessageGetMessagesSuccess(messages, _usersCache);
            } else {
              // Still need to load user info, but we'll do it through events
              for (final userId in missingUserIds) {
                add(MessageLoadUserInfo(userId: userId));
              }
              _pendingMessages = messages;
              // Return loading state while we wait for user info
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
    emit(MessageSendMessageLoading(updatedMessages, _usersCache));
    await Future.delayed(const Duration(milliseconds: 500));

    final res = await _sendMessage(SendMessageParams(
      chatRoomId: event.chatRoomId,
      senderId: event.senderId,
      content: event.content,
    ));
    res.fold(
      (failure) => emit(MessageSendMessageFailure(failure.message)),
      (message) =>
          emit(MessageSendMessageSuccess(updatedMessages, _usersCache)),
    );
  }

  Future<void> _onLoadUserInfo(
    MessageLoadUserInfo event,
    Emitter<MessageState> emit,
  ) async {
    final result =
        await _getUsersInfo(GetUsersInfoParams(userIds: [event.userId]));

    result.fold(
      (failure) {},
      (user) {
        if (_pendingMessages != null) {
          final allUsersLoaded = _pendingMessages!
              .every((message) => _usersCache.containsKey(message.senderId));

          if (allUsersLoaded) {
            add(MessageMessagesUpdated(_pendingMessages!));
            _pendingMessages = null;
          }
        } else if (state is MessageGetMessagesSuccess) {
          final currentState = state as MessageGetMessagesSuccess;
          emit(MessageGetMessagesSuccess(currentState.messages, _usersCache));
        }
      },
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
