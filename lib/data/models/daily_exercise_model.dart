import 'package:json_annotation/json_annotation.dart';

part 'daily_exercise_model.g.dart';

@JsonSerializable()
class DailyExerciseModel {
  final int? dayNumber;
  final String? scheduledDate;
  final String? id;
  final String? userId;
  final String? sessionId;
  final String? status;
  final String? createdAt;
  final String? updatedAt;
  final GuidedSessionModel? session;
  final dynamic progress;

  DailyExerciseModel({
    this.dayNumber,
    this.scheduledDate,
    this.id,
    this.userId,
    this.sessionId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.session,
    this.progress,
  });

  factory DailyExerciseModel.fromJson(Map<String, dynamic> json) =>
      _$DailyExerciseModelFromJson(json);
  Map<String, dynamic> toJson() => _$DailyExerciseModelToJson(this);
}

@JsonSerializable()
class GuidedSessionModel {
  final String? id;
  final String? userId;
  final String? title;
  final String? description;
  final int? duration;
  final String? purpose;
  final String? intensity;
  final String? imageUrl;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final List<ExerciseStepModel>? steps;

  GuidedSessionModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.duration,
    this.purpose,
    this.intensity,
    this.imageUrl,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.steps,
  });

  factory GuidedSessionModel.fromJson(Map<String, dynamic> json) =>
      _$GuidedSessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$GuidedSessionModelToJson(this);
}

@JsonSerializable()
class ExerciseStepModel {
  final String? id;
  final String? sessionId;
  final String? title;
  final String? description;
  final int? duration;
  final String? videoUrl;
  final String? audioUrl;
  final String? imageUrl;
  final int? order;
  final String? createdAt;
  final String? updatedAt;
  final List<SubtitleModel>? subtitles;

  ExerciseStepModel({
    this.id,
    this.sessionId,
    this.title,
    this.description,
    this.duration,
    this.videoUrl,
    this.audioUrl,
    this.imageUrl,
    this.order,
    this.createdAt,
    this.updatedAt,
    this.subtitles,
  });

  factory ExerciseStepModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseStepModelFromJson(json);
  Map<String, dynamic> toJson() => _$ExerciseStepModelToJson(this);
}

@JsonSerializable()
class SubtitleModel {
  final int? order;
  final int? startTime;
  final int? endTime;
  final String? subtitle;
  final String? description;

  SubtitleModel({
    this.order,
    this.startTime,
    this.endTime,
    this.subtitle,
    this.description,
  });

  factory SubtitleModel.fromJson(Map<String, dynamic> json) =>
      _$SubtitleModelFromJson(json);
  Map<String, dynamic> toJson() => _$SubtitleModelToJson(this);
}
