import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/local/local_data_source.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../domain/entities/preferences.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../models/preferences_model.dart';

/// User Repository Implementation (Data Layer)
/// Implements the UserRepository interface
class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;
  final LocalDataSource _localDataSource;
  
  UserRepositoryImpl({
    required ApiClient apiClient,
    required LocalDataSource localDataSource,
  })  : _apiClient = apiClient,
        _localDataSource = localDataSource;
        
  @override
  Future<Either<Failure, User>> getUserProfile() async {
    try {
       final response = await _apiClient.getUserProfile();
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(response.message ?? 'Failed to get user profile'));
      }
    } on DioException catch (e) {
      final exception = DioClient.handleDioError(e);
      if (exception is AuthException) {
        return Left(AuthFailure(message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
         return Left(NetworkFailure(message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(ServerFailure(exception.message, exception.code));
      } else {
        return Left(UnknownFailure(message: exception.toString()));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
    String? dateOfBirth,
  }) async {
    try {
      final nameParts = name?.trim().split(' ');
      final firstName = nameParts != null && nameParts.isNotEmpty ? nameParts.first : '';
      final lastName = nameParts != null && nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
      
      final data = {
        "firstName": firstName,
        "lastName": lastName,
        "profileImage": profileImageUrl ?? "",
        "dateOfBirth": dateOfBirth ?? "",
      };
      
      final response = await _apiClient.updateProfile(data);
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(response.message ?? 'Failed to update profile'));
      }
    } on DioException catch (e) {
      final exception = DioClient.handleDioError(e);
      if (exception is AuthException) {
        return Left(AuthFailure(message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
        return Left(NetworkFailure(message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(ServerFailure(exception.message, exception.code));
      } else {
        return Left(UnknownFailure(message: exception.toString()));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Preferences>> updatePreferences(
      Preferences preferences) async {
    try {
      final preferencesModel = PreferencesModel.fromEntity(preferences);
      final response = await _apiClient.updatePreferences(preferencesModel);
      
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(
            response.message ?? 'Failed to update preferences'));
      }
    } on DioException catch (e) {
      final exception = DioClient.handleDioError(e);
      if (exception is AuthException) {
        return Left(
            AuthFailure(message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
        return Left(
            NetworkFailure(message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(
            ServerFailure(exception.message, exception.code));
      } else {
        return Left(UnknownFailure(message: exception.toString()));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Preferences>> getPreferences() async {
    try {
      final response = await _apiClient.getPreferences();
      
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(
            response.message ?? 'Failed to get preferences'));
      }
    } on DioException catch (e) {
      final exception = DioClient.handleDioError(e);
      if (exception is AuthException) {
        return Left(
            AuthFailure(message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
        return Left(
            NetworkFailure(message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(
            ServerFailure(exception.message, exception.code));
      } else {
        return Left(UnknownFailure(message: exception.toString()));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
}
