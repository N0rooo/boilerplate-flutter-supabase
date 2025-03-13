import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/common/widgets/input.dart';
import 'package:boilerplate_flutter/core/common/widgets/loader.dart';
import 'package:boilerplate_flutter/core/common/widgets/user_search/user_search_widget.dart';
import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:boilerplate_flutter/core/blocs/user_search/user_search_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/pages/chat_room_page.dart';
import 'package:boilerplate_flutter/features/chat/presentation/widgets/chat_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:boilerplate_flutter/core/utils/debouncer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateChatRoomPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const CreateChatRoomPage(),
      );
  const CreateChatRoomPage({super.key});

  @override
  State<CreateChatRoomPage> createState() => _CreateChatRoomPageState();
}

class _CreateChatRoomPageState extends State<CreateChatRoomPage>
    with Debouncer {
  final userSearchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  final List<User> selectedUsers = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusManager.instance.primaryFocus?.unfocus();
      }
    });
  }

  @override
  void dispose() {
    userSearchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void searchUsers(String query) {
    debounce(() {
      context.read<UserSearchBloc>().add(SearchUsersByName(query));
    });
  }

  void createChatRoom(List<String> participantIds) {
    final currentUserId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    context.read<ChatBloc>().add(ChatCreateRoom(
          name: '',
          participantIds: [currentUserId, ...participantIds],
        ));
  }

  void handleUserSelection(User user) {
    setState(() {
      if (selectedUsers.contains(user)) {
        selectedUsers.remove(user);
      } else {
        selectedUsers.add(user);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Chat'),
        actions: [
          TextButton(
            onPressed: selectedUsers.isNotEmpty
                ? () {
                    createChatRoom(
                      selectedUsers.map((user) => user.id).toList(),
                    );
                  }
                : null,
            child: const Text("Next",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatCreateRoomFailure) {
            showSnackBar(context, state.message);
          } else if (state is ChatCreateRoomSuccess) {
            Navigator.pushReplacement(
              context,
              ChatRoomPage.route(state.room),
            );
          }
        },
        builder: (context, state) {
          if (state is ChatCreateRoomLoading) {
            return const Loader();
          }
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: UserSearchWidget(
                searchHint: 'Search for users',
                focusNode: _focusNode,
                selectedUsers: selectedUsers,
                onUserSelected: handleUserSelection,
              ),
            ),
          );
        },
      ),
    );
  }
}
