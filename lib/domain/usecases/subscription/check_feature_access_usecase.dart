import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/repositories/subscription_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Check Feature Access Use Case
/// Checks if a specific feature is unlocked based on subscription
/// Used for feature gating (Video Consultations, Wellness Reset, etc.)
class CheckFeatureAccessUseCase implements UseCase<bool, FeatureParams> {
  final SubscriptionRepository repository;
  
  CheckFeatureAccessUseCase({required this.repository});
  
  @override
  Future<Either<Failure, bool>> call(FeatureParams params) async {
    return await repository.isFeatureUnlocked(params.featureName);
  }
}

/// Feature Parameters
class FeatureParams extends Equatable {
  final String featureName;
  
  const FeatureParams({required this.featureName});
  
  @override
  List<Object> get props => [featureName];
}
