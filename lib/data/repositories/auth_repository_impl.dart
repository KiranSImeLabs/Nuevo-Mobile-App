import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_data_source.dart';
import '../datasources/remote/api_client.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';
import 'dart:convert';

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
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    try {
      // Create register request
      final request = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      // Call API
      final response = await _apiClient.register(request);
      
      // Check for validation errors first
      if (response.errors != null && response.errors!.isNotEmpty) {
        final errorMessage = response.errors!
            .map((e) => e.msg ?? 'Invalid value')
            .join(', ');
        return Left(ValidationFailure(message: errorMessage));
      }
      
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
      } else if (exception is ValidationException) {
        final msg = exception.errors != null && exception.errors!.isNotEmpty
            ? exception.errors!.join(', ')
            : exception.message;
        return Left(ValidationFailure(message: msg, code: exception.code));
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

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        // User canceled the sign-in
        return const Left(AuthFailure(message: 'Google Sign-In canceled'));
      }
      
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;
      
      if (idToken == null) {
         return const Left(AuthFailure(message: 'Failed to retrieve Google ID Token'));
      }

      // TODO: Send idToken (and optionally accessToken) to your backend
      // final response = await _apiClient.googleLogin(idToken);
      
      // MOCK IMPLEMENTATION FOR NOW (until backend endpoint is ready)
      // We'll simulate a successful login
      
      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Create a mock user based on Google profile
      final user = User(
        id: 'google_${googleUser.id}',
        email: googleUser.email,
        name: googleUser.displayName ?? 'Google User',
        // Add other fields as necessary
      );
      
      // Save dummy token
      await _localDataSource.saveAccessToken('mock_google_token_$idToken');
      await _localDataSource.saveUserId(user.id);
      
      return Right(user);

    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // Implement webAuthenticationOptions if native flow handles Android too, 
        // but typically this package handles iOS natively and Android via web fallback.
        // For Android, you need redirect URI.
      );

      // credential.identityToken is the JWT to send to backend
      if (credential.identityToken == null) {
         return const Left(AuthFailure(message: 'Failed to retrieve Apple Identity Token'));
      }

      // TODO: Send identityToken to backend
      // final response = await _apiClient.appleLogin(credential.identityToken!);

      // MOCK IMPLEMENTATION
      
      final user = User(
        id: 'apple_${credential.userIdentifier}',
         // Email/Name are only available on FIRST sign in with Apple. 
         // Subsequent sign-ins might not return them, so you rely on the backend decoding the ID token.
        email: credential.email ?? 'apple_hidden@email.com', 
        name: [credential.givenName, credential.familyName].where((e) => e != null).join(' '),
      );
      
      await _localDataSource.saveAccessToken('mock_apple_token_${credential.identityToken}');
      await _localDataSource.saveUserId(user.id);
      
      return Right(user);

    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
