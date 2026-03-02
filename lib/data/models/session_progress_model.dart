import 'package:json_annotation/json_annotation.dart';

part 'session_progress_model.g.dart';

@JsonSerializable()
class SessionProgressModel {
  final String? id;
  final String? userId;
  final String? sessionId;
  final String? startTime;
  final String? endTime;
  final String? status;
  final int? currentStepIndex;
  final int? currentTimeInStep;
  final int? heartRate;
  final String? createdAt;
  final String? updatedAt;

  SessionProgressModel({
    this.id,
    this.userId,
    this.sessionId,
    this.startTime,
    this.endTime,
    this.status,
    this.currentStepIndex,
    this.currentTimeInStep,
    this.heartRate,
    this.createdAt,
    this.updatedAt,
  });

  factory SessionProgressModel.fromJson(Map<String, dynamic> json) =>
      _$SessionProgressModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionProgressModelToJson(this);
}
