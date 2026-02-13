// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      durationMinutes: (json['duration_minutes'] as num).toInt(),
      imageUrl: json['image_url'] as String?,
      isCompleted: json['is_completed'] as bool,
      type: json['type'] as String,
      dueDate: json['due_date'] as String?,
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'duration_minutes': instance.durationMinutes,
      'image_url': instance.imageUrl,
      'is_completed': instance.isCompleted,
      'type': instance.type,
      'due_date': instance.dueDate,
      'completed_at': instance.completedAt,
    };
