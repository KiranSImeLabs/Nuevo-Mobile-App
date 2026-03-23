import 'package:json_annotation/json_annotation.dart';

part 'appointment_model.g.dart';

// ==========================================
// Requests
// ==========================================

@JsonSerializable()
class CreateAppointmentRequest {
  final String locationId;
  final String date;
  final String time;
  final String programId;
  final String patientId;

  const CreateAppointmentRequest({
    required this.locationId,
    required this.date,
    required this.time,
    required this.programId,
    required this.patientId,
  });

  factory CreateAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateAppointmentRequestToJson(this);
}

@JsonSerializable()
class UpdateAppointmentRequest {
  final String location;

  const UpdateAppointmentRequest({
    required this.location,
  });

  factory UpdateAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateAppointmentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateAppointmentRequestToJson(this);
}

// ==========================================
// Responses
// ==========================================

@JsonSerializable()
class AppointmentResponseData {
  final String bookingId;
  final String status;
  final String? consultationDateTime;
  
  // Create response has a full location object, update response has locationId
  final dynamic location;
  final String? locationId;

  // Create response has a full program object, update response has programId
  final dynamic program;
  final String? programId;
  
  final String? patientId;

  const AppointmentResponseData({
    required this.bookingId,
    required this.status,
    this.consultationDateTime,
    this.location,
    this.locationId,
    this.program,
    this.programId,
    this.patientId,
  });

  factory AppointmentResponseData.fromJson(Map<String, dynamic> json) =>
      _$AppointmentResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentResponseDataToJson(this);
}

@JsonSerializable()
class AppointmentLocation {
  final String id;
  final String name;
  final String? address;
  final String? city;

  const AppointmentLocation({
    required this.id,
    required this.name,
    this.address,
    this.city,
  });

  factory AppointmentLocation.fromJson(Map<String, dynamic> json) =>
      _$AppointmentLocationFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentLocationToJson(this);
}

@JsonSerializable()
class AppointmentProgram {
  final String id;
  final String name;
  final String? type;

  const AppointmentProgram({
    required this.id,
    required this.name,
    this.type,
  });

  factory AppointmentProgram.fromJson(Map<String, dynamic> json) =>
      _$AppointmentProgramFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentProgramToJson(this);
}

@JsonSerializable()
class CancelAppointmentResponseData {
  final String bookingId;

  const CancelAppointmentResponseData({
    required this.bookingId,
  });

  factory CancelAppointmentResponseData.fromJson(Map<String, dynamic> json) =>
      _$CancelAppointmentResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$CancelAppointmentResponseDataToJson(this);
}

@JsonSerializable()
class TimeSlot {
  final String startTime;
  final String endTime;
  final String displayTime;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.displayTime,
  });

  factory TimeSlot.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotFromJson(json);

  Map<String, dynamic> toJson() => _$TimeSlotToJson(this);
}
