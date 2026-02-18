import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/preferences.dart';
import 'package:nuevo_app/domain/repositories/user_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';
import 'package:nuevo_app/domain/usecases/user/get_preferences_usecase.dart';

import 'get_preferences_usecase_test.mocks.dart';

@GenerateMocks([UserRepository])
void main() {
  late GetPreferencesUseCase usecase;
  late MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
    usecase = GetPreferencesUseCase(mockUserRepository);
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

  test('should get preferences from the repository', () async {
    // arrange
    when(mockUserRepository.getPreferences())
        .thenAnswer((_) async => const Right(tPreferences));

    // act
    final result = await usecase(const NoParams());

    // assert
    expect(result, const Right(tPreferences));
    verify(mockUserRepository.getPreferences());
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return a failure when the repository call is unsuccessful',
      () async {
    // arrange
    when(mockUserRepository.getPreferences())
        .thenAnswer((_) async => const Left(ServerFailure(message: 'Server Error')));

    // act
    final result = await usecase(const NoParams());

    // assert
    expect(result, const Left(ServerFailure(message: 'Server Error')));
    verify(mockUserRepository.getPreferences());
    verifyNoMoreInteractions(mockUserRepository);
  });
}
