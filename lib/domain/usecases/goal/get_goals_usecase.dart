import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/goal.dart';
import '../../repositories/goal_repository.dart';
import '../usecase.dart';

class GetGoalsUseCase implements UseCase<List<Goal>, NoParams> {
  final GoalRepository repository;

  GetGoalsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Goal>>> call(NoParams params) async {
    return await repository.getGoals();
  }
}
