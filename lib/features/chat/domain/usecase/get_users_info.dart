import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUsersInfo implements UseCase<List<User>, GetUsersInfoParams> {
  final ChatRepository repository;

  GetUsersInfo(this.repository);

  @override
  Future<Either<Failure, List<User>>> call(GetUsersInfoParams params) async {
    return await repository.getUsersInfo(params.userIds);
  }
}

class GetUsersInfoParams {
  final List<String> userIds;

  GetUsersInfoParams({required this.userIds});
}
