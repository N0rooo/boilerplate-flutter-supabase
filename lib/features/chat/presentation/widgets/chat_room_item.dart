import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:flutter/material.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatRoom chatRoom;
  final List<String> participantsNames;
  final void Function(ChatRoom) onTap;
  const ChatRoomItem({
    super.key,
    required this.chatRoom,
    required this.participantsNames,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        chatRoom.name.isEmpty ? participantsNames.join(', ') : chatRoom.name,
      ),
      onTap: () => onTap(chatRoom),
    );
  }
}
