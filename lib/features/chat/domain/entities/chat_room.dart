import 'package:boilerplate_flutter/core/common/entities/user.dart';

class ChatRoom {
  final String id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String viewerId;
  final List<String> participantIds;
  final List<User>? participants;

  ChatRoom({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.viewerId,
    required this.participantIds,
    this.participants,
  });
}
