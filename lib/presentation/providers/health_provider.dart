import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/repositories/health_repository_impl.dart';
import '../../domain/repositories/health_repository.dart';
import '../../data/models/daily_exercise_model.dart';
import '../../data/models/weekly_schedule_model.dart';
import '../../data/models/session_progress_model.dart';
import '../../data/models/active_progress_model.dart';
import 'core_providers.dart';

// Provider for HealthRepository
final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  final apiClient = ApiClient(dioClient: dioClient);
  return HealthRepositoryImpl(apiClient);
});

// FutureProvider for Today's Exercise
final todayExerciseProvider = FutureProvider<DailyExerciseModel?>((ref) async {
  final repository = ref.watch(healthRepositoryProvider);
  final result = await repository.getTodayExercise();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// FutureProvider for Weekly Schedule
final weeklyScheduleProvider = FutureProvider<WeeklyScheduleModel?>((ref) async {
  final repository = ref.watch(healthRepositoryProvider);
  final result = await repository.getWeeklySchedule();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// FutureProvider.family for Session Details
final sessionDetailsProvider = FutureProvider.family<GuidedSessionModel?, String>((ref, id) async {
  final repository = ref.watch(healthRepositoryProvider);
  final result = await repository.getSessionDetails(id);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// FutureProvider.family for Start Session
final startSessionProvider = FutureProvider.family<SessionProgressModel?, String>((ref, id) async {
  final repository = ref.watch(healthRepositoryProvider);
  final result = await repository.startSession(id);
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});

// FutureProvider for Active Progress
final activeProgressProvider = FutureProvider.autoDispose<ActiveProgressModel?>((ref) async {
  final repository = ref.watch(healthRepositoryProvider);
  final result = await repository.getActiveProgress();
  
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
});
