import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate_flutter/core/blocs/user_search/user_search_bloc.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/common/widgets/loader.dart';
import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';

class UserSearchBuilder extends StatelessWidget {
  final Widget Function(
    BuildContext context,
    List<User> users,
    void Function(User) onSelect,
  ) builder;
  final void Function(User) onUserSelected;

  const UserSearchBuilder({
    super.key,
    required this.builder,
    required this.onUserSelected,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserSearchBloc, UserSearchState>(
      listener: (context, state) {
        if (state is UserSearchFailure) {
          showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is UserSearchSuccess) {
          return builder(context, state.users, onUserSelected);
        }
        if (state is UserSearchLoading) {
          return const Loader();
        }
        if (state is UserSearchFailure) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(child: Text('Search for users'));
        ;
      },
    );
  }
}
