import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/repositories/subscription_repository.dart';
import 'package:nuevo_app/domain/usecases/subscription/is_subscription_active_usecase.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

import 'is_subscription_active_usecase_test.mocks.dart';

// Generate mocks
@GenerateMocks([SubscriptionRepository])
void main() {
  late IsSubscriptionActiveUseCase usecase;
  late MockSubscriptionRepository mockSubscriptionRepository;
  
  setUp(() {
    mockSubscriptionRepository = MockSubscriptionRepository();
    usecase = IsSubscriptionActiveUseCase(repository: mockSubscriptionRepository);
  });
  
  group('IsSubscriptionActiveUseCase', () {
    test('should return true when subscription is active', () async {
      // arrange
      when(mockSubscriptionRepository.isSubscriptionActive())
          .thenAnswer((_) async => const Right(true));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Right(true));
      verify(mockSubscriptionRepository.isSubscriptionActive());
      verifyNoMoreInteractions(mockSubscriptionRepository);
    });
    
    test('should return false when subscription is inactive', () async {
      // arrange
      when(mockSubscriptionRepository.isSubscriptionActive())
          .thenAnswer((_) async => const Right(false));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Right(false));
      verify(mockSubscriptionRepository.isSubscriptionActive());
    });
    
    test('should return SubscriptionFailure when check fails', () async {
      // arrange
      const tFailure = SubscriptionFailure(message: 'Failed to checked status');
      when(mockSubscriptionRepository.isSubscriptionActive())
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Left(tFailure));
      verify(mockSubscriptionRepository.isSubscriptionActive());
    });
    
    test('should return AuthFailure when user is not authenticated', () async {
      // arrange
      const tFailure = AuthFailure(message: 'Not authenticated');
      when(mockSubscriptionRepository.isSubscriptionActive())
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Left(tFailure));
    });
    
    test('should return NetworkFailure when there is no internet', () async {
      // arrange
      const tFailure = NetworkFailure(message: 'No internet connection');
      when(mockSubscriptionRepository.isSubscriptionActive())
          .thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(const NoParams());
      
      // assert
      expect(result, const Left(tFailure));
    });
  });
}
