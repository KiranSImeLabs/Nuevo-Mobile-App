import 'package:dartz/dartz.dart';
import 'package:nuevo_app/core/errors/exceptions.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/data/datasources/local/local_data_source.dart';
import 'package:nuevo_app/data/datasources/remote/api_client.dart';
import 'package:nuevo_app/domain/entities/user.dart';
import 'package:nuevo_app/domain/repositories/user_repository.dart';

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
      final model = await _apiClient.getUserProfile();
      return Right(model.toEntity());
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
  Future<Either<Failure, User>> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (name != null) data['name'] = name;
      if (phoneNumber != null) data['phone_number'] = phoneNumber;
      if (profileImageUrl != null) data['profile_image_url'] = profileImageUrl;
      
      final model = await _apiClient.updateProfile(data);
      return Right(model.toEntity());
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
}
