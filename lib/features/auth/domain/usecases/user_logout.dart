import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:boilerplate_flutter/core/usecases/usecase.dart';
import 'package:boilerplate_flutter/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserLogout implements UseCase<void, void> {
  final AuthRepository authRepository;
  const UserLogout(this.authRepository);
  @override
  Future<Either<Failure, void>> call(void params) async {
    return await authRepository.logout();
  }
}
