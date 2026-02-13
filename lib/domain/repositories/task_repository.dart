import 'package:dartz/dartz.dart';
import '../entities/task.dart' as entities;
import '../entities/session.dart';
import '../../core/errors/failures.dart';

/// Task Repository Interface (Domain Layer)
/// Defines contract for task and session data operations
abstract class TaskRepository {
  /// Get pending tasks (action required)
  Future<Either<Failure, List<entities.Task>>> getPendingTasks();
  
  /// Get completed tasks
  Future<Either<Failure, List<entities.Task>>> getCompletedTasks();
  
  /// Mark task as completed
  Future<Either<Failure, void>> completeTask(String taskId);
  
  /// Get upcoming sessions
  Future<Either<Failure, List<Session>>> getUpcomingSessions();
  
  /// Get next session (closest to current time)
  Future<Either<Failure, Session?>> getNextSession();
}
