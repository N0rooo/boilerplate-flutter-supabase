import 'package:boilerplate_flutter/core/common/entities/user.dart';

class Message {
  final String id;
  final String content;
  final String senderId;
  final String chatRoomId;
  final DateTime createdAt;
  final List<String>? readBy;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.chatRoomId,
    required this.createdAt,
    this.readBy,
  });
}
