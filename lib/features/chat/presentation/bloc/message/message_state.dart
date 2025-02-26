part of 'message_bloc.dart';

@immutable
sealed class MessageState {}

final class MessageInitial extends MessageState {}

final class MessageGetMessagesLoading extends MessageState {}

final class MessageGetMessagesSuccess extends MessageState {
  final List<Message> messages;
  final Map<String, User> users;

  MessageGetMessagesSuccess(this.messages, this.users);
}

final class MessageGetMessagesFailure extends MessageState {
  final String message;

  MessageGetMessagesFailure(this.message);
}

final class MessageSendMessageLoading extends MessageState {
  final List<Message> messages;
  final Map<String, User> users;

  MessageSendMessageLoading(this.messages, this.users);
}

final class MessageSendMessageSuccess extends MessageState {
  final List<Message> messages;
  final Map<String, User> users;

  MessageSendMessageSuccess(this.messages, this.users);
}

final class MessageSendMessageFailure extends MessageState {
  final String message;

  MessageSendMessageFailure(this.message);
}
