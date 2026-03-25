import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nuevo_app/core/errors/exceptions.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/data/datasources/local/local_data_source.dart';
import 'package:nuevo_app/data/datasources/remote/api_client.dart';
import 'package:nuevo_app/data/models/api_response.dart';
import 'package:nuevo_app/data/models/auth_response_model.dart';
import 'package:nuevo_app/data/models/user_model.dart';
import 'package:nuevo_app/data/repositories/auth_repository_impl.dart';

import 'auth_repository_impl_test.mocks.dart';

@GenerateMocks([ApiClient, LocalDataSource])
void main() {
  late AuthRepositoryImpl repository;
  late MockApiClient mockApiClient;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockApiClient = MockApiClient();
    mockLocalDataSource = MockLocalDataSource();
    repository = AuthRepositoryImpl(
      apiClient: mockApiClient,
      localDataSource: mockLocalDataSource,
    );
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tOtp = '123456';
  const tFirstName = 'John';
  const tLastName = 'Doe';
  const tName = 'John Doe';
  const tToken = 'access_token_123';
  const tUserId = 'user_id_123';
  
  const tUser = UserModel(
    id: tUserId,
    email: tEmail,
    firstName: tFirstName,
    lastName: tLastName,
  );
  
  const tAuthResponseData = AuthResponseData(
    token: tToken,
    user: tUser,
  );
  
  const tApiResponse = ApiResponse<AuthResponseData>(
    success: true,
    data: tAuthResponseData,
  );

  const tApiVoidResponse = ApiResponse<void>(
    success: true,
    data: null,
  );

  group('login', () {
    test('should return User when login call is successful', () async {
      // Arrange
      when(mockApiClient.login(argThat(isA<LoginRequest>())))
          .thenAnswer((_) async => tApiResponse);
      when(mockLocalDataSource.saveAccessToken(any))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.saveUserId(any))
          .thenAnswer((_) async => {});
          
      // Act
      final result = await repository.login(email: tEmail, password: tPassword);
      
      // Assert
      verify(mockLocalDataSource.saveAccessToken(tToken));
      verify(mockLocalDataSource.saveUserId(tUserId));
      expect(result, isA<Right>());
    });

    test('should return ServerFailure when login call is unsuccessful', () async {
      // Arrange
      when(mockApiClient.login(argThat(isA<LoginRequest>())))
          .thenAnswer((_) async => const ApiResponse(success: false, message: 'Invalid credentials'));
          
      // Act
      final result = await repository.login(email: tEmail, password: tPassword);
      
      // Assert
      verify(mockApiClient.login(argThat(isA<LoginRequest>())));
      verifyNever(mockLocalDataSource.saveAccessToken(any));
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('sendLoginOtp', () {
    test('should return void when sendOtp is successful', () async {
      when(mockApiClient.sendOtp(argThat(isA<SendOtpRequest>())))
          .thenAnswer((_) async => tApiVoidResponse);
          
      final result = await repository.sendLoginOtp(tEmail);
      
      verify(mockApiClient.sendOtp(argThat(isA<SendOtpRequest>())));
      expect(result, const Right(null));
    });
  });

  group('verifyLoginOtp', () {
    test('should return User and save tokens when verifyOtp is successful', () async {
      when(mockApiClient.verifyOtp(argThat(isA<VerifyOtpRequest>())))
          .thenAnswer((_) async => tApiResponse);
      when(mockLocalDataSource.saveAccessToken(any)).thenAnswer((_) async => {});
      when(mockLocalDataSource.saveUserId(any)).thenAnswer((_) async => {});
          
      final result = await repository.verifyLoginOtp(email: tEmail, otp: tOtp);
      
      verify(mockLocalDataSource.saveAccessToken(tToken));
      verify(mockLocalDataSource.saveUserId(tUserId));
      expect(result, isA<Right>());
    });
  });

  group('signup', () {
    test('should return User when signup call is successful', () async {
      // Arrange
      when(mockApiClient.register(argThat(isA<RegisterRequest>())))
          .thenAnswer((_) async => tApiResponse);
      when(mockLocalDataSource.saveAccessToken(any))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.saveUserId(any))
          .thenAnswer((_) async => {});
      
      // Act
      final result = await repository.signup(
        email: tEmail,
        firstName: tFirstName,
        lastName: tLastName,
      );
      
      // Assert
      verify(mockApiClient.register(argThat(isA<RegisterRequest>()))).called(1);
      verify(mockLocalDataSource.saveAccessToken(tToken));
      verify(mockLocalDataSource.saveUserId(tUserId));
      expect(result, isA<Right>());
    });
  });

  group('logout', () {
    test('should clear local data when logout is called', () async {
      // Arrange
      when(mockLocalDataSource.clearSecureData())
          .thenAnswer((_) async => {});
          
      // Act
      final result = await repository.logout();
      
      // Assert
      verify(mockLocalDataSource.clearSecureData());
      expect(result, const Right(null));
    });
  });
}
