// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionModel _$SubscriptionModelFromJson(Map<String, dynamic> json) =>
    SubscriptionModel(
      id: json['id'] as String,
      planName: json['plan_name'] as String,
      status: json['status'] as String,
      startDate: json['start_date'] as String?,
      expiryDate: json['expiry_date'] as String?,
      features: (json['features'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$SubscriptionModelToJson(SubscriptionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plan_name': instance.planName,
      'status': instance.status,
      'start_date': instance.startDate,
      'expiry_date': instance.expiryDate,
      'features': instance.features,
      'description': instance.description,
    };
