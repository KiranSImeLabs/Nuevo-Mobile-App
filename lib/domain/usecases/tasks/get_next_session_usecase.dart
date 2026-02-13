import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/session.dart';
import '../../repositories/task_repository.dart';
import '../usecase.dart';

class GetNextSessionUseCase implements UseCase<Session?, NoParams> {
  final TaskRepository repository;

  GetNextSessionUseCase(this.repository);

  @override
  Future<Either<Failure, Session?>> call(NoParams params) async {
    return await repository.getNextSession();
  }
}
