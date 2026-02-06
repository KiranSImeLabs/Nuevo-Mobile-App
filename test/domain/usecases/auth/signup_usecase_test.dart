import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/user.dart';
import 'package:nuevo_app/domain/repositories/auth_repository.dart';
import 'package:nuevo_app/domain/usecases/auth/signup_usecase.dart';

import 'signup_usecase_test.mocks.dart';

// Generate mocks
@GenerateMocks([AuthRepository])
void main() {
  late SignupUseCase usecase;
  late MockAuthRepository mockAuthRepository;
  
  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SignupUseCase(repository: mockAuthRepository);
  });
  
  const tEmail = 'newuser@example.com';
  const tPassword = 'Test@1234';
  const tName = 'New User';
  const tPhoneNumber = '+1234567890';
  const tParams = SignupParams(
    email: tEmail,
    password: tPassword,
    name: tName,
    phoneNumber: tPhoneNumber,
  );
  
  final tUser = User(
    id: '456',
    email: tEmail,
    name: tName,
    phoneNumber: tPhoneNumber,
  );
  
  group('SignupUseCase', () {
    test('should return User when signup is successful', () async {
      // arrange
      when(mockAuthRepository.signup(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
        phoneNumber: anyNamed('phoneNumber'),
      )).thenAnswer((_) async => Right(tUser));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, Right(tUser));
      verify(mockAuthRepository.signup(
        email: tEmail,
        password: tPassword,
        name: tName,
        phoneNumber: tPhoneNumber,
      ));
      verifyNoMoreInteractions(mockAuthRepository);
    });
    
    test('should work without phone number', () async {
      // arrange
      const paramsWithoutPhone = SignupParams(
        email: tEmail,
        password: tPassword,
        name: tName,
      );
      final userWithoutPhone = User(
        id: '456',
        email: tEmail,
        name: tName,
      );
      
      when(mockAuthRepository.signup(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
        phoneNumber: anyNamed('phoneNumber'),
      )).thenAnswer((_) async => Right(userWithoutPhone));
      
      // act
      final result = await usecase(paramsWithoutPhone);
      
      // assert
      expect(result, Right(userWithoutPhone));
      verify(mockAuthRepository.signup(
        email: tEmail,
        password: tPassword,
        name: tName,
        phoneNumber: null,
      ));
    });
    
    test('should return AuthFailure when email already exists', () async {
      // arrange
      const tFailure = AuthFailure(
        message: 'Email already registered',
      );
      when(mockAuthRepository.signup(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
        phoneNumber: anyNamed('phoneNumber'),
      )).thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
      verify(mockAuthRepository.signup(
        email: tEmail,
        password: tPassword,
        name: tName,
        phoneNumber: tPhoneNumber,
      ));
    });
    
    test('should return ValidationFailure when data is invalid', () async {
      // arrange
      const tFailure = ValidationFailure(message: 'Invalid email format');
      when(mockAuthRepository.signup(
        email: anyNamed('email'),
        password: anyNamed('password'),
        name: anyNamed('name'),
        phoneNumber: anyNamed('phoneNumber'),
      )).thenAnswer((_) async => const Left(tFailure));
      
      // act
      final result = await usecase(tParams);
      
      // assert
      expect(result, const Left(tFailure));
    });
  });
  
  group('SignupParams', () {
    test('should be equal when all properties are the same', () {
      // arrange
      const params1 = SignupParams(
        email: tEmail,
        password: tPassword,
        name: tName,
        phoneNumber: tPhoneNumber,
      );
      const params2 = SignupParams(
        email: tEmail,
        password: tPassword,
        name: tName,
        phoneNumber: tPhoneNumber,
      );
      
      // assert
      expect(params1, params2);
      expect(params1.hashCode, params2.hashCode);
    });
    
    test('should handle null phone number in equality', () {
      // arrange
      const params1 = SignupParams(
        email: tEmail,
        password: tPassword,
        name: tName,
      );
      const params2 = SignupParams(
        email: tEmail,
        password: tPassword,
        name: tName,
      );
      
      // assert
      expect(params1, params2);
    });
    
    test('props should contain all fields including nullable phone', () {
      // arrange
      const params = SignupParams(
        email: tEmail,
        password: tPassword,
        name: tName,
        phoneNumber: tPhoneNumber,
      );
      
      // assert
      expect(params.props, [tEmail, tPassword, tName, tPhoneNumber]);
    });
  });
}
