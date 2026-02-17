import 'package:equatable/equatable.dart';

/// Preferences Entity (Domain Layer)
class Preferences extends Equatable {
  final NotificationPreferences notification;
  final ConsentPreferences consent;

  const Preferences({
    required this.notification,
    required this.consent,
  });

  Preferences copyWith({
    NotificationPreferences? notification,
    ConsentPreferences? consent,
  }) {
    return Preferences(
      notification: notification ?? this.notification,
      consent: consent ?? this.consent,
    );
  }

  @override
  List<Object?> get props => [notification, consent];
}

/// Notification Preferences Entity
class NotificationPreferences extends Equatable {
  final bool programUpdates;
  final bool guidanceReminders;
  final bool appointmentReminders;
  final bool scheduleUpdates;
  final bool healthInsights;
  final bool resultsAvailable;

  const NotificationPreferences({
    this.programUpdates = false,
    this.guidanceReminders = false,
    this.appointmentReminders = false,
    this.scheduleUpdates = false,
    this.healthInsights = false,
    this.resultsAvailable = false,
  });

  NotificationPreferences copyWith({
    bool? programUpdates,
    bool? guidanceReminders,
    bool? appointmentReminders,
    bool? scheduleUpdates,
    bool? healthInsights,
    bool? resultsAvailable,
  }) {
    return NotificationPreferences(
      programUpdates: programUpdates ?? this.programUpdates,
      guidanceReminders: guidanceReminders ?? this.guidanceReminders,
      appointmentReminders: appointmentReminders ?? this.appointmentReminders,
      scheduleUpdates: scheduleUpdates ?? this.scheduleUpdates,
      healthInsights: healthInsights ?? this.healthInsights,
      resultsAvailable: resultsAvailable ?? this.resultsAvailable,
    );
  }

  @override
  List<Object?> get props => [
        programUpdates,
        guidanceReminders,
        appointmentReminders,
        scheduleUpdates,
        healthInsights,
        resultsAvailable,
      ];
}

/// Consent Preferences Entity
class ConsentPreferences extends Equatable {
  final bool dataSharingConsent;
  final bool researchParticipation;
  final bool communicationPreferences;

  const ConsentPreferences({
    this.dataSharingConsent = false,
    this.researchParticipation = false,
    this.communicationPreferences = false,
  });

  ConsentPreferences copyWith({
    bool? dataSharingConsent,
    bool? researchParticipation,
    bool? communicationPreferences,
  }) {
    return ConsentPreferences(
      dataSharingConsent: dataSharingConsent ?? this.dataSharingConsent,
      researchParticipation: researchParticipation ?? this.researchParticipation,
      communicationPreferences:
          communicationPreferences ?? this.communicationPreferences,
    );
  }

  @override
  List<Object?> get props => [
        dataSharingConsent,
        researchParticipation,
        communicationPreferences,
      ];
}
