import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/task.dart' as entities;
import '../../repositories/task_repository.dart';
import '../usecase.dart';

class GetCompletedTasksUseCase implements UseCase<List<entities.Task>, NoParams> {
  final TaskRepository repository;

  GetCompletedTasksUseCase(this.repository);

  @override
  Future<Either<Failure, List<entities.Task>>> call(NoParams params) async {
    return await repository.getCompletedTasks();
  }
}
