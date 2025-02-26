part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}

class MessageGetMessages extends MessageEvent {
  final String chatRoomId;
  MessageGetMessages({required this.chatRoomId});
}

class MessageMessagesUpdated extends MessageEvent {
  final List<Message> messages;
  MessageMessagesUpdated(this.messages);
}

class MessageError extends MessageEvent {
  final String message;
  MessageError(this.message);
}

class MessageSendMessage extends MessageEvent {
  final String senderId;
  final String chatRoomId;
  final String content;
  final Message tempMessage;
  MessageSendMessage({
    required this.senderId,
    required this.chatRoomId,
    required this.content,
    required this.tempMessage,
  });
}
