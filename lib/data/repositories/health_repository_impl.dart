import '../../core/errors/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';
import '../../domain/repositories/health_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/daily_exercise_model.dart';
import '../models/weekly_schedule_model.dart';
import '../models/session_progress_model.dart';
import '../models/active_progress_model.dart';
import '../models/api_response.dart';
import '../models/lab_report_model.dart';
import '../models/lab_request_model.dart';

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
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
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
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
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
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
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
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, ApiResponse<SessionProgressModel>>> completeSession(String id) async {
    try {
      final response = await apiClient.completeSession(id);
      if (response.success && response.data != null) {
        return Right(response);
      } else {
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SessionProgressModel?>> syncSessionProgress(String id, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.syncSessionProgress(id, data);
      if (response.success) {
        return Right(response.data);
      } else {
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
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
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  @override
  Future<Either<Failure, LabReportDetailData>> getLabReportDetails(String id) async {
    try {
      final response = await apiClient.getLabReportDetails(id);
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LabRequestData>> createLabRequest(String notes) async {
    try {
      final request = CreateLabRequest(notes: notes);
      final response = await apiClient.createLabRequest(request);
      if (response.success && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(response.message ?? 'Unknown Error'));
      }
    } on AppException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
