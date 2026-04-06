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

  /// Send OTP to user's email
  /// Returns void on success, Failure on error
  Future<Either<Failure, void>> sendLoginOtp(String email);

  /// Verify OTP and login
  /// Returns User on success, Failure on error
  Future<Either<Failure, User>> verifyLoginOtp({
    required String email,
    required String otp,
  });
  
  /// Sign up new user
  /// Returns User on success, Failure on error
  Future<Either<Failure, User>> signup({
    required String email,
    required String firstName,
    required String lastName,
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

  /// Check and handle first launch logic (clearing secure storage if needed)
  Future<void> checkFirstLaunch();

  /// Send password reset link to email
  /// Returns void on success, Failure on error
  Future<Either<Failure, void>> forgotPassword(String email);
}
