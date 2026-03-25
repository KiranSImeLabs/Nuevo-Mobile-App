// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAppointmentRequest _$CreateAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => CreateAppointmentRequest(
  date: json['date'] as String,
  time: json['time'] as String,
  programId: json['programId'] as String,
  patientId: json['patientId'] as String,
);

Map<String, dynamic> _$CreateAppointmentRequestToJson(
  CreateAppointmentRequest instance,
) => <String, dynamic>{
  'date': instance.date,
  'time': instance.time,
  'programId': instance.programId,
  'patientId': instance.patientId,
};

UpdateAppointmentRequest _$UpdateAppointmentRequestFromJson(
  Map<String, dynamic> json,
) => UpdateAppointmentRequest(location: json['location'] as String);

Map<String, dynamic> _$UpdateAppointmentRequestToJson(
  UpdateAppointmentRequest instance,
) => <String, dynamic>{'location': instance.location};

AppointmentResponseData _$AppointmentResponseDataFromJson(
  Map<String, dynamic> json,
) => AppointmentResponseData(
  bookingId: json['bookingId'] as String,
  status: json['status'] as String,
  consultationDateTime: json['consultationDateTime'] as String?,
  location: json['location'],
  locationId: json['locationId'] as String?,
  program: json['program'],
  programId: json['programId'] as String?,
  patientId: json['patientId'] as String?,
);

Map<String, dynamic> _$AppointmentResponseDataToJson(
  AppointmentResponseData instance,
) => <String, dynamic>{
  'bookingId': instance.bookingId,
  'status': instance.status,
  'consultationDateTime': instance.consultationDateTime,
  'location': instance.location,
  'locationId': instance.locationId,
  'program': instance.program,
  'programId': instance.programId,
  'patientId': instance.patientId,
};

AppointmentLocation _$AppointmentLocationFromJson(Map<String, dynamic> json) =>
    AppointmentLocation(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
    );

Map<String, dynamic> _$AppointmentLocationToJson(
  AppointmentLocation instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'city': instance.city,
};

AppointmentProgram _$AppointmentProgramFromJson(Map<String, dynamic> json) =>
    AppointmentProgram(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$AppointmentProgramToJson(AppointmentProgram instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
    };

CancelAppointmentResponseData _$CancelAppointmentResponseDataFromJson(
  Map<String, dynamic> json,
) => CancelAppointmentResponseData(bookingId: json['bookingId'] as String);

Map<String, dynamic> _$CancelAppointmentResponseDataToJson(
  CancelAppointmentResponseData instance,
) => <String, dynamic>{'bookingId': instance.bookingId};

TimeSlot _$TimeSlotFromJson(Map<String, dynamic> json) => TimeSlot(
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  displayTime: json['displayTime'] as String,
);

Map<String, dynamic> _$TimeSlotToJson(TimeSlot instance) => <String, dynamic>{
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'displayTime': instance.displayTime,
};
