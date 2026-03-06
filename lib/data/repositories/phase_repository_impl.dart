import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/phase.dart';
import '../../domain/repositories/phase_repository.dart';
import '../datasources/remote/api_client.dart';

class PhaseRepositoryImpl implements PhaseRepository {
  final ApiClient apiClient;

  PhaseRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<Phase>>> getPhases() async {
    try {
      final response = await apiClient.getPhases();
      if (response.success) {
        return Right(response.data?.map((m) => m.toEntity()).toList() ?? []);
      } else {
        return Left(ServerFailure(response.message ?? 'Server error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
