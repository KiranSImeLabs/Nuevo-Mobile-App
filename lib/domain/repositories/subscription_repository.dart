import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/subscription.dart';

/// Subscription Repository Interface (Domain Layer)
/// Defines the contract for subscription operations
/// CRITICAL: READ-ONLY operations only (Apple compliance)
abstract class SubscriptionRepository {
  /// Get current subscription status
  /// Returns Subscription on success, Failure on error
  Future<Either<Failure, Subscription>> getSubscriptionStatus();
  
  /// Get detailed subscription information
  /// Returns Subscription on success, Failure on error
  Future<Either<Failure, Subscription>> getSubscriptionDetails();
  
  /// Check if a specific feature is unlocked
  /// Returns true if feature is available, false otherwise
  Future<Either<Failure, bool>> isFeatureUnlocked(String featureName);
  
  /// Check if subscription is currently active
  /// Returns true if active, false otherwise
  Future<Either<Failure, bool>> isSubscriptionActive();
}
