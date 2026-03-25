import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/send_otp_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/verify_otp_usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../domain/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
import 'core_providers.dart';

/// Auth Notifier
/// Manages global authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SignupUseCase _signupUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AuthRepository _authRepository; // Needed for checking initial login status
  final Ref _ref;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SendOtpUseCase sendOtpUseCase,
    required VerifyOtpUseCase verifyOtpUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required AuthRepository authRepository,
    required Ref ref,
  })  : _loginUseCase = loginUseCase,
        _sendOtpUseCase = sendOtpUseCase,
        _verifyOtpUseCase = verifyOtpUseCase,
        _signupUseCase = signupUseCase,
        _logoutUseCase = logoutUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _authRepository = authRepository,
        _ref = ref,
        super(AuthState.initial()) {
    checkLoginStatus();

    // Listen for global logout events (unauthorized 401s)
    // We use this event system to break circular dependency with DioClient
    _ref.listen<int>(logoutEventProvider, (previous, next) {
      if (next > (previous ?? 0)) {

        logout();
      }
    });
  }

  /// Check if user is already logged in on app start
  Future<void> checkLoginStatus() async {
    state = AuthState.loading();
    try {
      // Check for first launch and clear stale tokens if needed
      await _authRepository.checkFirstLaunch();

      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        // To avoid showing Home with a stale/invalid token (which happens on iOS Keychain persistence),
        // we MUST validate the token by fetching the profile immediately.
        final profileResult = await _getUserProfileUseCase(const NoParams());
        
        profileResult.fold(
          (failure) async {

            await logout(); // This handles state update and storage cleanup
          },
          (user) {

            state = AuthState.authenticated(user);
          },
        );
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e) {
      // If we can't check login status, default to unauthenticated so user can login
      state = AuthState.unauthenticated();
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Send OTP
  Future<bool> sendOtp(String email) async {
    state = AuthState.loading();
    final result = await _sendOtpUseCase(email: email);
    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (_) {
        state = AuthState.unauthenticated(); // OTP sent, but user is not authenticated yet
        return true;
      },
    );
  }

  /// Verify OTP
  Future<bool> verifyOtp(String email, String otp) async {
    state = AuthState.loading();
    final result = await _verifyOtpUseCase(email: email, otp: otp);
    return result.fold(
      (failure) {
        state = AuthState.error(failure.message);
        return false;
      },
      (user) {
        state = AuthState.authenticated(user);
        return true;
      },
    );
  }

  /// Signup
  Future<void> signup({
    required String email,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    state = AuthState.loading();
    final result = await _signupUseCase(SignupParams(
      email: email,
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    ));
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Logout
  Future<void> logout() async {
    state = AuthState.loading();
    final result = await _logoutUseCase(const NoParams());
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = AuthState.unauthenticated(),
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    // Ideally use a UseCase here, but using repository directly for speed/simplicity in this step
    final result = await _authRepository.signInWithGoogle();
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    state = AuthState.loading();
    final result = await _authRepository.signInWithApple();
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Forgot Password
  Future<void> forgotPassword(String email) async {
    // We don't necessarily want to change the whole app state to loading 
    // because this screen might be on top of others, but for simplicity let's stick to the pattern.
    // However, if we change state to loading, it might trigger redirects in router if not careful.
    // Start with loading.
    state = AuthState.loading();
    
    final result = await _forgotPasswordUseCase(ForgotPasswordParams(email: email));
    
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) {
        // Success - we might want to keep the user on the screen or show a success message.
        // Returning to unauthenticated state with a "message" would be ideal, 
        // but AuthState doesn't hold success messages well without authenticated.
        // Let's reset to unauthenticated (since they are not logged in) 
        // but the UI will handle the success feedback.
        // OR better: The UI should watch for state changes.
        // If we go back to unauthenticated, the UI might flicker.
        // Let's just restore previous state (unauthenticated) but maybe with a clear error if any.
        state = AuthState.unauthenticated();
      },
    );
  }
}

/// Global Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref: ref,
    loginUseCase: ref.watch(loginUseCaseProvider),
    sendOtpUseCase: ref.watch(sendOtpUseCaseProvider),
    verifyOtpUseCase: ref.watch(verifyOtpUseCaseProvider),
    signupUseCase: ref.watch(signupUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getUserProfileUseCase: ref.watch(getUserProfileUseCaseProvider),
    forgotPasswordUseCase: ref.watch(forgotPasswordUseCaseProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});
