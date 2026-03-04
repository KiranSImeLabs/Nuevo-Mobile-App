import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/goal.dart';
import '../../repositories/goal_repository.dart';
import '../usecase.dart';

class UpdateGoalParams {
  final String id;
  final String goal;
  const UpdateGoalParams({required this.id, required this.goal});
}

class UpdateGoalUseCase implements UseCase<Goal, UpdateGoalParams> {
  final GoalRepository repository;

  UpdateGoalUseCase(this.repository);

  @override
  Future<Either<Failure, Goal>> call(UpdateGoalParams params) async {
    return await repository.updateGoal(params.id, params.goal);
  }
}
