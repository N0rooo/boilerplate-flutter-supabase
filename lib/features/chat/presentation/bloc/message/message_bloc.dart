import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_messages_stream.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_user_info.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/send_message.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesStream _getMessagesStream;
  final SendMessage _sendMessage;
  final GetUserInfo _getUserInfo;
  StreamSubscription<Either<Failure, List<Message>>>? _messagesSubscription;

  final Map<String, User> _usersCache = {};

  MessageBloc({
    required GetMessagesStream getMessagesStream,
    required SendMessage sendMessage,
    required GetUserInfo getUserInfo,
  })  : _getMessagesStream = getMessagesStream,
        _sendMessage = sendMessage,
        _getUserInfo = getUserInfo,
        super(MessageInitial()) {
    on<MessageGetMessages>(_onGetMessages);
    on<MessageMessagesUpdated>(_onMessagesUpdated);
    on<MessageError>(_onMessageError);
    on<MessageSendMessage>(_onSendMessage);
    on<MessageLoadUserInfo>(_onLoadUserInfo);
  }

  void _onGetMessages(MessageGetMessages event, Emitter<MessageState> emit) {
    emit(MessageGetMessagesLoading());

    _messagesSubscription?.cancel();

    _messagesSubscription = _getMessagesStream(
      GetMessagesStreamParams(chatRoomId: event.chatRoomId),
    ).listen(
      (failureOrMessages) => failureOrMessages.fold(
        (failure) => add(MessageError(failure.message)),
        (messages) {
          for (final message in messages) {
            if (!_usersCache.containsKey(message.senderId)) {
              add(MessageLoadUserInfo(userId: message.senderId));
            }
          }
          add(MessageMessagesUpdated(messages));
        },
      ),
    );
  }

  void _onMessagesUpdated(
    MessageMessagesUpdated event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageGetMessagesSuccess(event.messages, _usersCache));
  }

  void _onMessageError(
    MessageError event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageGetMessagesFailure(event.message));
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
    final result = await _getUserInfo(GetUserInfoParams(userId: event.userId));

    result.fold(
      (failure) {
        print('Error loading user info: ${failure.message}');
      },
      (user) {
        _usersCache[event.userId] = user;
        if (state is MessageGetMessagesSuccess) {
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
