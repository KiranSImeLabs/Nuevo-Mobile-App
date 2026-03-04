import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/goal.dart';
import '../../repositories/goal_repository.dart';
import '../usecase.dart';

class CreateGoalParams {
  final String goal;
  const CreateGoalParams({required this.goal});
}

class CreateGoalUseCase implements UseCase<Goal, CreateGoalParams> {
  final GoalRepository repository;

  CreateGoalUseCase(this.repository);

  @override
  Future<Either<Failure, Goal>> call(CreateGoalParams params) async {
    return await repository.createGoal(params.goal);
  }
}
