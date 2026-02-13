import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

/// Forgot Password Use Case
/// Sends password reset instructions
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  final AuthRepository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return await _repository.forgotPassword(params.email);
  }
}

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}
