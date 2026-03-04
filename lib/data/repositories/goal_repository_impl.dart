import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/goal.dart';
import '../../domain/repositories/goal_repository.dart';
import '../datasources/remote/api_client.dart';

class GoalRepositoryImpl implements GoalRepository {
  final ApiClient apiClient;

  GoalRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, List<Goal>>> getGoals() async {
    try {
      final response = await apiClient.getGoals();
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

  @override
  Future<Either<Failure, Goal>> createGoal(String goal) async {
    try {
      final response = await apiClient.createGoal({'goal': goal});
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(response.message ?? 'Server error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Goal>> getGoalById(String id) async {
    try {
      final response = await apiClient.getGoalById(id);
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(response.message ?? 'Server error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Goal>> updateGoal(String id, String goal) async {
    try {
      final response = await apiClient.updateGoal(id, {'goal': goal});
      if (response.success && response.data != null) {
        return Right(response.data!.toEntity());
      } else {
        return Left(ServerFailure(response.message ?? 'Server error'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioException(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteGoal(String id) async {
    try {
      final response = await apiClient.deleteGoal(id);
      if (response.success) {
        return const Right(null);
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
