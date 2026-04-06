// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionProgressModel _$SessionProgressModelFromJson(
  Map<String, dynamic> json,
) => SessionProgressModel(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  sessionId: json['sessionId'] as String?,
  startTime: json['startTime'] as String?,
  endTime: json['endTime'] as String?,
  status: json['status'] as String?,
  currentStepIndex: (json['currentStepIndex'] as num?)?.toInt(),
  currentTimeInStep: (json['currentTimeInStep'] as num?)?.toInt(),
  heartRate: (json['heartRate'] as num?)?.toInt(),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$SessionProgressModelToJson(
  SessionProgressModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'sessionId': instance.sessionId,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'status': instance.status,
  'currentStepIndex': instance.currentStepIndex,
  'currentTimeInStep': instance.currentTimeInStep,
  'heartRate': instance.heartRate,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
