import 'package:boilerplate_flutter/core/blocs/user_search/user_search_bloc.dart';
import 'package:boilerplate_flutter/core/common/widgets/loader.dart';
import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/features/chat/presentation/widgets/chat_search_bar.dart';
import 'package:boilerplate_flutter/core/utils/debouncer.dart';

class UserSearchWidget extends StatefulWidget {
  final void Function(User) onUserSelected;
  final String? searchHint;
  final FocusNode? focusNode;
  final List<User> selectedUsers;

  const UserSearchWidget({
    super.key,
    required this.onUserSelected,
    required this.selectedUsers,
    this.searchHint,
    this.focusNode,
  });

  @override
  State<UserSearchWidget> createState() => _UserSearchWidgetState();
}

class _UserSearchWidgetState extends State<UserSearchWidget> with Debouncer {
  final userSearchController = TextEditingController();

  void searchUsers(String query) {
    debounce(() {
      if (query.isNotEmpty) {
        context.read<UserSearchBloc>().add(SearchUsersByName(query));
      }
    });
  }

  @override
  void dispose() {
    userSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ChatSearchBar(
          controller: userSearchController,
          onChanged: searchUsers,
          placeholder: widget.searchHint ?? 'Search for users',
          focusNode: widget.focusNode,
        ),
        if (widget.selectedUsers.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedUsers.length,
              itemBuilder: (context, index) {
                final user = widget.selectedUsers[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(user.name),
                    onDeleted: () {
                      widget.onUserSelected(user);
                    },
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 20),
        Expanded(
          child: BlocConsumer<UserSearchBloc, UserSearchState>(
            listener: (context, state) {
              if (state is UserSearchFailure) {
                showSnackBar(context, state.message);
                return;
              }
            },
            builder: (context, state) {
              if (state is UserSearchLoading) {
                return const Loader();
              }
              if (state is UserSearchEmpty) {
                return const Center(
                  child: Text('No users found'),
                );
              }
              if (state is UserSearchSuccess) {
                return ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    final user = state.users[index];
                    final isSelected = widget.selectedUsers.contains(user);
                    return ListTile(
                      title: Text(user.name),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                      onTap: () {
                        widget.onUserSelected(user);
                      },
                    );
                  },
                );
              }
              return Center(
                child: Text(widget.searchHint ?? 'Search for users'),
              );
            },
          ),
        ),
      ],
    );
  }
}
