// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferencesModel _$PreferencesModelFromJson(Map<String, dynamic> json) =>
    PreferencesModel(
      notification: NotificationPreferencesModel.fromJson(
        json['notification'] as Map<String, dynamic>,
      ),
      consent: ConsentPreferencesModel.fromJson(
        json['consent'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$PreferencesModelToJson(PreferencesModel instance) =>
    <String, dynamic>{
      'notification': instance.notification.toJson(),
      'consent': instance.consent.toJson(),
    };

NotificationPreferencesModel _$NotificationPreferencesModelFromJson(
  Map<String, dynamic> json,
) => NotificationPreferencesModel(
  programUpdates: json['programUpdates'] as bool? ?? false,
  guidanceReminders: json['guidanceReminders'] as bool? ?? false,
  appointmentReminders: json['appointmentReminders'] as bool? ?? false,
  scheduleUpdates: json['scheduleUpdates'] as bool? ?? false,
  healthInsights: json['healthInsights'] as bool? ?? false,
  resultsAvailable: json['resultsAvailable'] as bool? ?? false,
);

Map<String, dynamic> _$NotificationPreferencesModelToJson(
  NotificationPreferencesModel instance,
) => <String, dynamic>{
  'programUpdates': instance.programUpdates,
  'guidanceReminders': instance.guidanceReminders,
  'appointmentReminders': instance.appointmentReminders,
  'scheduleUpdates': instance.scheduleUpdates,
  'healthInsights': instance.healthInsights,
  'resultsAvailable': instance.resultsAvailable,
};

ConsentPreferencesModel _$ConsentPreferencesModelFromJson(
  Map<String, dynamic> json,
) => ConsentPreferencesModel(
  dataSharingConsent: json['dataSharingConsent'] as bool? ?? false,
  researchParticipation: json['researchParticipation'] as bool? ?? false,
  communicationPreferences: json['communicationPreferences'] as bool? ?? false,
);

Map<String, dynamic> _$ConsentPreferencesModelToJson(
  ConsentPreferencesModel instance,
) => <String, dynamic>{
  'dataSharingConsent': instance.dataSharingConsent,
  'researchParticipation': instance.researchParticipation,
  'communicationPreferences': instance.communicationPreferences,
};
