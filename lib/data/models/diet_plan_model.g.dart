// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diet_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DietPlanModel _$DietPlanModelFromJson(Map<String, dynamic> json) =>
    DietPlanModel(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      calories: _stringToInt(json['calories']),
      protein: _stringToInt(json['protein']),
      waterGlasses: _stringToInt(json['waterGlasses']),
      meals: (json['meals'] as List<dynamic>?)
          ?.map((e) => MealModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      keyGuidance: (json['keyGuidance'] as List<dynamic>?)
          ?.map((e) => GuidanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DietPlanModelToJson(DietPlanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'description': instance.description,
      'calories': instance.calories,
      'protein': instance.protein,
      'waterGlasses': instance.waterGlasses,
      'meals': instance.meals,
      'keyGuidance': instance.keyGuidance,
    };

GuidanceModel _$GuidanceModelFromJson(Map<String, dynamic> json) =>
    GuidanceModel(
      title: json['title'] as String?,
      subtitle: json['subtitle'] as String?,
      iconUrl: json['iconUrl'] as String?,
      iconMimeType: json['iconMimeType'] as String?,
      whyThisMatters: json['whyThisMatters'] == null
          ? null
          : GuidanceInfoModel.fromJson(
              json['whyThisMatters'] as Map<String, dynamic>,
            ),
      howToAchieve: (json['howToAchieve'] as List<dynamic>?)
          ?.map((e) => GuidanceInfoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GuidanceModelToJson(GuidanceModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'subtitle': instance.subtitle,
      'iconUrl': instance.iconUrl,
      'iconMimeType': instance.iconMimeType,
      'whyThisMatters': instance.whyThisMatters,
      'howToAchieve': instance.howToAchieve,
    };

GuidanceInfoModel _$GuidanceInfoModelFromJson(Map<String, dynamic> json) =>
    GuidanceInfoModel(
      title: json['title'] as String?,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$GuidanceInfoModelToJson(GuidanceInfoModel instance) =>
    <String, dynamic>{'title': instance.title, 'text': instance.text};

MealModel _$MealModelFromJson(Map<String, dynamic> json) => MealModel(
  id: json['id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  time: json['time'] as String?,
  calories: _stringToInt(json['calories']),
  foods: (json['foods'] as List<dynamic>?)?.map((e) => e as String).toList(),
  imageUrl: json['image_url'] as String?,
);

Map<String, dynamic> _$MealModelToJson(MealModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'time': instance.time,
  'calories': instance.calories,
  'foods': instance.foods,
  'image_url': instance.imageUrl,
};
