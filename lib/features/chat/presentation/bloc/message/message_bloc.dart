import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_messages_stream.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/send_message.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta/meta.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesStream _getMessagesStream;
  final SendMessage _sendMessage;
  StreamSubscription<Either<Failure, List<Message>>>? _messagesSubscription;

  MessageBloc({
    required GetMessagesStream getMessagesStream,
    required SendMessage sendMessage,
  })  : _getMessagesStream = getMessagesStream,
        _sendMessage = sendMessage,
        super(MessageInitial()) {
    on<MessageGetMessages>(_onGetMessages);
    on<MessageMessagesUpdated>(_onMessagesUpdated);
    on<MessageError>(_onMessageError);
    on<MessageSendMessage>(_onSendMessage);
  }

  void _onGetMessages(MessageGetMessages event, Emitter<MessageState> emit) {
    emit(MessageGetMessagesLoading());

    _messagesSubscription?.cancel();

    _messagesSubscription = _getMessagesStream(
      GetMessagesStreamParams(chatRoomId: event.chatRoomId),
    ).listen(
      (failureOrMessages) => failureOrMessages.fold(
        (failure) => add(MessageError(failure.message)),
        (messages) => add(MessageMessagesUpdated(messages)),
      ),
    );
  }

  void _onMessagesUpdated(
    MessageMessagesUpdated event,
    Emitter<MessageState> emit,
  ) {
    emit(MessageGetMessagesSuccess(event.messages));
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
    emit(MessageSendMessageLoading(updatedMessages));
    //wait 2 seconds

    final res = await _sendMessage(SendMessageParams(
      chatRoomId: event.chatRoomId,
      senderId: event.senderId,
      content: event.content,
    ));
    res.fold(
      (failure) => emit(MessageSendMessageFailure(failure.message)),
      (message) => emit(MessageSendMessageSuccess(message)),
    );
  }

  @override
  Future<void> close() {
    _messagesSubscription?.cancel();
    return super.close();
  }
}
