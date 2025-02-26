import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/common/widgets/loader.dart';
import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:boilerplate_flutter/features/chat/domain/entities/chat_room.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/pages/chat_room_page.dart';
import 'package:boilerplate_flutter/features/chat/presentation/pages/create_chat_room_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  void _fetchChats() {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    if (context.read<ChatBloc>().state is! ChatGetRoomsSuccess) {
      context.read<ChatBloc>().add(ChatGetRooms(userId: userId));
    }
  }

  Future<void> _refreshChats() async {
    final userId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<ChatBloc>().add(ChatGetRoomsRefresh(userId: userId));
  }

  // Future<void> _refreshChats() async {
  //   final userId =
  //       (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
  //   if (context.read<ChatBloc>().state is! ChatGetRoomsSuccess) {
  //     context.read<ChatBloc>().add(ChatGetRooms(userId: userId));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
        actions: [
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                CreateChatRoomPage.route(),
              );
            },
            icon: const Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatGetRoomsFailure) {
            showSnackBar(context, state.message);
          }
        },
        builder: (context, state) {
          if (state is ChatGetRoomsLoading) {
            return const Loader();
          }

          final List<ChatRoom> rooms = state is ChatGetRoomsSuccess
              ? state.rooms
              : state is ChatGetRoomsRefreshLoading
                  ? state.rooms
                  : [];

          return RefreshIndicator(
            onRefresh: _refreshChats,
            child: Column(
              children: [
                if (state is ChatGetRoomsRefreshLoading)
                  const Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  ),
                Expanded(
                  child: rooms.isEmpty
                      ? const Center(child: Text('No chats'))
                      : ListView.builder(
                          itemCount: rooms.length,
                          itemBuilder: (context, index) {
                            final room = rooms[index];
                            final user = (context.read<AppUserCubit>().state
                                    as AppUserLoggedIn)
                                .user;
                            final participantsNamesWithoutCurrentUser = room
                                    .participants
                                    ?.map((e) => e.name)
                                    .where((name) => name != user.name)
                                    .toList() ??
                                [];
                            return ListTile(
                              title: Text(
                                participantsNamesWithoutCurrentUser.join(', '),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  ChatRoomPage.route(room),
                                ).then((_) {
                                  _fetchChats();
                                });
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
