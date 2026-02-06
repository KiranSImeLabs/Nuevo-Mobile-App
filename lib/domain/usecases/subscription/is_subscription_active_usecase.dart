import 'package:dartz/dartz.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/repositories/subscription_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Is Subscription Active Use Case
/// Checks if the current subscription is active
class IsSubscriptionActiveUseCase implements UseCase<bool, NoParams> {
  final SubscriptionRepository repository;
  
  IsSubscriptionActiveUseCase({required this.repository});
  
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isSubscriptionActive();
  }
}
