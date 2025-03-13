part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  _initPost();
  _initCore();
  _initChat();
  _initFilters();
  _initCamera();
  ();
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
    ..registerFactory(
      () => UserLogout(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator(),
        userLogin: serviceLocator(),
        currentUser: serviceLocator(),
        userLogout: serviceLocator(),
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
      () => GetUsersInfo(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UserBloc(
        getUsersInfo: serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => ChatBloc(
        createChatRoom: serviceLocator(),
        getChatRooms: serviceLocator(),
        userBloc: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => MessageBloc(
        getMessagesStream: serviceLocator(),
        sendMessage: serviceLocator(),
        getUsersInfo: serviceLocator(),
        userBloc: serviceLocator(),
      ),
    );
}

void _initCamera() {
  serviceLocator
    ..registerFactory<CameraRepository>(
      () => CameraRepositoryImpl(),
    )
    ..registerFactory<GetAvailableCameras>(
      () => GetAvailableCameras(
        cameraRepository: serviceLocator(),
      ),
    )
    ..registerFactory<InitializeCameras>(
      () => InitializeCameras(
        cameraRepository: serviceLocator(),
      ),
    )
    ..registerFactory<DisposeCameras>(
      () => DisposeCameras(
        cameraRepository: serviceLocator(),
      ),
    )
    ..registerFactory<TakePicture>(
      () => TakePicture(
        cameraRepository: serviceLocator(),
      ),
    )
    ..registerLazySingleton(
      () => CameraBloc(
        getAvailableCameras: serviceLocator(),
        initializeCameras: serviceLocator(),
        disposeCameras: serviceLocator(),
        takePicture: serviceLocator(),
      ),
    );
}

void _initFilters() {
  serviceLocator
    ..registerFactory<FilterRepository>(
      () => FilterRepositoryImpl(),
    )
    ..registerFactory(
      () => GetFilterPresets(
        filterRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => SaveCustomFilter(
        filterRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteCustomFilter(
        filterRepository: serviceLocator(),
      ),
    )
    ..registerFactory(
      () => UpdateCustomFilter(
        filterRepository: serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => FilterBloc(
        getFilterPresets: serviceLocator(),
        saveCustomFilter: serviceLocator(),
        deleteCustomFilter: serviceLocator(),
        updateCustomFilter: serviceLocator(),
      ),
    );
}
