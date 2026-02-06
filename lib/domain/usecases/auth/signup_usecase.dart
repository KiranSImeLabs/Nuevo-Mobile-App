import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/user.dart';
import 'package:nuevo_app/domain/repositories/auth_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Signup Use Case
/// Registers a new user
class SignupUseCase implements UseCase<User, SignupParams> {
  final AuthRepository repository;
  
  SignupUseCase({required this.repository});
  
  @override
  Future<Either<Failure, User>> call(SignupParams params) async {
    return await repository.signup(
      email: params.email,
      password: params.password,
      name: params.name,
      phoneNumber: params.phoneNumber,
    );
  }
}

/// Signup Parameters
class SignupParams extends Equatable {
  final String email;
  final String password;
  final String name;
  final String? phoneNumber;
  
  const SignupParams({
    required this.email,
    required this.password,
    required this.name,
    this.phoneNumber,
  });
  
  @override
  List<Object?> get props => [email, password, name, phoneNumber];
}
