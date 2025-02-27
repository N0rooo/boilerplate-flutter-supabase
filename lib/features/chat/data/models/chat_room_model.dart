import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/common/models/user_model.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  ChatRoomModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
    required super.viewerId,
    required super.participantIds,
    super.participants,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory ChatRoomModel.fromJson(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'],
      name: map['name'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      viewerId: map['viewer_id'],
      participantIds: List<String>.from(map['participant_ids']),
    );
  }
  ChatRoomModel copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? viewerId,
    List<String>? participantsIds,
    List<User>? participants,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      viewerId: viewerId ?? this.viewerId,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
    );
  }
}
