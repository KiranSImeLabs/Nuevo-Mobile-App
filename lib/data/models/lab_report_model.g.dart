// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lab_report_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabReportResponse _$LabReportResponseFromJson(Map<String, dynamic> json) =>
    LabReportResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LabReportListData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LabReportResponseToJson(LabReportResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

LabReportListData _$LabReportListDataFromJson(Map<String, dynamic> json) =>
    LabReportListData(
      reports: (json['reports'] as List<dynamic>?)
          ?.map((e) => LabReportModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LabReportListDataToJson(LabReportListData instance) =>
    <String, dynamic>{
      'reports': instance.reports,
      'count': instance.count,
    };

LabReportModel _$LabReportModelFromJson(Map<String, dynamic> json) =>
    LabReportModel(
      id: json['id'] as String?,
      testType: json['testType'] as String?,
      testDate: json['testDate'] as String?,
      reportUrl: json['reportUrl'] as String?,
      parametersCount: (json['parametersCount'] as num?)?.toInt(),
      uploadedBy: json['uploadedBy'] == null
          ? null
          : LabReportUploader.fromJson(
              json['uploadedBy'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$LabReportModelToJson(LabReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testType': instance.testType,
      'testDate': instance.testDate,
      'reportUrl': instance.reportUrl,
      'parametersCount': instance.parametersCount,
      'uploadedBy': instance.uploadedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

LabReportUploader _$LabReportUploaderFromJson(Map<String, dynamic> json) =>
    LabReportUploader(
      id: json['id'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$LabReportUploaderToJson(LabReportUploader instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
