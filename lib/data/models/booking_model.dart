import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  @JsonKey(name: 'id')
  final String id;
  @JsonKey(name: 'program_id')
  final String? programId;
  @JsonKey(name: 'booking_status')
  final String? status;
  @JsonKey(name: 'consultation_date_time')
  final DateTime? consultationDateTime;
  @JsonKey(name: 'patient_details')
  final PatientDetails? patientDetails;
  
  const BookingModel({
    required this.id,
    this.programId,
    this.status,
    this.consultationDateTime,
    this.patientDetails,
  });
  
  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
      
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}

@JsonSerializable()
class PatientDetails {
  @JsonKey(name: 'first_name')
  final String? firstName;
  @JsonKey(name: 'last_name')
  final String? lastName;
  final String? email;
  @JsonKey(name: 'mobile_phone')
  final String? mobilePhone;
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth; // Should be DateTime but using String for now as per Postman example "1985-06-15"
  final String? address;
  @JsonKey(name: 'consent_given')
  final bool? consentGiven;
  @JsonKey(name: 'main_goal')
  final String? mainGoal;
  @JsonKey(name: 'referral_source')
  final String? referralSource;
  @JsonKey(name: 'health_context')
  final String? healthContext;
  
  const PatientDetails({
    this.firstName,
    this.lastName,
    this.email,
    this.mobilePhone,
    this.dateOfBirth,
    this.address,
    this.consentGiven,
    this.mainGoal,
    this.referralSource,
    this.healthContext,
  });
  
  factory PatientDetails.fromJson(Map<String, dynamic> json) =>
      _$PatientDetailsFromJson(json);
      
  Map<String, dynamic> toJson() => _$PatientDetailsToJson(this);
}

// Request Models for Booking Flow

@JsonSerializable()
class CreateBookingRequest {
  // Empty body for draft creation
  const CreateBookingRequest();
    
    factory CreateBookingRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateBookingRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$CreateBookingRequestToJson(this);
}

@JsonSerializable()
class UpdateBookingProgramRequest {
  @JsonKey(name: 'programId')
  final String programId;
  
  const UpdateBookingProgramRequest({
    required this.programId,
  });
  
  factory UpdateBookingProgramRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingProgramRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$UpdateBookingProgramRequestToJson(this);
}

@JsonSerializable()
class UpdatePatientDetailsRequest {
   @JsonKey(name: 'programId')
  final String programId; // Seems redundant in Postman example but included
  @JsonKey(name: 'patientDetails')
  final PatientDetails patientDetails;
  
  const UpdatePatientDetailsRequest({
    required this.programId,
    required this.patientDetails,
  });
  
  factory UpdatePatientDetailsRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdatePatientDetailsRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$UpdatePatientDetailsRequestToJson(this);
}

@JsonSerializable()
class UpdateBookingSlotRequest {
  @JsonKey(name: 'consultationDateTime')
  final String consultationDateTime;
  
  const UpdateBookingSlotRequest({
    required this.consultationDateTime,
  });
  
  factory UpdateBookingSlotRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingSlotRequestFromJson(json);
      
  Map<String, dynamic> toJson() => _$UpdateBookingSlotRequestToJson(this);
}
