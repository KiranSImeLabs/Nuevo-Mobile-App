import 'package:json_annotation/json_annotation.dart';

part 'lab_report_model.g.dart';

@JsonSerializable()
class LabReportResponse {
  final bool? success;
  final String? message;
  final LabReportListData? data;

  const LabReportResponse({
    this.success,
    this.message,
    this.data,
  });

  factory LabReportResponse.fromJson(Map<String, dynamic> json) =>
      _$LabReportResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LabReportResponseToJson(this);
}

@JsonSerializable()
class LabReportListData {
  final List<LabReportModel>? reports;
  final int? count;

  const LabReportListData({
    this.reports,
    this.count,
  });

  factory LabReportListData.fromJson(Map<String, dynamic> json) =>
      _$LabReportListDataFromJson(json);

  Map<String, dynamic> toJson() => _$LabReportListDataToJson(this);
}

@JsonSerializable()
class LabReportModel {
  final String? id;
  final String? testType;
  final String? testDate;
  final String? reportUrl;
  final int? parametersCount;
  final LabReportUploader? uploadedBy;
  final String? createdAt;
  final String? updatedAt;

  const LabReportModel({
    this.id,
    this.testType,
    this.testDate,
    this.reportUrl,
    this.parametersCount,
    this.uploadedBy,
    this.createdAt,
    this.updatedAt,
  });

  factory LabReportModel.fromJson(Map<String, dynamic> json) =>
      _$LabReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$LabReportModelToJson(this);
}

@JsonSerializable()
class LabReportUploader {
  final String? id;
  final String? name;

  const LabReportUploader({
    this.id,
    this.name,
  });

  factory LabReportUploader.fromJson(Map<String, dynamic> json) =>
      _$LabReportUploaderFromJson(json);

  Map<String, dynamic> toJson() => _$LabReportUploaderToJson(this);
}

// ==========================================
// Lab Report Comparison / Details Models
// ==========================================

@JsonSerializable()
class LabReportComparisonResponse {
  final bool? success;
  final String? message;
  final LabReportDetailData? data;

  const LabReportComparisonResponse({
    this.success,
    this.message,
    this.data,
  });

  factory LabReportComparisonResponse.fromJson(Map<String, dynamic> json) =>
      _$LabReportComparisonResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LabReportComparisonResponseToJson(this);
}

@JsonSerializable()
class LabReportDetailData {
  final String? id;
  final String? testType;
  final String? testDate;
  final String? reportUrl;
  final List<dynamic>? parameters; // Note: 'parameters' from JSON, but schema is different. Using dynamic for now or Map if unused in UI
  final String? notes;
  final Map<String, dynamic>? user;
  final Map<String, dynamic>? uploadedBy;
  final String? createdAt;
  final String? updatedAt;
  final LabReportComparisonData? comparison;

  const LabReportDetailData({
    this.id,
    this.testType,
    this.testDate,
    this.reportUrl,
    this.parameters,
    this.notes,
    this.user,
    this.uploadedBy,
    this.createdAt,
    this.updatedAt,
    this.comparison,
  });

  factory LabReportDetailData.fromJson(Map<String, dynamic> json) =>
      _$LabReportDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$LabReportDetailDataToJson(this);
}

@JsonSerializable()
class LabReportComparisonData {
  final ReportSummary? currentReport;
  final ReportSummary? previousReport;
  final String? timeBetweenReports;
  final OverallProgress? overallProgress;
  final List<ParameterComparison>? parameterComparisons;
  final List<String>? insights; // Assuming it's a list of strings based on empty array

  const LabReportComparisonData({
    this.currentReport,
    this.previousReport,
    this.timeBetweenReports,
    this.overallProgress,
    this.parameterComparisons,
    this.insights,
  });

  factory LabReportComparisonData.fromJson(Map<String, dynamic> json) =>
      _$LabReportComparisonDataFromJson(json);

  Map<String, dynamic> toJson() => _$LabReportComparisonDataToJson(this);
}

@JsonSerializable()
class ReportSummary {
  final String? id;
  final String? testDate;
  final String? testType;

  const ReportSummary({
    this.id,
    this.testDate,
    this.testType,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) =>
      _$ReportSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$ReportSummaryToJson(this);
}

@JsonSerializable()
class OverallProgress {
  final int? improved;
  final int? stable;
  final int? declined;
  final num? percentageImproved;

  const OverallProgress({
    this.improved,
    this.stable,
    this.declined,
    this.percentageImproved,
  });

  factory OverallProgress.fromJson(Map<String, dynamic> json) =>
      _$OverallProgressFromJson(json);

  Map<String, dynamic> toJson() => _$OverallProgressToJson(this);
}

@JsonSerializable()
class ParameterComparison {
  final String? parameterName;
  final ParameterData? current;
  final ParameterData? previous;
  final ParameterChange? change;

  const ParameterComparison({
    this.parameterName,
    this.current,
    this.previous,
    this.change,
  });

  factory ParameterComparison.fromJson(Map<String, dynamic> json) =>
      _$ParameterComparisonFromJson(json);

  Map<String, dynamic> toJson() => _$ParameterComparisonToJson(this);
}

@JsonSerializable()
class ParameterData {
  final num? value;
  final String? unit;
  final String? status;
  final ReferenceRange? referenceRange;

  const ParameterData({
    this.value,
    this.unit,
    this.status,
    this.referenceRange,
  });

  factory ParameterData.fromJson(Map<String, dynamic> json) =>
      _$ParameterDataFromJson(json);

  Map<String, dynamic> toJson() => _$ParameterDataToJson(this);
}

@JsonSerializable()
class ParameterChange {
  final num? absolute;
  final num? percentage;
  final String? trend;

  const ParameterChange({
    this.absolute,
    this.percentage,
    this.trend,
  });

  factory ParameterChange.fromJson(Map<String, dynamic> json) =>
      _$ParameterChangeFromJson(json);

  Map<String, dynamic> toJson() => _$ParameterChangeToJson(this);
}

@JsonSerializable()
class ReferenceRange {
  final num? max;
  final num? min;
  final List<num>? optimal;

  const ReferenceRange({
    this.max,
    this.min,
    this.optimal,
  });

  factory ReferenceRange.fromJson(Map<String, dynamic> json) =>
      _$ReferenceRangeFromJson(json);

  Map<String, dynamic> toJson() => _$ReferenceRangeToJson(this);
}
