import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/common/screens/main_screen.dart';
import 'package:boilerplate_flutter/core/theme/theme.dart';
import 'package:boilerplate_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:boilerplate_flutter/core/blocs/user_search/user_search_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/message/message_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/camera/camera_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:boilerplate_flutter/features/post/presentation/bloc/post_bloc.dart';
import 'package:boilerplate_flutter/init_dependencies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => serviceLocator<AppUserCubit>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<AuthBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<PostBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<UserSearchBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<ChatBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<MessageBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<FilterBloc>(),
      ),
      BlocProvider(
        create: (_) => serviceLocator<CameraBloc>(),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(
          AuthIsUserLoggedIn(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkThemeMode,
      home: BlocSelector<AppUserCubit, AppUserState, bool>(
        selector: (state) {
          return state is AppUserLoggedIn;
        },
        builder: (context, isLoggedIn) {
          if (isLoggedIn) {
            return const MainScreen();
          }
          return const LoginPage();
        },
      ),
    );
  }
}
