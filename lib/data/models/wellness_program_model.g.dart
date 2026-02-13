// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wellness_program_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WellnessProgramModel _$WellnessProgramModelFromJson(
        Map<String, dynamic> json) =>
    WellnessProgramModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      progressPercentage: (json['progress_percentage'] as num).toDouble(),
      habitsCount: (json['habits_count'] as num).toInt(),
      iconUrl: json['icon_url'] as String?,
    );

Map<String, dynamic> _$WellnessProgramModelToJson(
        WellnessProgramModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'progress_percentage': instance.progressPercentage,
      'habits_count': instance.habitsCount,
      'icon_url': instance.iconUrl,
    };

HabitModel _$HabitModelFromJson(Map<String, dynamic> json) => HabitModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      isCompleted: json['is_completed'] as bool,
      completedAt: json['completed_at'] as String?,
    );

Map<String, dynamic> _$HabitModelToJson(HabitModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'is_completed': instance.isCompleted,
      'completed_at': instance.completedAt,
    };
