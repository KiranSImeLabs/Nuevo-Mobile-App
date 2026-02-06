import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:nuevo_app/core/errors/failures.dart';
import 'package:nuevo_app/domain/entities/user.dart';
import 'package:nuevo_app/domain/repositories/auth_repository.dart';
import 'package:nuevo_app/domain/usecases/usecase.dart';

/// Login Use Case
/// Authenticates user with email and password
class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;
  
  LoginUseCase({required this.repository});
  
  @override
  Future<Either<Failure, User>> call(LoginParams params) async {
    return await repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

/// Login Parameters
class LoginParams extends Equatable {
  final String email;
  final String password;
  
  const LoginParams({
    required this.email,
    required this.password,
  });
  
  @override
  List<Object> get props => [email, password];
}
