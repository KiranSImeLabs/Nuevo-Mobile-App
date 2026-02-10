// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      subscription: json['subscription'] == null
          ? null
          : SubscriptionModel.fromJson(
              json['subscription'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
      lastLoginAt: json['last_login_at'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
      'profile_image_url': instance.profileImageUrl,
      'subscription': instance.subscription,
      'created_at': instance.createdAt,
      'last_login_at': instance.lastLoginAt,
    };
