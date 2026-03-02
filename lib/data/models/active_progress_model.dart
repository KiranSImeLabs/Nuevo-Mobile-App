import 'package:json_annotation/json_annotation.dart';
import 'daily_exercise_model.dart';

part 'active_progress_model.g.dart';

@JsonSerializable()
class ActiveProgressModel {
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
  final ActiveSessionDataModel? session;

  ActiveProgressModel({
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
    this.session,
  });

  factory ActiveProgressModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveProgressModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveProgressModelToJson(this);
}

@JsonSerializable()
class ActiveSessionDataModel {
  final String? id;
  final String? title;
  final String? imageUrl;

  ActiveSessionDataModel({
    this.id,
    this.title,
    this.imageUrl,
  });

  factory ActiveSessionDataModel.fromJson(Map<String, dynamic> json) =>
      _$ActiveSessionDataModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActiveSessionDataModelToJson(this);
}
