import 'package:dartz/dartz.dart';
import 'package:nuevo_app/core/errors/failures.dart';

/// Base Use Case Interface
/// All use cases should extend this class
/// Type: The return type of the use case
/// Params: The parameters required by the use case
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// Use case with no parameters
class NoParams {
  const NoParams();
}
