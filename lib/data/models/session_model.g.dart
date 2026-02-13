// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionModel _$SessionModelFromJson(Map<String, dynamic> json) => SessionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      scheduledTime: json['scheduled_time'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      professionalName: json['professional_name'] as String?,
      notes: json['notes'] as String?,
      isCompleted: json['is_completed'] as bool,
    );

Map<String, dynamic> _$SessionModelToJson(SessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'scheduled_time': instance.scheduledTime,
      'duration_minutes': instance.durationMinutes,
      'professional_name': instance.professionalName,
      'notes': instance.notes,
      'is_completed': instance.isCompleted,
    };
