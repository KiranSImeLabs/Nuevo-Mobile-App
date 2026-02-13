import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/session.dart';

part 'session_model.g.dart';

/// Session Model (Data Layer)
@JsonSerializable()
class SessionModel {
  final String id;
  final String title;
  final String type;
  @JsonKey(name: 'scheduled_time')
  final String scheduledTime;
  @JsonKey(name: 'duration_minutes')
  final int durationMinutes;
  @JsonKey(name: 'professional_name')
  final String? professionalName;
  final String? notes;
  @JsonKey(name: 'is_completed')
  final bool isCompleted;
  
  const SessionModel({
    required this.id,
    required this.title,
    required this.type,
    required this.scheduledTime,
    required this.durationMinutes,
    this.professionalName,
    this.notes,
    required this.isCompleted,
  });
  
  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
  
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
  
  Session toEntity() {
    return Session(
      id: id,
      title: title,
      type: _parseSessionType(type),
      scheduledTime: DateTime.parse(scheduledTime),
      durationMinutes: durationMinutes,
      professionalName: professionalName,
      notes: notes,
      isCompleted: isCompleted,
    );
  }
  
  factory SessionModel.fromEntity(Session entity) {
    return SessionModel(
      id: entity.id,
      title: entity.title,
      type: entity.type.name,
      scheduledTime: entity.scheduledTime.toIso8601String(),
      durationMinutes: entity.durationMinutes,
      professionalName: entity.professionalName,
      notes: entity.notes,
      isCompleted: entity.isCompleted,
    );
  }
  
  static SessionType _parseSessionType(String type) {
    switch (type.toLowerCase()) {
      case 'dietitian':
        return SessionType.dietitian;
      case 'doctor':
        return SessionType.doctor;
      case 'therapist':
        return SessionType.therapist;
      case 'trainer':
        return SessionType.trainer;
      default:
        return SessionType.general;
    }
  }
}
