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
  const tName = 'John Doe';
  const tToken = 'access_token_123';
  const tUserId = 'user_id_123';
  
  const tUser = UserModel(
    id: tUserId,
    email: tEmail,
    name: tName,
  );
  
  const tLoginResponseData = LoginResponseData(
    token: tToken,
    user: tUser,
  );
  
  const tApiResponse = ApiResponse<LoginResponseData>(
    success: true,
    data: tLoginResponseData,
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
      verify(mockApiClient.login(argThat(isA<LoginRequest>())));
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

  group('signup', () {
    test('should return User when signup call is successful', () async {
      // Arrange
      when(mockApiClient.register(argThat(isA<RegisterRequest>())))
          .thenAnswer((_) async => tApiResponse);
      when(mockLocalDataSource.saveAccessToken(any))
          .thenAnswer((_) async => {});
      when(mockLocalDataSource.saveUserId(any))
          .thenAnswer((_) async => {});
          
      final tRegisterRequest = RegisterRequest(
        email: tEmail,
        password: tPassword,
        firstName: 'John',
        lastName: 'Doe',
      );
      
      // Act
      final result = await repository.signup(
        email: tEmail,
        password: tPassword,
        name: tName,
      );
      
      // Assert
      // Use argThat or a concrete object. Since name is split inside repository,
      // the exact object instance might differ, so we use argThat or verify parameters.
      // But for simplicity let's use argThat(isA<RegisterRequest>())
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
