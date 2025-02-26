import 'package:boilerplate_flutter/core/common/models/user_model.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.content,
    required super.senderId,
    required super.chatRoomId,
    required super.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'chat_room_id': chatRoomId,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      content: json['content'],
      senderId: json['sender_id'],
      chatRoomId: json['chat_room_id'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
