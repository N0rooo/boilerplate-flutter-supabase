import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/core/common/entities/user.dart';
import 'package:boilerplate_flutter/features/chat/domain/repository/chat_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetUserInfo implements UseCase<User, GetUserInfoParams> {
  final ChatRepository repository;

  GetUserInfo(this.repository);

  @override
  Future<Either<Failure, User>> call(GetUserInfoParams params) async {
    return await repository.getUserInfo(params.userId);
  }
}

class GetUserInfoParams {
  final String userId;

  GetUserInfoParams({required this.userId});
}
