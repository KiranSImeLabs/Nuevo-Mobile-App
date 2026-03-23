import '../../domain/repositories/appointment_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/api_response.dart';
import '../models/appointment_model.dart';

class AppointmentRepositoryImpl implements AppointmentRepository {
  final ApiClient _apiClient;

  AppointmentRepositoryImpl(this._apiClient);

  @override
  Future<ApiResponse<List<TimeSlot>>> getTimeSlots(String date) {
    return _apiClient.getTimeSlots(date);
  }

  @override
  Future<ApiResponse<AppointmentResponseData>> createAppointment(
      CreateAppointmentRequest request) {
    return _apiClient.createAppointment(request);
  }
}
