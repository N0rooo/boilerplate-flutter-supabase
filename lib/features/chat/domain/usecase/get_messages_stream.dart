import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetMessagesStream
    implements StreamUseCase<List<Message>, GetMessagesStreamParams> {
  final ChatRepository chatRepository;

  GetMessagesStream(this.chatRepository);

  @override
  Stream<Either<Failure, List<Message>>> call(GetMessagesStreamParams params) {
    return chatRepository.getMessagesStream(params.chatRoomId);
  }
}

class GetMessagesStreamParams {
  final String chatRoomId;

  GetMessagesStreamParams({required this.chatRoomId});
}
