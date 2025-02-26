part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initPost();
  _initCore();
  _initChat();
  final supabase = await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(() => supabase.client);

  serviceLocator.registerLazySingleton(() => Hive.box(name: 'blogs'));

  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(
    () => AppUserCubit(),
  );
  serviceLocator.registerFactory<ConnectionChecker>(() => ConnectionCheckerImpl(
        serviceLocator(),
      ));
}

void _initCore() {
  serviceLocator
    ..registerFactory<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<UserRepository>(
      () => UserRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => SearchUsers(
        serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => UserSearchBloc(
        searchUsers: serviceLocator(),
      ),
    );
  // Bloc
}

void _initAuth() {
  // Datasource
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        serviceLocator<SupabaseClient>(),
      ),
    )
    // Repository
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UserSignUp(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserLogin(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CurrentUser(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        appUserCubit: serviceLocator(),
      ),
    );
}

void _initPost() {
  // Datasource
  serviceLocator
    ..registerFactory<PostRemoteDataSource>(
      () => PostRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<PostLocalDataSource>(
      () => PostLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<PostRepository>(
      () => PostRepositoryImpl(
        serviceLocator(),
        serviceLocator(),
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => UploadPost(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetAllPosts(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => PostBloc(
        uploadPost: serviceLocator(),
        getAllPosts: serviceLocator(),
      ),
    );
}

void _initChat() {
  serviceLocator
    ..registerFactory<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(
        serviceLocator(),
      ),
    )
    ..registerFactory<ChatRepository>(
      () => ChatRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Usecases
    ..registerFactory(
      () => SendMessage(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CreateChatRoom(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetChatRooms(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetMessagesStream(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetUserInfo(
        serviceLocator(),
      ),
    )

    // Bloc
    ..registerLazySingleton(
      () => ChatBloc(
        createChatRoom: serviceLocator(),
        getChatRooms: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => MessageBloc(
        getMessagesStream: serviceLocator(),
        sendMessage: serviceLocator(),
        getUserInfo: serviceLocator(),
      ),
    );
}
