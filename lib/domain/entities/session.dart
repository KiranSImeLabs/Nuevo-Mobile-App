import 'package:equatable/equatable.dart';

/// Session Type Enum
enum SessionType {
  dietitian,
  doctor,
  therapist,
  trainer,
  general,
}

/// Session Entity (Domain Layer)
/// Represents a scheduled session with a healthcare professional
class Session extends Equatable {
  final String id;
  final String title;
  final SessionType type;
  final DateTime scheduledTime;
  final int durationMinutes;
  final String? professionalName;
  final String? notes;
  final bool isCompleted;
  
  const Session({
    required this.id,
    required this.title,
    required this.type,
    required this.scheduledTime,
    required this.durationMinutes,
    this.professionalName,
    this.notes,
    required this.isCompleted,
  });
  
  
  @override
  List<Object?> get props => [
    id,
    title,
    type,
    scheduledTime,
    durationMinutes,
    professionalName,
    notes,
    isCompleted,
  ];

  factory Session.fromAppointmentDetail(dynamic detail) {
    // We use dynamic to avoid circular dependency if models import entities
    // or vice versa in a way that's hard to manage here. 
    // But since this is the entity, we'll assume it's passed correctly.
    final DateTime scheduled = detail.consultationDateTime != null 
        ? DateTime.parse(detail.consultationDateTime!).toUtc().add(const Duration(hours: 10))
        : DateTime.now();

    return Session(
      id: detail.id,
      title: detail.program?.name ?? detail.bookingType ?? 'Appointment',
      type: _mapBookingTypeToSessionType(detail.bookingType),
      scheduledTime: scheduled,
      durationMinutes: int.tryParse(detail.duration ?? '30') ?? 30,
      professionalName: detail.member?.fullName ?? detail.user?.fullName,
      notes: detail.notes,
      isCompleted: detail.period == 'past' || detail.status == 'COMPLETED',
    );
  }

  static SessionType _mapBookingTypeToSessionType(String? type) {
    switch (type) {
      case 'DIETITIAN':
        return SessionType.dietitian;
      case 'DOCTOR_APPOINTMENT':
      case 'INITIAL_CONSULTATION':
        return SessionType.doctor;
      case 'THERAPIST':
        return SessionType.therapist;
      case 'TRAINER':
        return SessionType.trainer;
      default:
        return SessionType.general;
    }
  }
}
