part of 'chat_bloc.dart';

@immutable
sealed class ChatState {}

final class ChatInitial extends ChatState {}

// Message states

// Room states
final class ChatCreateRoomLoading extends ChatState {}

final class ChatCreateRoomSuccess extends ChatState {
  final ChatRoom room;
  ChatCreateRoomSuccess(this.room);
}

final class ChatCreateRoomFailure extends ChatState {
  final String message;
  ChatCreateRoomFailure(this.message);
}

// Get rooms states
final class ChatGetRoomsLoading extends ChatState {}

final class ChatGetRoomsRefreshLoading extends ChatState {
  final List<ChatRoom> rooms;
  ChatGetRoomsRefreshLoading(this.rooms);
}

final class ChatGetRoomsSuccess extends ChatState {
  final List<ChatRoom> rooms;
  ChatGetRoomsSuccess(this.rooms);
}

final class ChatGetRoomsFailure extends ChatState {
  final String message;
  ChatGetRoomsFailure(this.message);
}

// Get messages states

