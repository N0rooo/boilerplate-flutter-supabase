import 'package:boilerplate_flutter/core/common/models/user_model.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';

class ChatRoomModel extends ChatRoom {
  ChatRoomModel({
    required super.id,
    required super.name,
    required super.createdAt,
    required super.updatedAt,
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
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
      participantIds: List<String>.from(map['participant_ids'] ?? []),
      participants: map['participants'] != null
          ? List<UserModel>.from(
              map['participants'].map((x) => UserModel.fromJson(x)))
          : null,
    );
  }
}
