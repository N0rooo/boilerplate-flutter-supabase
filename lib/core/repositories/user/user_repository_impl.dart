import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/error/exceptions.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/datasources/user/user_remote_data_source.dart';
import 'package:boilerplate_flutter/core/repositories/user/user_repository.dart';
import 'package:fpdart/src/either.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  UserRepositoryImpl(this.userRemoteDataSource);

  @override
  Future<Either<Failure, List<User>>> searchUsers(
      {required String query}) async {
    try {
      final users = await userRemoteDataSource.searchUsers(query: query);
      return right(users);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
