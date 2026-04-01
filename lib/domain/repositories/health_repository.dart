import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../data/models/daily_exercise_model.dart';
import '../../data/models/weekly_schedule_model.dart';
import '../../data/models/session_progress_model.dart';
import '../../data/models/active_progress_model.dart';
import '../../data/models/api_response.dart';
import '../../data/models/lab_report_model.dart';
import '../../data/models/lab_request_model.dart';
import '../models/health/patient_habit_history.dart';

abstract class HealthRepository {
  Future<Either<Failure, DailyExerciseModel>> getTodayExercise();
  Future<Either<Failure, WeeklyScheduleModel>> getWeeklySchedule();
  Future<Either<Failure, GuidedSessionModel>> getSessionDetails(String id);
  Future<Either<Failure, SessionProgressModel>> startSession(String id);
  Future<Either<Failure, ApiResponse<SessionProgressModel>>> completeSession(String id);
  Future<Either<Failure, SessionProgressModel?>> syncSessionProgress(String id, Map<String, dynamic> data);
  Future<Either<Failure, ActiveProgressModel?>> getActiveProgress();
  Future<Either<Failure, LabReportDetailData>> getLabReportDetails(String id);
  Future<Either<Failure, LabRequestData>> createLabRequest(String notes);
  Future<Either<Failure, PatientHabitHistory?>> getPatientHabitHistory(String date);
  Future<Either<Failure, List<PatientHabitHistory>>> getAllPatientHabitHistory();
  Future<Either<Failure, PatientHabitHistory>> savePatientHabitHistory(PatientHabitHistory data);
}
