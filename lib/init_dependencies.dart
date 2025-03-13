import 'package:boilerplate_flutter/core/blocs/user_search/user_search_bloc.dart';
import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/datasources/user/user_remote_data_source.dart';
import 'package:boilerplate_flutter/core/network/connection_checker.dart';
import 'package:boilerplate_flutter/core/repositories/user/user_repository.dart';
import 'package:boilerplate_flutter/core/repositories/user/user_repository_impl.dart';
import 'package:boilerplate_flutter/core/secrets/app_secrets.dart';
import 'package:boilerplate_flutter/core/usecases/user/search_users.dart';
import 'package:boilerplate_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:boilerplate_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:boilerplate_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:boilerplate_flutter/features/auth/domain/usecases/current_user.dart';
import 'package:boilerplate_flutter/features/auth/domain/usecases/user_login.dart';
import 'package:boilerplate_flutter/features/auth/domain/usecases/user_logout.dart';
import 'package:boilerplate_flutter/features/auth/domain/usecases/user_sign_up.dart';
import 'package:boilerplate_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:boilerplate_flutter/features/chat/data/datasource/chat_remote_data_source.dart';
import 'package:boilerplate_flutter/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/create_chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_chat_room.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_users_info.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/send_message.dart';
import 'package:boilerplate_flutter/features/chat/domain/usecase/get_messages_stream.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/chat/chat_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/message/message_bloc.dart';
import 'package:boilerplate_flutter/features/chat/presentation/bloc/user/user_bloc.dart';
import 'package:boilerplate_flutter/features/filters/data/repositories/camera_repository_impl.dart';
import 'package:boilerplate_flutter/features/filters/data/repositories/filter_repository_impl.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/filter_repository.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/get_filter_presets.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/save_custom_filter.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/camera/camera_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:boilerplate_flutter/features/post/data/datasources/post_local_data_source.dart';
import 'package:boilerplate_flutter/features/post/data/datasources/post_remote_data_source.dart';
import 'package:boilerplate_flutter/features/post/data/repositories/post_repository_impl.dart';
import 'package:boilerplate_flutter/features/post/domain/repositories/post_repository.dart';
import 'package:boilerplate_flutter/features/post/domain/usecases/get_all_posts.dart';
import 'package:boilerplate_flutter/features/post/domain/usecases/upload_post.dart';
import 'package:boilerplate_flutter/features/post/presentation/bloc/post_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
