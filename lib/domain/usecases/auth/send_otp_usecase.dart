import 'package:dartz/dartz.dart';
import '../../../core/errors/failures.dart';
import '../../repositories/auth_repository.dart';

class SendOtpUseCase {
  final AuthRepository _repository;

  SendOtpUseCase(this._repository);

  Future<Either<Failure, void>> call({
    required String email,
  }) async {
    return await _repository.sendLoginOtp(email);
  }
}
