import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/src/either.dart';

class GetChatRooms
    implements StreamUseCase<List<ChatRoom>, GetChatRoomsParams> {
  final ChatRepository chatRepository;

  GetChatRooms(this.chatRepository);
  @override
  Stream<Either<Failure, List<ChatRoom>>> call(GetChatRoomsParams params) {
    return chatRepository.getChatRooms(params.viewerId);
  }
}

class GetChatRoomsParams {
  final String viewerId;

  GetChatRoomsParams({required this.viewerId});
}
