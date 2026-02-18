import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/preferences.dart';

part 'preferences_model.g.dart';

@JsonSerializable(explicitToJson: true)
class PreferencesModel extends Preferences {
  @override
  final NotificationPreferencesModel notification;
  @override
  final ConsentPreferencesModel consent;

  const PreferencesModel({
    required this.notification,
    required this.consent,
  }) : super(
          notification: notification,
          consent: consent,
        );

  factory PreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$PreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$PreferencesModelToJson(this);

  Preferences toEntity() {
    return Preferences(
      notification: notification.toEntity(),
      consent: consent.toEntity(),
    );
  }

  factory PreferencesModel.fromEntity(Preferences preferences) {
    return PreferencesModel(
      notification:
          NotificationPreferencesModel.fromEntity(preferences.notification),
      consent: ConsentPreferencesModel.fromEntity(preferences.consent),
    );
  }
}

@JsonSerializable()
class NotificationPreferencesModel extends NotificationPreferences {
  @override
  final bool programUpdates;
  @override
  final bool guidanceReminders;
  @override
  final bool appointmentReminders;
  @override
  final bool scheduleUpdates;
  @override
  final bool healthInsights;
  @override
  final bool resultsAvailable;

  const NotificationPreferencesModel({
    this.programUpdates = false,
    this.guidanceReminders = false,
    this.appointmentReminders = false,
    this.scheduleUpdates = false,
    this.healthInsights = false,
    this.resultsAvailable = false,
  }) : super(
          programUpdates: programUpdates,
          guidanceReminders: guidanceReminders,
          appointmentReminders: appointmentReminders,
          scheduleUpdates: scheduleUpdates,
          healthInsights: healthInsights,
          resultsAvailable: resultsAvailable,
        );

  factory NotificationPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPreferencesModelToJson(this);

  NotificationPreferences toEntity() {
    return NotificationPreferences(
      programUpdates: programUpdates,
      guidanceReminders: guidanceReminders,
      appointmentReminders: appointmentReminders,
      scheduleUpdates: scheduleUpdates,
      healthInsights: healthInsights,
      resultsAvailable: resultsAvailable,
    );
  }

  factory NotificationPreferencesModel.fromEntity(
      NotificationPreferences preferences) {
    return NotificationPreferencesModel(
      programUpdates: preferences.programUpdates,
      guidanceReminders: preferences.guidanceReminders,
      appointmentReminders: preferences.appointmentReminders,
      scheduleUpdates: preferences.scheduleUpdates,
      healthInsights: preferences.healthInsights,
      resultsAvailable: preferences.resultsAvailable,
    );
  }
}

@JsonSerializable()
class ConsentPreferencesModel extends ConsentPreferences {
  @override
  final bool dataSharingConsent;
  @override
  final bool researchParticipation;
  @override
  final bool communicationPreferences;

  const ConsentPreferencesModel({
    this.dataSharingConsent = false,
    this.researchParticipation = false,
    this.communicationPreferences = false,
  }) : super(
          dataSharingConsent: dataSharingConsent,
          researchParticipation: researchParticipation,
          communicationPreferences: communicationPreferences,
        );

  factory ConsentPreferencesModel.fromJson(Map<String, dynamic> json) =>
      _$ConsentPreferencesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ConsentPreferencesModelToJson(this);

  ConsentPreferences toEntity() {
    return ConsentPreferences(
      dataSharingConsent: dataSharingConsent,
      researchParticipation: researchParticipation,
      communicationPreferences: communicationPreferences,
    );
  }

  factory ConsentPreferencesModel.fromEntity(ConsentPreferences preferences) {
    return ConsentPreferencesModel(
      dataSharingConsent: preferences.dataSharingConsent,
      researchParticipation: preferences.researchParticipation,
      communicationPreferences: preferences.communicationPreferences,
    );
  }
}
