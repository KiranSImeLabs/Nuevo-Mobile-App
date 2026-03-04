import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/goal.dart';

abstract class GoalRepository {
  Future<Either<Failure, List<Goal>>> getGoals();
  Future<Either<Failure, Goal>> createGoal(String goal);
  Future<Either<Failure, Goal>> getGoalById(String id);
  Future<Either<Failure, Goal>> updateGoal(String id, String goal);
  Future<Either<Failure, void>> deleteGoal(String id);
}
