import 'package:dartz/dartz.dart';
import 'package:flutter_clean_architecture_boilerplate/core/error/failure.dart';

/// Base class for all use cases in the domain layer
/// Use cases represent business logic operations
/// Returns Either<Failure, Type> to handle success/failure cases
abstract class UseCase<Type, Params> {
  /// Execute the use case with given parameters
  /// Returns Either with Failure on left side or result on right side
  Future<Either<Failure, Type>> call(Params params);
}

/// Parameter class for use cases that don't require parameters
class NoParams {
  const NoParams();
}