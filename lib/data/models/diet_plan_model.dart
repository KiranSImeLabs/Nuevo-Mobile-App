import 'package:json_annotation/json_annotation.dart';

part 'diet_plan_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.none)
class DietPlanModel {
  final String? id;
  @JsonKey(name: 'userId')
  final String? userId; // API sends camelCase
  final String? title;
  final String? description;
  @JsonKey(fromJson: _stringToInt)
  final int? calories;
  @JsonKey(fromJson: _stringToInt)
  final int? protein;
  @JsonKey(name: 'waterGlasses', fromJson: _stringToInt)
  final int? waterGlasses;
  
  final List<MealModel>? meals;
  @JsonKey(name: 'keyGuidance')
  final List<GuidanceModel>? keyGuidance;

  DietPlanModel({
    this.id,
    this.userId,
    this.title,
    this.description,
    this.calories,
    this.protein,
    this.waterGlasses,
    this.meals,
    this.keyGuidance,
  });

  factory DietPlanModel.fromJson(Map<String, dynamic> json) =>
      _$DietPlanModelFromJson(json);

  Map<String, dynamic> toJson() => _$DietPlanModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none) // The sample keys are camelCase mostly
class GuidanceModel {
  final String? title;
  final String? subtitle;
  final String? iconUrl;
  final String? iconMimeType;
  final GuidanceInfoModel? whyThisMatters;
  final List<GuidanceInfoModel>? howToAchieve;

  GuidanceModel({
    this.title,
    this.subtitle,
    this.iconUrl,
    this.iconMimeType,
    this.whyThisMatters,
    this.howToAchieve,
  });

  factory GuidanceModel.fromJson(Map<String, dynamic> json) =>
      _$GuidanceModelFromJson(json);

  Map<String, dynamic> toJson() => _$GuidanceModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.none)
class GuidanceInfoModel {
  final String? title;
  final String? text;

  GuidanceInfoModel({
    this.title,
    this.text,
  });

  factory GuidanceInfoModel.fromJson(Map<String, dynamic> json) =>
      _$GuidanceInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$GuidanceInfoModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MealModel {
  final String? id;
  final String? name;
  final String? description;
  final String? time;
  
  @JsonKey(fromJson: _stringToInt)
  final int? calories;
  
  final List<String>? foods;
  final String? imageUrl;

  MealModel({
    this.id,
    this.name,
    this.description,
    this.time,
    this.calories,
    this.foods,
    this.imageUrl,
  });

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealModelToJson(this);
}

// Helper to handle String or Int for calories
int? _stringToInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}
