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

    final chatRoomName = widget.chatRoom.name.isEmpty
        ? widget.chatRoom.participants
            ?.map((e) => e.name)
            .where((name) => name != currentUser.name)
            .toList()
            .join(', ')
        : widget.chatRoom.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(chatRoomName ?? ''),
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
                        ? state.messages
                        : (state is MessageSendMessageLoading
                            ? state.messages
                            : []));

                final users = state is MessageGetMessagesSuccess
                    ? state.users
                    : (state is MessageSendMessageSuccess
                        ? state.users
                        : (state is MessageSendMessageLoading
                            ? state.users
                            : {}));

                if (messages.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet',
                    ),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = message.senderId == currentUser.id;
                    final isPending =
                        state is MessageSendMessageLoading && index == 0;
                    return Opacity(
                      opacity: isPending ? 0.5 : 1.0,
                      child: ChatMessageBuble(
                        user: users[message.senderId],
                        message: message.content,
                        isCurrentUser: isCurrentUser,
                        showUserName:
                            (widget.chatRoom.participants?.length ?? 0) > 2,
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
