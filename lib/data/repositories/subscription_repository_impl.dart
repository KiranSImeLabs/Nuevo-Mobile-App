import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

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
      // Since there is no direct subscription endpoint in Postman subset,
      // we fetch user profile which contains subscription info.
      final response = await _apiClient.getUserProfile();
      
      if (response.success && response.data != null) {
        final user = response.data!;
        if (user.subscription != null) {
          return Right(user.subscription!.toEntity());
        } else {
          // Return default/inactive subscription if null
          return const Right(Subscription(
            id: 'inactive',
             planName: 'Free',
             status: SubscriptionStatus.inactive,
             startDate: null,
             expiryDate: null,
             features: [],
          ));
        }
      } else {
        return Left(ServerFailure(response.message ?? 'Failed to get subscription status'));
      }
    } on AppException catch (exception) {
      if (exception is AuthException) {
        return Left(AuthFailure(message: exception.message, code: exception.code));
      } else if (exception is NetworkException) {
        return Left(NetworkFailure(message: exception.message, code: exception.code));
      } else if (exception is ServerException) {
        return Left(ServerFailure(exception.message, exception.code));
      } else {
        return Left(UnknownFailure(message: exception.message));
      }
    } catch (e) {
      return Left(UnknownFailure(message: e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, Subscription>> getSubscriptionDetails() async {
    // Reusing getSubscriptionStatus since details are likely same place
    return getSubscriptionStatus();
  }
  
  @override
  Future<Either<Failure, bool>> isFeatureUnlocked(String featureName) async {
    final result = await getSubscriptionStatus();
    return result.fold(
      (failure) => Left(failure),
      (subscription) => Right(subscription.hasFeature(featureName)),
    );
  }
  
  @override
  Future<Either<Failure, bool>> isSubscriptionActive() async {
    final result = await getSubscriptionStatus();
    return result.fold(
      (failure) => Left(failure),
      (subscription) => Right(subscription.isActive),
    );
  }
}
