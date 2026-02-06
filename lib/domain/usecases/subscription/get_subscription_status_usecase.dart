import 'package:dartz/dartz.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/subscription.dart';
import 'package:nuevo_app/domain/repositories/subscription_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Get Subscription Status Use Case
/// Retrieves the current user's subscription status
/// CRITICAL: READ-ONLY operation (Apple compliance)
class GetSubscriptionStatusUseCase implements UseCase<Subscription, NoParams> {
  final SubscriptionRepository repository;
  
  GetSubscriptionStatusUseCase({required this.repository});
  
  @override
  Future<Either<Failure, Subscription>> call(NoParams params) async {
    return await repository.getSubscriptionStatus();
  }
}
