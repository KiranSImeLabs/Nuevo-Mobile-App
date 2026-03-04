import 'package:dartz/dartz.dart';
import '../../domain/entities/task.dart' as entities;
import '../../domain/entities/session.dart';
import '../../domain/repositories/task_repository.dart';
import '../../core/errors/failures.dart';
import '../models/task_model.dart';
import '../models/session_model.dart';

/// Task Repository Implementation (Data Layer)
/// Uses mock data for now - can be replaced with API calls later
class TaskRepositoryImpl implements TaskRepository {
  
  @override
  Future<Either<Failure, List<entities.Task>>> getPendingTasks() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      
      final tasks = [
        const TaskModel(
          id: '1',
          title: 'Pre-session questionnaire',
          description: 'Complete your pre-session health questionnaire',
          durationMinutes: 5,
          imageUrl: null, // In real app, would have image
          isCompleted: false,
          type: 'questionnaire',
          dueDate: null,
          completedAt: null,
        ),
        const TaskModel(
          id: '2',
          title: 'Daily Exercise',
          description: 'Complete your morning workout routine',
          durationMinutes: 30,
          imageUrl: null,
          isCompleted: false,
          type: 'exercise',
          dueDate: null,
          completedAt: null,
        ),
      ];
      
      return Right(tasks.map((t) => t.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to load pending tasks'));
    }
  }
  
  @override
  Future<Either<Failure, List<entities.Task>>> getCompletedTasks() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      
      final tasks = [
        TaskModel(
          id: '3',
          title: 'Morning Meditation',
          description: 'Completed mindfulness session',
          durationMinutes: 10,
          imageUrl: null,
          isCompleted: true,
          type: 'general',
          dueDate: null,
          completedAt: DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        ),
        TaskModel(
          id: '4',
          title: 'Nutrition Log',
          description: 'Logged breakfast and lunch',
          durationMinutes: 5,
          imageUrl: null,
          isCompleted: true,
          type: 'nutrition',
          dueDate: null,
          completedAt: DateTime.now().subtract(const Duration(hours: 4)).toIso8601String(),
        ),
      ];
      
      return Right(tasks.map((t) => t.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to load completed tasks'));
    }
  }
  
  @override
  Future<Either<Failure, void>> completeTask(String taskId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      // Mock implementation
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure('Failed to complete task'));
    }
  }
  
  @override
  Future<Either<Failure, List<Session>>> getUpcomingSessions() async {
    try {
      await Future.delayed(const Duration(milliseconds: 350));
      
      final sessions = [
        SessionModel(
          id: '1',
          title: 'Dietitian Session',
          type: 'dietitian',
          scheduledTime: DateTime.now().add(const Duration(hours: 2)).toIso8601String(),
          durationMinutes: 30,
          professionalName: 'Dr. Sarah Johnson',
          notes: null,
          isCompleted: false,
        ),
      ];
      
      return Right(sessions.map((s) => s.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure('Failed to load sessions'));
    }
  }
  
  @override
  Future<Either<Failure, Session?>> getNextSession() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Mock data matching UI: "10:30 AM - Dietitian Session"
      final now = DateTime.now();
      final session = SessionModel(
        id: '1',
        title: 'Dietitian Session',
        type: 'dietitian',
        scheduledTime: DateTime(now.year, now.month, now.day, 10, 30).toIso8601String(),
        durationMinutes: 30,
        professionalName: null,
        notes: null,
        isCompleted: false,
      );
      
      return Right(session.toEntity());
    } catch (e) {
      return Left(ServerFailure('Failed to load next session'));
    }
  }
}
