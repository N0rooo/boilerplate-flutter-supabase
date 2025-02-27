import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/error/exceptions.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource chatRemoteDataSource;

  ChatRepositoryImpl(this.chatRemoteDataSource);

  @override
  Future<Either<Failure, ChatRoom>> createChatRoom(
      String name, List<String> participantIds) async {
    try {
      final result =
          await chatRemoteDataSource.createChatRoom(name, participantIds);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, List<ChatRoom>>> getChatRooms(String viewerId) {
    try {
      final result = chatRemoteDataSource.getChatRoomsStream(viewerId);
      return result.map((rooms) => right(rooms));
    } on ServerException catch (e) {
      return Stream.value(left(Failure(e.message)));
    } catch (e) {
      return Stream.value(left(Failure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, Message>> sendMessage(
      String chatRoomId, String senderId, String content) async {
    try {
      final result =
          await chatRemoteDataSource.sendMessage(chatRoomId, senderId, content);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Stream<Either<Failure, List<Message>>> getMessagesStream(String chatRoomId) {
    try {
      final messagesStream = chatRemoteDataSource.getMessages(chatRoomId);
      return messagesStream.map((messages) => right(messages));
    } on ServerException catch (e) {
      return Stream.value(left(Failure(e.message)));
    } catch (e) {
      return Stream.value(left(Failure(e.toString())));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsersInfo(List<String> userIds) async {
    try {
      final result = await chatRemoteDataSource.getUsersInfo(userIds);
      return right(result);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
