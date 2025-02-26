import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/src/either.dart';

class GetChatRooms implements UseCase<List<ChatRoom>, GetChatRoomsParams> {
  final ChatRepository chatRepository;

  GetChatRooms(this.chatRepository);
  @override
  Future<Either<Failure, List<ChatRoom>>> call(
      GetChatRoomsParams params) async {
    return chatRepository.getChatRooms(params.userId);
  }
}

class GetChatRoomsParams {
  final String userId;

  GetChatRoomsParams({required this.userId});
}
