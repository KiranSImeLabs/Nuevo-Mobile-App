import 'package:dartz/dartz.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/repositories/auth_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Refresh Token Use Case
/// Refreshes the authentication tokens using the refresh token
class RefreshTokenUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;
  
  RefreshTokenUseCase({required this.repository});
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.refreshToken();
  }
}
