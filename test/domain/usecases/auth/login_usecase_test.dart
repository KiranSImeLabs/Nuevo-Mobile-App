import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/subscription.dart';
import 'package:nuevo_app/domain/entities/user.dart';
import 'package:nuevo_app/domain/repositories/auth_repository.dart';
import 'package:nuevo_app/domain/usecases/auth/login_usecase.dart';

import 'login_usecase_test.mocks.dart';

// Generate mocks
@GenerateMocks([AuthRepository])
void main() {
  late LoginUseCase usecase;
  late MockAuthRepository mockAuthRepository;
  
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginUseCase(repository: mockAuthRepository);
  });
  
  const tEmail = 'test@example.com';
  const tPassword = 'Test@1234';
  const tParams = LoginParams(email: tEmail, password: tPassword);
  
  final tSubscription = Subscription(
    id: '1',
    planName: 'Premium',
    status: SubscriptionStatus.active,
    features: ['video_consultations', 'wellness_reset'],
  );
  
  final tUser = User(
    id: '123',
    email: tEmail,
    name: 'Test User',
    subscription: tSubscription,
  );
  
  group('LoginUseCase', () {
    test('should return User when login is successful', () async {
      // arrange
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => Right(tUser));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, Right(tUser));
      verify(mockAuthRepository.login(
        email: tEmail,
        password: tPassword,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });
    
    test('should return AuthFailure when credentials are invalid', () async {
      // arrange
      const tFailure = AuthFailure(message: 'Invalid credentials');
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
      verify(mockAuthRepository.login(
        email: tEmail,
        password: tPassword,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });
    
    test('should return NetworkFailure when there is no internet', () async {
      // arrange
      const tFailure = NetworkFailure(message: 'No internet connection');
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
      verify(mockAuthRepository.login(
        email: tEmail,
        password: tPassword,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });
    
    test('should return ServerFailure when server error occurs', () async {
      // arrange
      const tFailure = ServerFailure(message: 'Server error', code: 500);
      when(mockAuthRepository.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
      verify(mockAuthRepository.login(
        email: tEmail,
        password: tPassword,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });
  });
  
  group('LoginParams', () {
    test('should be equal when properties are the same', () {
      // arrange
      const params1 = LoginParams(email: tEmail, password: tPassword);
      const params2 = LoginParams(email: tEmail, password: tPassword);
      
      // assert
      expect(params1, params2);
      expect(params1.hashCode, params2.hashCode);
    });
    
    test('should not be equal when properties are different', () {
      // arrange
      const params1 = LoginParams(email: tEmail, password: tPassword);
      const params2 = LoginParams(email: 'other@example.com', password: tPassword);
      
      // assert
      expect(params1, isNot(params2));
    });
    
    test('props should contain email and password', () {
      // arrange
      const params = LoginParams(email: tEmail, password: tPassword);
      
      // assert
      expect(params.props, [tEmail, tPassword]);
    });
  });
}
