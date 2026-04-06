import '../../domain/repositories/appointment_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/api_response.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final ApiClient _apiClient;

  AppointmentRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<TimeSlotResponse>> getTimeSlots({
    required String memberId,
    required String date,
  }) {
    return _apiClient.getTimeSlots(memberId: memberId, date: date);
  }

  @override
  Future<ApiResponse<AppointmentResponseData>> bookAppointment({
    required String memberId,
    required String startTime,
    String? notes,
  }) {
    return _apiClient.bookAppointment(
        memberId: memberId, startTime: startTime, notes: notes);
  }

  @override
  Future<ApiResponse<AppointmentResponseData>> getAppointmentById(
      String appointmentId) {
    return _apiClient.getAppointmentById(appointmentId);
  }

  @override
  Future<ApiResponse<UserAppointmentsResponse>> getUserAppointments() {
    return _apiClient.getUserAppointments();
  }
}
