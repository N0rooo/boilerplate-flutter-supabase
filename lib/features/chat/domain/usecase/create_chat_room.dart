// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';

class CreateChatRoom implements UseCase<ChatRoom, CreateChatRoomParams> {
  final ChatRepository chatRepository;

  CreateChatRoom(this.chatRepository);

  @override
  Future<Either<Failure, ChatRoom>> call(CreateChatRoomParams params) async {
    return await chatRepository.createChatRoom(
        params.name, params.participantIds);
  }
}

class CreateChatRoomParams {
  final String name;
  final List<String> participantIds;

  CreateChatRoomParams({
    required this.name,
    required this.participantIds,
  });
}
