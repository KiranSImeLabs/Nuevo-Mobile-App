import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

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

  // I will update the constructor in core_providers.dart in the next step.
  
  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Create login request
      final request = LoginRequest(
        email: email,
        password: password,
      );
      
      // Call API
      final response = await _apiClient.login(request);
      
      if (response.success && response.data != null) {
        final data = response.data!;
        
        // Save tokens securely
        await _localDataSource.saveAccessToken(data.token);
        // Postman only returns one token. Assuming it's access token.
        // If refresh token logic is needed, it might be the same or handled by cookie (unlikely for mobile).
        // I'll skip refresh token saving if not present.
        
        await _localDataSource.saveUserId(data.user.id);
        
        // Convert to domain entity and return
        return Right(data.user.toEntity());
      } else {
        return Left(ServerFailure(message: response.message ?? 'Login failed'));
      }
    } on DioException catch (e) {
      // Map DioException to domain Failure
      final exception = DioClient.handleDioError(e);
       if (exception is AuthException) {
        return Left(AuthFailure(message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
        return Left(NetworkFailure(message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(ServerFailure(message: exception.message, code: exception.code));
      } else {
        return Left(UnknownFailure(message: exception.toString()));
      }
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
      // Split name into first and last name as API requires
      final nameParts = name.split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : name;
      final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      // Create register request
      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      // Call API
      final response = await _apiClient.register(request);
      
      if (response.success && response.data != null) {
        final data = response.data!;
        
        // Save tokens securely
        await _localDataSource.saveAccessToken(data.token);
        await _localDataSource.saveUserId(data.user.id);
        
        // Convert to domain entity and return
        return Right(data.user.toEntity());
      } else {
        return Left(ServerFailure(message: response.message ?? 'Signup failed'));
      }
    } on DioException catch (e) {
       final exception = DioClient.handleDioError(e);
       if (exception is AuthException) {
        return Left(AuthFailure(message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
        return Left(NetworkFailure(message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(ServerFailure(message: exception.message, code: exception.code));
      } else {
        return Left(UnknownFailure(message: exception.toString()));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      // API doesn't have explicit logout in the provided Postman subset for token invalidation unless it's blacklist.
      // But typically we just clear local storage.
      // If there IS a logout endpoint, I'd call it.
      // Postman subset didn't show logout. ApiConstants had placeholder.
      // I'll just clear local data for now as per "Client-side logout".
      
      // If server logout exists: await _restClient.logout();
      
      // Clear local data
      await _localDataSource.clearSecureData();
      
      return const Right(null);
    } catch (e) {
      // Even if API call fails, clear local data
      await _localDataSource.clearSecureData();
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> refreshToken() async {
     // Postman subset didn't show refresh token endpoint.
     // If using RefreshTokenUseCase, we might need it.
     // For now, returning unimplemented or just null.
     return const Left(AuthFailure(message: 'Refresh token not supported in this API version'));
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
