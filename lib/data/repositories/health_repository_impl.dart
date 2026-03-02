import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/daily_exercise_model.dart';
import '../models/weekly_schedule_model.dart';
import '../models/session_progress_model.dart';
import '../models/active_progress_model.dart';

class HealthRepositoryImpl implements HealthRepository {
  final ApiClient apiClient;

  HealthRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, DailyExerciseModel>> getTodayExercise() async {
    try {
      final response = await apiClient.getTodayExercise();
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message ?? 'Unknown Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Network Error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WeeklyScheduleModel>> getWeeklySchedule() async {
    try {
      final response = await apiClient.getWeeklySchedule();
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message ?? 'Unknown Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Network Error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, GuidedSessionModel>> getSessionDetails(String id) async {
    try {
      final response = await apiClient.getSessionDetails(id);
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message ?? 'Unknown Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Network Error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionProgressModel>> startSession(String id) async {
    try {
      final response = await apiClient.startSession(id);
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(message: response.message ?? 'Unknown Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Network Error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActiveProgressModel?>> getActiveProgress() async {
    try {
      final response = await apiClient.getActiveProgress();
      if (response.success) {
        return Right(response.data);
      } else {
        return Left(ServerFailure(message: response.message ?? 'Unknown Error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure(message: e.message ?? 'Network Error'));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
