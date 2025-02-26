import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/message.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/message/message_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/widgets/chat_message_buble.dart';
import 'package:boilerplate_flutter/features/chat/presentation/widgets/chat_message_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoomPage extends StatefulWidget {
  static route(ChatRoom chatRoom) => MaterialPageRoute(
        builder: (context) => ChatRoomPage(chatRoom: chatRoom),
      );
  final ChatRoom chatRoom;
  const ChatRoomPage({super.key, required this.chatRoom});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final messageController = TextEditingController();

  String get _participantNamesWithoutCurrentUser =>
      widget.chatRoom.participants
          ?.where((e) => e.id != widget.chatRoom.participantIds.first)
          .map((e) => e.name)
          .join(', ') ??
      '';

  String get _chatTitle => widget.chatRoom.name.isEmpty
      ? _participantNamesWithoutCurrentUser
      : widget.chatRoom.name;

  @override
  void initState() {
    super.initState();
    _getMessages();
  }

  void _sendMessage() {
    final currentUser =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    final tempMessage = Message(
      id: DateTime.now().toString(),
      chatRoomId: widget.chatRoom.id,
      senderId: currentUser.id,
      content: messageController.text,
      createdAt: DateTime.now(),
    );
    context.read<MessageBloc>().add(MessageSendMessage(
          senderId: currentUser.id,
          chatRoomId: widget.chatRoom.id,
          content: messageController.text,
          tempMessage: tempMessage,
        ));

    messageController.clear();
  }

  void _getMessages() {
    context.read<MessageBloc>().add(
          MessageGetMessages(chatRoomId: widget.chatRoom.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user;

    return Scaffold(
      appBar: AppBar(
        title: Text(_chatTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<MessageBloc, MessageState>(
              listener: (context, state) {
                if (state is MessageSendMessageFailure) {
                  showSnackBar(context, state.message);
                }
              },
              builder: (context, state) {
                print(state);
                if (state is MessageGetMessagesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is MessageGetMessagesFailure) {
                  return Center(
                    child: Text(state.message),
                  );
                }

                final messages = state is MessageGetMessagesSuccess
                    ? state.messages
                    : (state is MessageSendMessageSuccess
                        ? [state.message]
                        : (state is MessageSendMessageLoading
                            ? state.messages
                            : []));

                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet'),
                  );
                }

                return ListView.builder(
                  reverse: true, // Show latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message.senderId == currentUser.id;
                    final isPending =
                        state is MessageSendMessageLoading && index == 0;

                    return Opacity(
                      opacity: isPending ? 0.5 : 1.0,
                      child: Container(
                        child: ChatMessageBuble(
                          message: message.content,
                          isCurrentUser: isCurrentUser,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          ChatMessageInput(
            controller: messageController,
            onSend: _sendMessage,
          ),
        ],
      ),
    );
  }
}
