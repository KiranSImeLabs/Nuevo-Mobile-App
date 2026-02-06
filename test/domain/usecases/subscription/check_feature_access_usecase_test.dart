import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/constants/app_constants.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/repositories/subscription_repository.dart';
import 'package:nuevo_app/domain/usecases/subscription/check_feature_access_usecase.dart';

import 'check_feature_access_usecase_test.mocks.dart';

// Generate mocks
@GenerateMocks([SubscriptionRepository])
void main() {
  late CheckFeatureAccessUseCase usecase;
  late MockSubscriptionRepository mockSubscriptionRepository;
  
  setUp(() {
    mockSubscriptionRepository = MockSubscriptionRepository();
    usecase = CheckFeatureAccessUseCase(repository: mockSubscriptionRepository);
  });
  
  group('CheckFeatureAccessUseCase', () {
    test('should return true when feature is unlocked', () async {
      // arrange
      const tFeatureName = FeatureNames.videoConsultations;
      const tParams = FeatureParams(featureName: tFeatureName);
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Right(true));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Right(true));
      verify(mockSubscriptionRepository.isFeatureUnlocked(tFeatureName));
      verifyNoMoreInteractions(mockSubscriptionRepository);
    });
    
    test('should return false when feature is locked', () async {
      // arrange
      const tFeatureName = FeatureNames.wellnessReset;
      const tParams = FeatureParams(featureName: tFeatureName);
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Right(false));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Right(false));
      verify(mockSubscriptionRepository.isFeatureUnlocked(tFeatureName));
    });
    
    test('should check video consultations feature', () async {
      // arrange
      const tParams = FeatureParams(
        featureName: FeatureNames.videoConsultations,
      );
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Right(true));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Right(true));
      verify(mockSubscriptionRepository.isFeatureUnlocked(
        FeatureNames.videoConsultations,
      ));
    });
    
    test('should check wellness reset feature', () async {
      // arrange
      const tParams = FeatureParams(
        featureName: FeatureNames.wellnessReset,
      );
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Right(false));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Right(false));
      verify(mockSubscriptionRepository.isFeatureUnlocked(
        FeatureNames.wellnessReset,
      ));
    });
    
    test('should check health tracking feature', () async {
      // arrange
      const tParams = FeatureParams(
        featureName: FeatureNames.healthTracking,
      );
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Right(true));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Right(true));
      verify(mockSubscriptionRepository.isFeatureUnlocked(
        FeatureNames.healthTracking,
      ));
    });
    
    test('should return SubscriptionFailure when subscription check fails', () async {
      // arrange
      const tParams = FeatureParams(
        featureName: FeatureNames.videoConsultations,
      );
      const tFailure = SubscriptionFailure(
        message: 'Failed to check subscription',
      );
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
    });
    
    test('should return AuthFailure when user is not authenticated', () async {
      // arrange
      const tParams = FeatureParams(
        featureName: FeatureNames.videoConsultations,
      );
      const tFailure = AuthFailure(message: 'Not authenticated');
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
    });
    
    test('should return NetworkFailure when there is no internet', () async {
      // arrange
      const tParams = FeatureParams(
        featureName: FeatureNames.videoConsultations,
      );
      const tFailure = NetworkFailure(message: 'No internet connection');
      
      when(mockSubscriptionRepository.isFeatureUnlocked(any))
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
    });
  });
  
  group('FeatureParams', () {
    test('should be equal when feature names are the same', () {
      // arrange
      const params1 = FeatureParams(
        featureName: FeatureNames.videoConsultations,
      );
      const params2 = FeatureParams(
        featureName: FeatureNames.videoConsultations,
      );
      
      // assert
      expect(params1, params2);
      expect(params1.hashCode, params2.hashCode);
    });
    
    test('should not be equal when feature names are different', () {
      // arrange
      const params1 = FeatureParams(
        featureName: FeatureNames.videoConsultations,
      );
      const params2 = FeatureParams(
        featureName: FeatureNames.wellnessReset,
      );
      
      // assert
      expect(params1, isNot(params2));
    });
    
    test('props should contain feature name', () {
      // arrange
      const params = FeatureParams(
        featureName: FeatureNames.healthTracking,
      );
      
      // assert
      expect(params.props, [FeatureNames.healthTracking]);
    });
  });
}
