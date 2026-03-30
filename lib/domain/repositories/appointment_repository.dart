import '../../data/models/api_response.dart';
import '../../data/models/appointment_model.dart';

abstract class AppointmentRepository {
  Future<ApiResponse<TimeSlotResponse>> getTimeSlots({
    required String memberId,
    required String date,
  });

  Future<ApiResponse<AppointmentResponseData>> bookAppointment({
    required String memberId,
    required String startTime,
    String? notes,
  });

  Future<ApiResponse<AppointmentResponseData>> getAppointmentById(
      String appointmentId);
}
