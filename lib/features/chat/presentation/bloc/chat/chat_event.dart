part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {}



class ChatCreateRoom extends ChatEvent {
  final String name;
  final List<String> participantIds;

  ChatCreateRoom({
    required this.name,
    required this.participantIds,
  });
}

class ChatGetRooms extends ChatEvent {
  final String userId;
  ChatGetRooms({required this.userId});
}

class ChatGetRoomsRefresh extends ChatEvent {
  final String userId;
  ChatGetRoomsRefresh({required this.userId});
}

