import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../domain/entities/specialist.dart';
import '../../domain/repositories/specialist_repository.dart';

class SpecialistRepositoryImpl implements SpecialistRepository {
  final ApiClient _apiClient;

  SpecialistRepositoryImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<Either<Failure, List<Specialist>>> getMySpecialists() async {
    try {
      final response = await _apiClient.getMySpecialists();
      if (response.success && response.data != null) {
        final specialists =
            response.data!.map((model) => model.toEntity()).toList();
        return Right(specialists);
      } else {
        return Left(ServerFailure(
            response.message ?? 'Failed to get specialists'));
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
  Future<Either<Failure, Specialist>> getSpecialistDetails(String id) async {
    try {
      final response = await _apiClient.getSpecialistDetails(id);
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(
            response.message ?? 'Failed to get specialist details'));
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
