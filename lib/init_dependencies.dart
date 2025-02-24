import 'package:boilerplate_flutter/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:boilerplate_flutter/core/secrets/app_secrets.dart';
import 'package:boilerplate_flutter/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:boilerplate_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:boilerplate_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:boilerplate_flutter/features/auth/domain/usecases/current_user.dart';
import 'package:boilerplate_flutter/features/auth/domain/usecases/user_login.dart';
import 'package:boilerplate_flutter/features/auth/domain/usecases/user_sign_up.dart';
import 'package:boilerplate_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'init_dependencies.main.dart';
