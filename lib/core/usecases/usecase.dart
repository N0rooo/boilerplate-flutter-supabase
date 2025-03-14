import 'package:boilerplate_flutter/core/error/failures.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

abstract interface class StreamUseCase<SuccessType, Params> {
  Stream<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
