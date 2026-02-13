import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;
  final String? error;
  final bool isLoading;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.isLoading = false,
  });

  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  factory AuthState.authenticated(User user) {
    return AuthState(
      status: AuthStatus.authenticated,
      user: user,
      isLoading: false,
    );
  }

  factory AuthState.unauthenticated() {
    return const AuthState(
      status: AuthStatus.unauthenticated,
      isLoading: false,
    );
  }

  factory AuthState.loading() {
    return const AuthState(
      status: AuthStatus.loading,
      isLoading: true,
    );
  }

  factory AuthState.error(String message) {
    return AuthState(
      status: AuthStatus.error,
      error: message,
      isLoading: false,
    );
  }

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    bool? isLoading,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [status, user, error, isLoading];
}
