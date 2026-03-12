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

LabReportComparisonResponse _$LabReportComparisonResponseFromJson(
        Map<String, dynamic> json) =>
    LabReportComparisonResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] == null
          ? null
          : LabReportDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LabReportComparisonResponseToJson(
        LabReportComparisonResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'data': instance.data,
    };

LabReportDetailData _$LabReportDetailDataFromJson(Map<String, dynamic> json) =>
    LabReportDetailData(
      id: json['id'] as String?,
      testType: json['testType'] as String?,
      testDate: json['testDate'] as String?,
      reportUrl: json['reportUrl'] as String?,
      parameters: json['parameters'] as List<dynamic>?,
      notes: json['notes'] as String?,
      user: json['user'] as Map<String, dynamic>?,
      uploadedBy: json['uploadedBy'] as Map<String, dynamic>?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      comparison: json['comparison'] == null
          ? null
          : LabReportComparisonData.fromJson(
              json['comparison'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LabReportDetailDataToJson(
        LabReportDetailData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testType': instance.testType,
      'testDate': instance.testDate,
      'reportUrl': instance.reportUrl,
      'parameters': instance.parameters,
      'notes': instance.notes,
      'user': instance.user,
      'uploadedBy': instance.uploadedBy,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'comparison': instance.comparison,
    };

LabReportComparisonData _$LabReportComparisonDataFromJson(
        Map<String, dynamic> json) =>
    LabReportComparisonData(
      currentReport: json['currentReport'] == null
          ? null
          : ReportSummary.fromJson(
              json['currentReport'] as Map<String, dynamic>),
      previousReport: json['previousReport'] == null
          ? null
          : ReportSummary.fromJson(
              json['previousReport'] as Map<String, dynamic>),
      timeBetweenReports: json['timeBetweenReports'] as String?,
      overallProgress: json['overallProgress'] == null
          ? null
          : OverallProgress.fromJson(
              json['overallProgress'] as Map<String, dynamic>),
      parameterComparisons: (json['parameterComparisons'] as List<dynamic>?)
          ?.map((e) => ParameterComparison.fromJson(e as Map<String, dynamic>))
          .toList(),
      insights: (json['insights'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$LabReportComparisonDataToJson(
        LabReportComparisonData instance) =>
    <String, dynamic>{
      'currentReport': instance.currentReport,
      'previousReport': instance.previousReport,
      'timeBetweenReports': instance.timeBetweenReports,
      'overallProgress': instance.overallProgress,
      'parameterComparisons': instance.parameterComparisons,
      'insights': instance.insights,
    };

ReportSummary _$ReportSummaryFromJson(Map<String, dynamic> json) =>
    ReportSummary(
      id: json['id'] as String?,
      testDate: json['testDate'] as String?,
      testType: json['testType'] as String?,
    );

Map<String, dynamic> _$ReportSummaryToJson(ReportSummary instance) =>
    <String, dynamic>{
      'id': instance.id,
      'testDate': instance.testDate,
      'testType': instance.testType,
    };

OverallProgress _$OverallProgressFromJson(Map<String, dynamic> json) =>
    OverallProgress(
      improved: (json['improved'] as num?)?.toInt(),
      stable: (json['stable'] as num?)?.toInt(),
      declined: (json['declined'] as num?)?.toInt(),
      percentageImproved: json['percentageImproved'] as num?,
    );

Map<String, dynamic> _$OverallProgressToJson(OverallProgress instance) =>
    <String, dynamic>{
      'improved': instance.improved,
      'stable': instance.stable,
      'declined': instance.declined,
      'percentageImproved': instance.percentageImproved,
    };

ParameterComparison _$ParameterComparisonFromJson(Map<String, dynamic> json) =>
    ParameterComparison(
      parameterName: json['parameterName'] as String?,
      current: json['current'] == null
          ? null
          : ParameterData.fromJson(json['current'] as Map<String, dynamic>),
      previous: json['previous'] == null
          ? null
          : ParameterData.fromJson(json['previous'] as Map<String, dynamic>),
      change: json['change'] == null
          ? null
          : ParameterChange.fromJson(json['change'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParameterComparisonToJson(
        ParameterComparison instance) =>
    <String, dynamic>{
      'parameterName': instance.parameterName,
      'current': instance.current,
      'previous': instance.previous,
      'change': instance.change,
    };

ParameterData _$ParameterDataFromJson(Map<String, dynamic> json) =>
    ParameterData(
      value: json['value'] as num?,
      unit: json['unit'] as String?,
      status: json['status'] as String?,
      referenceRange: json['referenceRange'] == null
          ? null
          : ReferenceRange.fromJson(
              json['referenceRange'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ParameterDataToJson(ParameterData instance) =>
    <String, dynamic>{
      'value': instance.value,
      'unit': instance.unit,
      'status': instance.status,
      'referenceRange': instance.referenceRange,
    };

ParameterChange _$ParameterChangeFromJson(Map<String, dynamic> json) =>
    ParameterChange(
      absolute: json['absolute'] as num?,
      percentage: json['percentage'] as num?,
      trend: json['trend'] as String?,
    );

Map<String, dynamic> _$ParameterChangeToJson(ParameterChange instance) =>
    <String, dynamic>{
      'absolute': instance.absolute,
      'percentage': instance.percentage,
      'trend': instance.trend,
    };

ReferenceRange _$ReferenceRangeFromJson(Map<String, dynamic> json) =>
    ReferenceRange(
      max: json['max'] as num?,
      min: json['min'] as num?,
      optimal:
          (json['optimal'] as List<dynamic>?)?.map((e) => e as num).toList(),
    );

Map<String, dynamic> _$ReferenceRangeToJson(ReferenceRange instance) =>
    <String, dynamic>{
      'max': instance.max,
      'min': instance.min,
      'optimal': instance.optimal,
    };
