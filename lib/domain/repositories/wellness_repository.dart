import 'package:dartz/dartz.dart';
import '../entities/wellness_program.dart';
import '../../core/errors/failures.dart';

/// Wellness Repository Interface (Domain Layer)
/// Defines contract for wellness program data operations
abstract class WellnessRepository {
  /// Get current user's wellness program
  Future<Either<Failure, WellnessProgram>> getWellnessProgram();
  
  /// Get habits for the current wellness program
  Future<Either<Failure, List<Habit>>> getHabits();
  
  /// Update habit completion status
  Future<Either<Failure, void>> updateHabitStatus(String habitId, bool isCompleted);
}
