import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/core/repositories/user/user_repository.dart';
import 'package:fpdart/src/either.dart';

class SearchUsers implements UseCase<List<User>, String> {
  final UserRepository repository;
  const SearchUsers(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(String query) async {
    return await repository.searchUsers(query: query);
  }
}
