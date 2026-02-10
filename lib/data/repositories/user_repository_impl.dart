import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/local/local_data_source.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

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
        return Left(ServerFailure(message: response.message ?? 'Failed to get user profile'));
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
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    // API endpoint not present in Postman collection subset provided.
    // If it exists, add to RestClient and call here.
    return Left(ServerFailure(message: 'Update profile not implemented in API'));
  }
}
