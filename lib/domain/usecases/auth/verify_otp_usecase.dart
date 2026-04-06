import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';

class VerifyOtpUseCase {
  final AuthRepository _repository;

  VerifyOtpUseCase(this._repository);

  Future<Either<Failure, User>> call({
    required String email,
    required String otp,
  }) async {
    return await _repository.verifyLoginOtp(
      email: email,
      otp: otp,
    );
  }
}
