import 'package:boilerplate_flutter/core/common/models/user_model.dart';
import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:boilerplate_flutter/core/error/exceptions.dart';
import 'package:boilerplate_flutter/features/chat/data/models/chat_room_model.dart';
import 'package:boilerplate_flutter/features/chat/data/models/message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

abstract interface class ChatRemoteDataSource {
  Future<MessageModel> sendMessage(
    String chatRoomId,
    String senderId,
    String content,
  );

  Future<ChatRoomModel> createChatRoom(
    String name,
    List<String> participantIds,
  );

  // Future<List<ChatRoomModel>> getChatRooms(String userId);

  Stream<List<MessageModel>> getMessages(String chatRoomId);

  Stream<List<ChatRoomModel>> getChatRoomsStream(String userId);

  Future<List<UserModel>> getUsersInfo(List<String> userIds);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final SupabaseClient supabaseClient;
  ChatRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<MessageModel> sendMessage(
      String chatRoomId, String senderId, String content) async {
    try {
      final message = MessageModel(
        id: const Uuid().v4(),
        content: content,
        senderId: senderId,
        chatRoomId: chatRoomId,
        createdAt: DateTime.now(),
      );

      final messageData = await supabaseClient
          .from(SupabaseTables.messages)
          .insert(message.toJson())
          .select();
      return MessageModel.fromJson(messageData.first);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<ChatRoomModel> createChatRoom(
    String name,
    List<String> participantIds,
  ) async {
    try {
      final roomData = await supabaseClient.rpc('create_chat_room', params: {
        'room_name': name,
        'participant_ids': participantIds,
      }).single();

      final chatRoom = ChatRoomModel.fromJson(roomData);

      return chatRoom;
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // @override
  // Future<List<ChatRoomModel>> getChatRooms(String userId) async {
  //   try {
  //     final rooms = await supabaseClient
  //         .from(SupabaseTables.chatRooms)
  //         .select('''
  //         *,
  //         chat_participants!inner(user_id),
  //         participants:chat_participants(
  //           profiles(*)
  //         )
  //       ''')
  //         .eq('chat_participants.user_id', userId)
  //         .order('updated_at', ascending: false);

  //     return rooms.map((room) {
  //       final participants = (room['participants'] as List)
  //           .map((participant) => UserModel.fromJson(participant['profiles']))
  //           .toList();

  //       final participantIds = (room['chat_participants'] as List)
  //           .map((p) => p['user_id'].toString())
  //           .toList();

  //       return ChatRoomModel(
  //         id: room['id'],
  //         name: room['name'],
  //         createdAt: DateTime.parse(room['created_at']),
  //         updatedAt: DateTime.parse(room['updated_at']),
  //         participantIds: participantIds,
  //         participants: participants,
  //       );
  //     }).toList();
  //   } on PostgrestException catch (e) {
  //     throw ServerException(e.message);
  //   } catch (e) {
  //     throw ServerException(e.toString());
  //   }
  // }

  @override
  Stream<List<ChatRoomModel>> getChatRoomsStream(String viewerId) {
    try {
      return supabaseClient
          .from(SupabaseViews.userChatRooms)
          .stream(primaryKey: ['id'])
          .eq('viewer_id', viewerId)
          .map((rooms) =>
              rooms.map((room) => ChatRoomModel.fromJson(room)).toList());
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<MessageModel>> getMessages(String chatRoomId) {
    try {
      return supabaseClient
          .from(SupabaseTables.messages)
          .stream(primaryKey: ['id'])
          .eq('chat_room_id', chatRoomId)
          .order('created_at', ascending: false)
          .map((messages) => messages
              .map((message) => MessageModel.fromJson(message))
              .toList());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<UserModel>> getUsersInfo(List<String> userIds) async {
    try {
      final userData = await supabaseClient
          .from(SupabaseTables.profiles)
          .select()
          .inFilter('id', userIds);

      return userData.map((user) => UserModel.fromJson(user)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
