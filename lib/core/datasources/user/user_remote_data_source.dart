import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/common/models/user_model.dart';
import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:boilerplate_flutter/core/error/exceptions.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class UserRemoteDataSource {
  Future<List<UserModel>> searchUsers({required String query});
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final SupabaseClient supabaseClient;
  UserRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<UserModel>> searchUsers({required String query}) async {
    try {
      final currentUser = await supabaseClient.auth.currentUser;
      final users = await supabaseClient
          .from(SupabaseTables.profiles)
          .select()
          .ilike('name', '%$query%')
          .not('id', 'eq', currentUser?.id)
          .limit(20);

      if (users.isEmpty) {
        return [];
      }
      return users.map((e) => UserModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(
        e.toString(),
      );
    }
  }
}
