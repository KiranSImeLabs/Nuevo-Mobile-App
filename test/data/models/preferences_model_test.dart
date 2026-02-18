import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuevo_app/data/models/preferences_model.dart';
import 'package:nuevo_app/domain/entities/preferences.dart';

void main() {
  const tNotificationPreferencesModel = NotificationPreferencesModel(
    programUpdates: true,
    guidanceReminders: false,
    appointmentReminders: true,
    scheduleUpdates: false,
    healthInsights: true,
    resultsAvailable: false,
  );

  const tConsentPreferencesModel = ConsentPreferencesModel(
    dataSharingConsent: true,
    researchParticipation: false,
    communicationPreferences: true,
  );

  const tNotificationPreferences = NotificationPreferences(
    programUpdates: true,
    guidanceReminders: false,
    appointmentReminders: true,
    scheduleUpdates: false,
    healthInsights: true,
    resultsAvailable: false,
  );

  const tConsentPreferences = ConsentPreferences(
    dataSharingConsent: true,
    researchParticipation: false,
    communicationPreferences: true,
  );

  const tPreferencesModel = PreferencesModel(
    notification: tNotificationPreferencesModel,
    consent: tConsentPreferencesModel,
  );

  const tPreferences = Preferences(
    notification: tNotificationPreferences,
    consent: tConsentPreferences,
  );

  group('PreferencesModel', () {
    test('should be a subclass of Preferences entity', () async {
      expect(tPreferencesModel, isA<Preferences>());
    });

    group('fromJson', () {
      test('should return a valid model when the JSON is valid', () async {
        // Arrange
        final Map<String, dynamic> jsonMap = {
          "notification": {
            "programUpdates": true,
            "guidanceReminders": false,
            "appointmentReminders": true,
            "scheduleUpdates": false,
            "healthInsights": true,
            "resultsAvailable": false
          },
          "consent": {
            "dataSharingConsent": true,
            "researchParticipation": false,
            "communicationPreferences": true
          }
        };

        // Act
        final result = PreferencesModel.fromJson(jsonMap);

        // Assert
        expect(result, tPreferencesModel);
      });
    });

    group('toJson', () {
      test('should return a JSON map containing the proper data', () async {
        // Act
        final result = tPreferencesModel.toJson();

        // Assert
        final expectedMap = {
          "notification": {
            "programUpdates": true,
            "guidanceReminders": false,
            "appointmentReminders": true,
            "scheduleUpdates": false,
            "healthInsights": true,
            "resultsAvailable": false
          },
          "consent": {
            "dataSharingConsent": true,
            "researchParticipation": false,
            "communicationPreferences": true
          }
        };
        expect(result, expectedMap);
      });
    });

    group('fromEntity', () {
      test('should return a valid model from entity', () async {
        // Act
        final result = PreferencesModel.fromEntity(tPreferences);

        // Assert
        expect(result, tPreferencesModel);
      });
    });

    group('toEntity', () {
      test('should return a valid entity from model', () async {
        // Act
        final result = tPreferencesModel.toEntity();

        // Assert
        expect(result, tPreferences);
      });
    });
  });
}
