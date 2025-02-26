import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UserRepository {
  Future<Either<Failure, List<User>>> searchUsers({required String query});
}
