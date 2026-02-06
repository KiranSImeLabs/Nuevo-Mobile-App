import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/subscription.dart';
import 'package:nuevo_app/domain/repositories/subscription_repository.dart';
import 'package:nuevo_app/domain/usecases/subscription/get_subscription_status_usecase.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

import 'get_subscription_status_usecase_test.mocks.dart';

// Generate mocks
@GenerateMocks([SubscriptionRepository])
void main() {
  late GetSubscriptionStatusUseCase usecase;
  late MockSubscriptionRepository mockSubscriptionRepository;
  
  setUp(() {
    mockSubscriptionRepository = MockSubscriptionRepository();
    usecase = GetSubscriptionStatusUseCase(repository: mockSubscriptionRepository);
  });
  
  final tSubscription = Subscription(
    id: 'sub_123',
    planName: 'Premium',
    status: SubscriptionStatus.active,
    startDate: DateTime(2024, 1, 1),
    expiryDate: DateTime(2024, 12, 31),
    features: ['video_consultations', 'wellness_reset', 'health_tracking'],
    description: 'Premium medical care plan',
  );
  
  group('GetSubscriptionStatusUseCase', () {
    test('should return Subscription when repository call is successful', () async {
      // arrange
      when(mockSubscriptionRepository.getSubscriptionStatus())
          .thenAnswer((_) async => Right(tSubscription));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, Right(tSubscription));
      verify(mockSubscriptionRepository.getSubscriptionStatus());
      verifyNoMoreInteractions(mockSubscriptionRepository);
    });
    
    test('should return active subscription with correct features', () async {
      // arrange
      when(mockSubscriptionRepository.getSubscriptionStatus())
          .thenAnswer((_) async => Right(tSubscription));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      result.fold(
        (failure) => fail('Should not return failure'),
        (subscription) {
          expect(subscription.status, SubscriptionStatus.active);
          expect(subscription.isActive, true);
          expect(subscription.hasFeature('video_consultations'), true);
          expect(subscription.hasFeature('wellness_reset'), true);
          expect(subscription.features.length, 3);
        },
      );
    });
    
    test('should return inactive subscription', () async {
      // arrange
      final inactiveSubscription = Subscription(
        id: 'sub_456',
        planName: 'Basic',
        status: SubscriptionStatus.inactive,
        features: [],
      );
      
      when(mockSubscriptionRepository.getSubscriptionStatus())
          .thenAnswer((_) async => Right(inactiveSubscription));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      result.fold(
        (failure) => fail('Should not return failure'),
        (subscription) {
          expect(subscription.status, SubscriptionStatus.inactive);
          expect(subscription.isActive, false);
          expect(subscription.features.isEmpty, true);
        },
      );
    });
    
    test('should return expired subscription', () async {
      // arrange
      final expiredSubscription = Subscription(
        id: 'sub_789',
        planName: 'Premium',
        status: SubscriptionStatus.expired,
        expiryDate: DateTime(2023, 12, 31),
        features: [],
      );
      
      when(mockSubscriptionRepository.getSubscriptionStatus())
          .thenAnswer((_) async => Right(expiredSubscription));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      result.fold(
        (failure) => fail('Should not return failure'),
        (subscription) {
          expect(subscription.status, SubscriptionStatus.expired);
          expect(subscription.isActive, false);
        },
      );
    });
    
    test('should return AuthFailure when user is not authenticated', () async {
      // arrange
      const tFailure = AuthFailure(message: 'Not authenticated');
      when(mockSubscriptionRepository.getSubscriptionStatus())
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Left(tFailure));
      verify(mockSubscriptionRepository.getSubscriptionStatus());
    });
    
    test('should return NetworkFailure when there is no internet', () async {
      // arrange
      const tFailure = NetworkFailure(message: 'No internet connection');
      when(mockSubscriptionRepository.getSubscriptionStatus())
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Left(tFailure));
    });
    
    test('should return ServerFailure when server error occurs', () async {
      // arrange
      const tFailure = ServerFailure(message: 'Server error', code: 500);
      when(mockSubscriptionRepository.getSubscriptionStatus())
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Left(tFailure));
    });
  });
  
  group('NoParams', () {
    test('should be a const class', () {
      // arrange
      const params1 = NoParams();
      const params2 = NoParams();
      
      // assert
      expect(params1, params2);
      expect(identical(params1, params2), true);
    });
  });
}
