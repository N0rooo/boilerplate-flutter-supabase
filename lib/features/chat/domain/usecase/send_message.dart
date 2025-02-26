// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:fpdart/src/either.dart';

class SendMessage implements UseCase<Message, SendMessageParams> {
  final ChatRepository chatRepository;

  SendMessage(this.chatRepository);

  @override
  Future<Either<Failure, Message>> call(SendMessageParams params) async {
    return await chatRepository.sendMessage(
      params.chatRoomId,
      params.senderId,
      params.content,
    );
  }
}

class SendMessageParams {
  final String chatRoomId;
  final String senderId;
  final String content;

  SendMessageParams({
    required this.chatRoomId,
    required this.senderId,
    required this.content,
  });
}
