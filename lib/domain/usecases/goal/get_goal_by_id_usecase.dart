import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/goal.dart';
import '../../repositories/goal_repository.dart';
import '../usecase.dart';

class GetGoalByIdParams {
  final String id;
  const GetGoalByIdParams({required this.id});
}

class GetGoalByIdUseCase implements UseCase<Goal, GetGoalByIdParams> {
  final GoalRepository repository;

  GetGoalByIdUseCase(this.repository);

  @override
  Future<Either<Failure, Goal>> call(GetGoalByIdParams params) async {
    return await repository.getGoalById(params.id);
  }
}
