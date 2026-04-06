// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveProgressModel _$ActiveProgressModelFromJson(Map<String, dynamic> json) =>
    ActiveProgressModel(
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
      session: json['session'] == null
          ? null
          : ActiveSessionDataModel.fromJson(
              json['session'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ActiveProgressModelToJson(
  ActiveProgressModel instance,
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
  'session': instance.session,
};

ActiveSessionDataModel _$ActiveSessionDataModelFromJson(
  Map<String, dynamic> json,
) => ActiveSessionDataModel(
  id: json['id'] as String?,
  title: json['title'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$ActiveSessionDataModelToJson(
  ActiveSessionDataModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'imageUrl': instance.imageUrl,
};
