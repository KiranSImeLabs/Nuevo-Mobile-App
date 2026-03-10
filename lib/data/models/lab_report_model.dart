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
