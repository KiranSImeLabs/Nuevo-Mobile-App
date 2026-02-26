// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_exercise_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DailyExerciseModel _$DailyExerciseModelFromJson(Map<String, dynamic> json) =>
    DailyExerciseModel(
      dayNumber: (json['dayNumber'] as num?)?.toInt(),
      scheduledDate: json['scheduledDate'] as String?,
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      sessionId: json['sessionId'] as String?,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      session: json['session'] == null
          ? null
          : GuidedSessionModel.fromJson(
              json['session'] as Map<String, dynamic>),
      progress: json['progress'],
    );

Map<String, dynamic> _$DailyExerciseModelToJson(DailyExerciseModel instance) =>
    <String, dynamic>{
      'dayNumber': instance.dayNumber,
      'scheduledDate': instance.scheduledDate,
      'id': instance.id,
      'userId': instance.userId,
      'sessionId': instance.sessionId,
      'status': instance.status,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'session': instance.session,
      'progress': instance.progress,
    };

GuidedSessionModel _$GuidedSessionModelFromJson(Map<String, dynamic> json) =>
    GuidedSessionModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      purpose: json['purpose'] as String?,
      intensity: json['intensity'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      steps: (json['steps'] as List<dynamic>?)
          ?.map((e) => ExerciseStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GuidedSessionModelToJson(GuidedSessionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'duration': instance.duration,
      'purpose': instance.purpose,
      'intensity': instance.intensity,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'steps': instance.steps,
    };

ExerciseStepModel _$ExerciseStepModelFromJson(Map<String, dynamic> json) =>
    ExerciseStepModel(
      id: json['id'] as String?,
      sessionId: json['sessionId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      duration: (json['duration'] as num?)?.toInt(),
      videoUrl: json['videoUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      order: (json['order'] as num?)?.toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ExerciseStepModelToJson(ExerciseStepModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sessionId': instance.sessionId,
      'title': instance.title,
      'description': instance.description,
      'duration': instance.duration,
      'videoUrl': instance.videoUrl,
      'audioUrl': instance.audioUrl,
      'order': instance.order,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
