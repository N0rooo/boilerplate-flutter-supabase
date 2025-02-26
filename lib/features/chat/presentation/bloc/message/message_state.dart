part of 'message_bloc.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageGetMessagesLoading extends MessageState {}

final class MessageGetMessagesSuccess extends MessageState {
  final List<Message> messages;
  MessageGetMessagesSuccess(this.messages);
}

final class MessageGetMessagesFailure extends MessageState {
  final String message;
  MessageGetMessagesFailure(this.message);
}

final class MessageSendMessageLoading extends MessageState {
  final List<Message> messages;
  MessageSendMessageLoading(this.messages);
}

final class MessageSendMessageSuccess extends MessageState {
  final Message message;
  MessageSendMessageSuccess(this.message);
}

final class MessageSendMessageFailure extends MessageState {
  final String message;
  MessageSendMessageFailure(this.message);
}
