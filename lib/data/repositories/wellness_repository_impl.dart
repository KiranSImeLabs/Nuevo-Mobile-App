import 'package:dartz/dartz.dart';
import '../../domain/entities/wellness_program.dart';
import '../../domain/repositories/wellness_repository.dart';
import '../../core/errors/failures.dart';
import '../models/wellness_program_model.dart';

/// Wellness Repository Implementation (Data Layer)
/// Uses mock data for now - can be replaced with API calls later
class WellnessRepositoryImpl implements WellnessRepository {
  
  @override
  Future<Either<Failure, WellnessProgram>> getWellnessProgram() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Mock data matching the UI design
      final model = const WellnessProgramModel(
        id: '1',
        name: 'Wellness Reset',
        description: 'Advanced assessment and specialist-led profiling',
        progressPercentage: 0.58, // 58%
        habitsCount: 2,
        iconUrl: null,
      );
      
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to load wellness program'));
    }
  }
  
  @override
  Future<Either<Failure, List<Habit>>> getHabits() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      final habits = [
        const HabitModel(
          id: '1',
          name: 'Morning Meditation',
          description: 'Practice mindfulness for 10 minutes',
          isCompleted: true,
          completedAt: null,
        ),
        const HabitModel(
          id: '2',
          name: 'Healthy Breakfast',
          description: 'Eat a balanced breakfast',
          isCompleted: false,
          completedAt: null,
        ),
      ];
      
      return Right(habits.map((h) => h.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to load habits'));
    }
  }
  
  @override
  Future<Either<Failure, void>> updateHabitStatus(String habitId, bool isCompleted) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      // Mock implementation - in real app, would call API
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to update habit'));
    }
  }
}
