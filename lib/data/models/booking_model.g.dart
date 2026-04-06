// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
  id: json['id'] as String,
  programId: json['program_id'] as String?,
  status: json['booking_status'] as String?,
  consultationDateTime: json['consultation_date_time'] == null
      ? null
      : DateTime.parse(json['consultation_date_time'] as String),
  patientDetails: json['patient_details'] == null
      ? null
      : PatientDetails.fromJson(
          json['patient_details'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$BookingModelToJson(
  BookingModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'program_id': instance.programId,
  'booking_status': instance.status,
  'consultation_date_time': instance.consultationDateTime?.toIso8601String(),
  'patient_details': instance.patientDetails,
};

PatientDetails _$PatientDetailsFromJson(Map<String, dynamic> json) =>
    PatientDetails(
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String?,
      mobilePhone: json['mobile_phone'] as String?,
      dateOfBirth: json['date_of_birth'] as String?,
      address: json['address'] as String?,
      consentGiven: json['consent_given'] as bool?,
      mainGoal: json['main_goal'] as String?,
      referralSource: json['referral_source'] as String?,
      healthContext: json['health_context'] as String?,
    );

Map<String, dynamic> _$PatientDetailsToJson(PatientDetails instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'mobile_phone': instance.mobilePhone,
      'date_of_birth': instance.dateOfBirth,
      'address': instance.address,
      'consent_given': instance.consentGiven,
      'main_goal': instance.mainGoal,
      'referral_source': instance.referralSource,
      'health_context': instance.healthContext,
    };

CreateBookingRequest _$CreateBookingRequestFromJson(
  Map<String, dynamic> json,
) => CreateBookingRequest();

Map<String, dynamic> _$CreateBookingRequestToJson(
  CreateBookingRequest instance,
) => <String, dynamic>{};

UpdateBookingProgramRequest _$UpdateBookingProgramRequestFromJson(
  Map<String, dynamic> json,
) => UpdateBookingProgramRequest(programId: json['programId'] as String);

Map<String, dynamic> _$UpdateBookingProgramRequestToJson(
  UpdateBookingProgramRequest instance,
) => <String, dynamic>{'programId': instance.programId};

UpdatePatientDetailsRequest _$UpdatePatientDetailsRequestFromJson(
  Map<String, dynamic> json,
) => UpdatePatientDetailsRequest(
  programId: json['programId'] as String,
  patientDetails: PatientDetails.fromJson(
    json['patientDetails'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UpdatePatientDetailsRequestToJson(
  UpdatePatientDetailsRequest instance,
) => <String, dynamic>{
  'programId': instance.programId,
  'patientDetails': instance.patientDetails,
};

UpdateBookingSlotRequest _$UpdateBookingSlotRequestFromJson(
  Map<String, dynamic> json,
) => UpdateBookingSlotRequest(
  consultationDateTime: json['consultationDateTime'] as String,
);

Map<String, dynamic> _$UpdateBookingSlotRequestToJson(
  UpdateBookingSlotRequest instance,
) => <String, dynamic>{'consultationDateTime': instance.consultationDateTime};
