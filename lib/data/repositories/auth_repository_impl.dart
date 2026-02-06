import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/api_client.dart';
import '../models/auth_response_model.dart';

/// Authentication Repository Implementation (Data Layer)
/// Implements the AuthRepository interface
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient _apiClient;
  final LocalDataSource _localDataSource;
  
  AuthRepositoryImpl({
    required ApiClient apiClient,
    required LocalDataSource localDataSource,
  })  : _apiClient = apiClient,
        _localDataSource = localDataSource;
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Create login request
      final request = LoginRequestModel(
        email: email,
        password: password,
      );
      
      // Call API
      final response = await _apiClient.login(request);
      
      // Save tokens securely
      await _localDataSource.saveAccessToken(response.accessToken);
      await _localDataSource.saveRefreshToken(response.refreshToken);
      await _localDataSource.saveUserId(response.user.id);
      
      // Convert to domain entity and return
      return Right(response.user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  }) async {
    try {
      // Create signup request
      final request = SignupRequestModel(
        email: email,
        password: password,
        name: name,
        phoneNumber: phoneNumber,
      );
      
      // Call API
      final response = await _apiClient.signup(request);
      
      // Save tokens securely
      await _localDataSource.saveAccessToken(response.accessToken);
      await _localDataSource.saveRefreshToken(response.refreshToken);
      await _localDataSource.saveUserId(response.user.id);
      
      // Convert to domain entity and return
      return Right(response.user.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // Call API to logout (invalidate token on server)
      await _apiClient.logout();
      
      // Clear local data
      await _localDataSource.clearSecureData();
      
      return const Right(null);
    } on NetworkException catch (e) {
      // Even if API call fails, clear local data
      await _localDataSource.clearSecureData();
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      // Even if API call fails, clear local data
      await _localDataSource.clearSecureData();
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      // Even if API call fails, clear local data
      await _localDataSource.clearSecureData();
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> refreshToken() async {
    try {
      // Get current refresh token
      final refreshToken = await _localDataSource.getRefreshToken();
      
      if (refreshToken == null) {
        return const Left(AuthFailure(message: 'No refresh token available'));
      }
      
      // Call API to refresh token
      final response = await _apiClient.refreshToken({
        'refresh_token': refreshToken,
      });
      
      // Save new tokens
      await _localDataSource.saveAccessToken(response.accessToken);
      await _localDataSource.saveRefreshToken(response.refreshToken);
      
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<bool> isLoggedIn() async {
    return await _localDataSource.isLoggedIn();
  }
  
  @override
  Future<String?> getAccessToken() async {
    return await _localDataSource.getAccessToken();
  }
}
