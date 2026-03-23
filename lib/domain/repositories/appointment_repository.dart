import '../../data/models/api_response.dart';
import '../../data/models/appointment_model.dart';

abstract class AppointmentRepository {
  Future<ApiResponse<List<TimeSlot>>> getTimeSlots(String date);
  Future<ApiResponse<AppointmentResponseData>> createAppointment(
      CreateAppointmentRequest request);
}
