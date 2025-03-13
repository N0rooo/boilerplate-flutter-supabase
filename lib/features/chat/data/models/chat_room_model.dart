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
    print(map);
    return ChatRoomModel(
      id: map['id'],
      name: map['name'] ?? 'Unknown',
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
      viewerId: map['viewer_id'],
      participantIds: List<String>.from(map['participant_ids']),
    );
  }
}
