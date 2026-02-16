import 'package:json_annotation/json_annotation.dart';

part 'lab_request_model.g.dart';

@JsonSerializable()
class LabRequestResponse {
  final bool? success;
  final String? message;
  final LabRequestData? data;

  const LabRequestResponse({
    this.success,
    this.message,
    this.data,
  });

  factory LabRequestResponse.fromJson(Map<String, dynamic> json) =>
      _$LabRequestResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LabRequestResponseToJson(this);
}

@JsonSerializable()
class LabRequestData {
  final String? id;
  final String? status;
  final String? notes;
  final int? reportsCount;
  final List<dynamic>? labReports;
  final String? createdAt;
  final String? updatedAt;

  const LabRequestData({
    this.id,
    this.status,
    this.notes,
    this.reportsCount,
    this.labReports,
    this.createdAt,
    this.updatedAt,
  });

  factory LabRequestData.fromJson(Map<String, dynamic> json) =>
      _$LabRequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$LabRequestDataToJson(this);
}

@JsonSerializable()
class LabRequestListResponseData {
  final List<LabRequestData>? requests;
  final int? count;

  const LabRequestListResponseData({
    this.requests,
    this.count,
  });

  factory LabRequestListResponseData.fromJson(Map<String, dynamic> json) =>
      _$LabRequestListResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$LabRequestListResponseDataToJson(this);
}

@JsonSerializable()
class CreateLabRequest {
  final String notes;

  const CreateLabRequest({required this.notes});

  factory CreateLabRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateLabRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateLabRequestToJson(this);
}
