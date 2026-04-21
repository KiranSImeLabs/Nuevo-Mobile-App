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
import '../../domain/entities/user.dart';
import 'auth_state.dart';
import 'core_providers.dart';

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SendOtpUseCase _sendOtpUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final SignupUseCase _signupUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final AuthRepository _authRepository;
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

    // Global logout listener (401)
    _ref.listen<int>(logoutEventProvider, (previous, next) {
      if (next > (previous ?? 0)) {
        logout('401 Unauthorized');
      }
    });
  }

  /// Check login status
  Future<void> checkLoginStatus() async {
    state = AuthState.loading();
    try {
      await _authRepository.checkFirstLaunch();

      final isLoggedIn = await _authRepository.isLoggedIn();

      if (isLoggedIn) {
        final result = await _getUserProfileUseCase(const NoParams());

        result.fold(
          (failure) async {
            final msg = failure.message.toLowerCase();
            final isAuthError = msg.contains('unauthorized') ||
                msg.contains('expired') ||
                msg.contains('token');

            if (isAuthError) {
              await logout('Invalid token');
            } else {
              state = AuthState.authenticated(
                User(id: 'local', email: '', name: 'Loading...'),
              );
            }
          },
          (user) {
            state = AuthState.authenticated(user);
          },
        );
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (_) {
      state = AuthState.unauthenticated();
    }
  }

  /// Login
  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    final result =
        await _loginUseCase(LoginParams(email: email, password: password));

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

Future<bool> sendOtp(String email) async {
  state = AuthState.loading();

  final result = await _sendOtpUseCase(email: email);

  return result.fold(
    (failure) {
      state = AuthState.error(failure.message);
      return false;
    },
    (_) {
      state = AuthState.unauthenticated();
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

  /// Logout
  Future<void> logout([String? reason]) async {
    state = AuthState.loading();
    try {
      await _logoutUseCase(const NoParams());
    } catch (_) {}

    state = AuthState.unauthenticated();
  }

  /// Google
  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Apple
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
    state = AuthState.loading();

    final result =
        await _forgotPasswordUseCase(ForgotPasswordParams(email: email));

    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (_) => state = AuthState.unauthenticated(),
    );
  }
}

/// Provider
final authProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
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