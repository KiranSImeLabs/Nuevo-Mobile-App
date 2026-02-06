import 'package:dartz/dartz.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/repositories/auth_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Logout Use Case
/// Logs out the current user and clears session data
class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  
  LogoutUseCase({required this.repository});
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.logout();
  }
}
