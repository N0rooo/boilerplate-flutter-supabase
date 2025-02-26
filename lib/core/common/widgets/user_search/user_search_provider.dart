import 'package:boilerplate_flutter/core/blocs/user_search/user_search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate_flutter/init_dependencies.dart';

class UserSearchProvider extends StatelessWidget {
  final Widget child;

  const UserSearchProvider({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UserSearchBloc>(),
      child: child,
    );
  }
}
