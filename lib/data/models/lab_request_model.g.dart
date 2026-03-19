// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabRequestResponse _$LabRequestResponseFromJson(Map<String, dynamic> json) =>
    LabRequestResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LabRequestData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LabRequestResponseToJson(LabRequestResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

LabRequestData _$LabRequestDataFromJson(Map<String, dynamic> json) =>
    LabRequestData(
      id: json['id'] as String?,
      status: json['status'] as String?,
      notes: json['notes'] as String?,
      reportsCount: (json['reportsCount'] as num?)?.toInt(),
      labReports: json['labReports'] as List<dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$LabRequestDataToJson(LabRequestData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'notes': instance.notes,
      'reportsCount': instance.reportsCount,
      'labReports': instance.labReports,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

LabRequestListResponseData _$LabRequestListResponseDataFromJson(
  Map<String, dynamic> json,
) => LabRequestListResponseData(
  requests: (json['requests'] as List<dynamic>?)
      ?.map((e) => LabRequestData.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$LabRequestListResponseDataToJson(
  LabRequestListResponseData instance,
) => <String, dynamic>{'requests': instance.requests, 'count': instance.count};

CreateLabRequest _$CreateLabRequestFromJson(Map<String, dynamic> json) =>
    CreateLabRequest(notes: json['notes'] as String);

Map<String, dynamic> _$CreateLabRequestToJson(CreateLabRequest instance) =>
    <String, dynamic>{'notes': instance.notes};
