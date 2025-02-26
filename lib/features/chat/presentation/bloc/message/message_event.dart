part of 'message_bloc.dart';

@immutable
sealed class MessageEvent {}

final class MessageGetMessages extends MessageEvent {
  final String chatRoomId;

  MessageGetMessages({required this.chatRoomId});
}

final class MessageMessagesUpdated extends MessageEvent {
  final List<Message> messages;

  MessageMessagesUpdated(this.messages);
}

final class MessageError extends MessageEvent {
  final String message;

  MessageError(this.message);
}

final class MessageSendMessage extends MessageEvent {
  final String chatRoomId;
  final String senderId;
  final String content;
  final Message tempMessage;

  MessageSendMessage({
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.tempMessage,
  });
}

final class MessageLoadUserInfo extends MessageEvent {
  final String userId;

  MessageLoadUserInfo({required this.userId});
}
