import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/remote/api_client.dart';

/// Subscription Repository Implementation (Data Layer)
/// Implements the SubscriptionRepository interface
/// CRITICAL: READ-ONLY operations only (Apple compliance)
class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final ApiClient _apiClient;
  
  SubscriptionRepositoryImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;
  
  @override
  Future<Either<Failure, Subscription>> getSubscriptionStatus() async {
    try {
      final model = await _apiClient.getSubscriptionStatus();
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
  Future<Either<Failure, Subscription>> getSubscriptionDetails() async {
    try {
      final model = await _apiClient.getSubscriptionDetails();
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
  Future<Either<Failure, bool>> isFeatureUnlocked(String featureName) async {
    try {
      final model = await _apiClient.getSubscriptionStatus();
      final subscription = model.toEntity();
      return Right(subscription.hasFeature(featureName));
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
  Future<Either<Failure, bool>> isSubscriptionActive() async {
    try {
      final model = await _apiClient.getSubscriptionStatus();
      final subscription = model.toEntity();
      return Right(subscription.isActive);
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
