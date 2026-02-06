import 'package:dartz/dartz.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/user.dart';
import 'package:nuevo_app/domain/repositories/user_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Get User Profile Use Case
/// Retrieves the current user's profile information
class GetUserProfileUseCase implements UseCase<User, NoParams> {
  final UserRepository repository;
  
  GetUserProfileUseCase({required this.repository});
  
  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await repository.getUserProfile();
  }
}
