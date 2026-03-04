import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/preferences.dart';
import 'package:nuevo_app/domain/usecases/user/update_preferences_usecase.dart';

import 'get_preferences_usecase_test.mocks.dart';

void main() {
  late UpdatePreferencesUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = UpdatePreferencesUseCase(mockUserRepository);
  });

  const tPreferences = Preferences(
    notification: NotificationPreferences(
      programUpdates: true,
      guidanceReminders: false,
      appointmentReminders: true,
      scheduleUpdates: false,
      healthInsights: true,
      resultsAvailable: false,
    ),
    consent: ConsentPreferences(
      dataSharingConsent: true,
      researchParticipation: false,
      communicationPreferences: true,
    ),
  );

  test('should update preferences via the repository', () async {
    // arrange
    when(mockUserRepository.updatePreferences(any))
        .thenAnswer((_) async => const Right(tPreferences));

    // act
    final result = await usecase(tPreferences);

    // assert
    expect(result, const Right(tPreferences));
    verify(mockUserRepository.updatePreferences(tPreferences));
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return a failure when the update is unsuccessful', () async {
    // arrange
    when(mockUserRepository.updatePreferences(any))
        .thenAnswer((_) async => const Left(ServerFailure('Update Failed')));

    // act
    final result = await usecase(tPreferences);

    // assert
    expect(result, const Left(ServerFailure('Update Failed')));
    verify(mockUserRepository.updatePreferences(tPreferences));
    verifyNoMoreInteractions(mockUserRepository);
  });
}
