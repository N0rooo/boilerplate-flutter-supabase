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

  ChatRoom copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? viewerId,
    List<String>? participantIds,
    List<User>? participants,
  }) {
    return ChatRoom(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewerId: viewerId ?? this.viewerId,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
    );
  }

  ChatRoom withParticipants(List<User> newParticipants) {
    return copyWith(participants: newParticipants);
  }
}
