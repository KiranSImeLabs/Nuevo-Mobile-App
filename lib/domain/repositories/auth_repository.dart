import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

/// Authentication Repository Interface (Domain Layer)
/// Defines the contract for authentication operations
abstract class AuthRepository {
  /// Login with email and password
  /// Returns User on success, Failure on error
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });
  
  /// Sign up new user
  /// Returns User on success, Failure on error
  Future<Either<Failure, User>> signup({
    required String email,
    required String password,
    required String name,
    String? phoneNumber,
  });
  
  /// Logout current user
  /// Returns void on success, Failure on error
  Future<Either<Failure, void>> logout();
  
  /// Refresh access token
  /// Returns void on success (tokens saved internally), Failure on error
  Future<Either<Failure, void>> refreshToken();
  
  /// Check if user is currently logged in
  /// Returns true if logged in, false otherwise
  Future<bool> isLoggedIn();
  
  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();
  
  /// Sign in with Apple
  Future<Either<Failure, User>> signInWithApple();

  /// Get current access token
  /// Returns token string or null if not logged in
  Future<String?> getAccessToken();
}
