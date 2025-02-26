import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class ChatRepository {
  Future<Either<Failure, Message>> sendMessage(
    String chatRoomId,
    String senderId,
    String content,
  );

  Future<Either<Failure, ChatRoom>> createChatRoom(
    String name,
    List<String> participantIds,
  );

  Future<Either<Failure, List<ChatRoom>>> getChatRooms(String userId);

  Stream<Either<Failure, List<Message>>> getMessagesStream(String chatRoomId);

  Future<Either<Failure, User>> getUserInfo(String userId);
}
