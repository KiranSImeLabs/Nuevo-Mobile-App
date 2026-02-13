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
}
