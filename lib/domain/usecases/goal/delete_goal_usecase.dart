import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/goal_repository.dart';
import '../usecase.dart';

class DeleteGoalParams {
  final String id;
  const DeleteGoalParams({required this.id});
}

class DeleteGoalUseCase implements UseCase<void, DeleteGoalParams> {
  final GoalRepository repository;

  DeleteGoalUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteGoalParams params) async {
    return await repository.deleteGoal(params.id);
  }
}
