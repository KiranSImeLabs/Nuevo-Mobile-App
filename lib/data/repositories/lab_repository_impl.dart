import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../domain/repositories/lab_repository.dart';
import '../datasources/remote/api_client.dart';
import '../models/lab_request_model.dart';
import '../models/lab_report_model.dart';

/// Implementation of [LabRepository]
class LabRepositoryImpl implements LabRepository {
  final ApiClient _apiClient;

  LabRepositoryImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<Either<Failure, LabRequestData>> createLabRequest(String notes) async {
    try {
      final request = CreateLabRequest(notes: notes);
      
      final response = await _apiClient.createLabRequest(request);

      if (response.success == true && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.message ?? 'Failed to create lab request',
        ));
      }
    } on AppException catch (exception) {
      if (exception is AuthException) {
        return Left(AuthFailure(
            message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
        return Left(NetworkFailure(
            message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(ServerFailure(
            exception.message, exception.code));
      } else if (exception is ValidationException) {
         final msg = exception.errors != null && exception.errors!.isNotEmpty
            ? exception.errors!.join(', ')
            : exception.message;
        return Left(ValidationFailure(message: msg, code: exception.code));
      } else {
        return Left(UnknownFailure(message: exception.message));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LabRequestListResponseData>> getLabRequests() async {
    try {
      final response = await _apiClient.getLabRequests();

      if (response.success == true && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.message ?? 'Failed to retrieve lab requests',
        ));
      }
    } on AppException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LabRequestData>> getLabRequestById(String id) async {
    try {
      final response = await _apiClient.getLabRequestById(id);

      if (response.success == true && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.message ?? 'Failed to retrieve lab request details',
        ));
      }
    } on AppException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LabReportListData>> getLabReports() async {
    try {
      final response = await _apiClient.getLabReports();

      if (response.success == true && response.data != null) {
        return Right(response.data!);
      } else {
        return Left(ServerFailure(
          response.message ?? 'Failed to retrieve lab reports',
        ));
      }
    } on AppException catch (e) {
      return Left(_handleDioException(e));
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  Failure _handleDioException(AppException exception) {
    if (exception is AuthException) {
      return AuthFailure(message: exception.message, code: exception.code);
    } else if (exception is NetworkException) {
      return NetworkFailure(message: exception.message, code: exception.code);
    } else if (exception is ServerException) {
      return ServerFailure(exception.message, exception.code);
    } else if (exception is ValidationException) {
      final msg = exception.errors != null && exception.errors!.isNotEmpty
          ? exception.errors!.join(', ')
          : exception.message;
      return ValidationFailure(message: msg, code: exception.code);
    } else {
      return UnknownFailure(message: exception.message);
    }
  }
}
