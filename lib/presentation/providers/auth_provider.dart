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
import 'user_provider.dart';
import 'home_provider.dart';
import 'diet_plan_provider.dart';
import 'specialist_provider.dart';
import 'appointment_provider.dart';
import 'health_provider.dart';
import 'lab_reports_provider.dart';
import 'preferences_provider.dart';
import 'goal_provider.dart';
import 'phase_provider.dart';
import 'subscription_provider.dart';
import 'questionnaire_provider.dart';

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
        logout('401 Unauthorized globally intercepted by DioClient');
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
            // Only force a hard logout if it's explicitly an authorization/session-expired error.
            // This prevents unexpected logouts on Hot Reload, network drops, or missing backend profile endpoints.
            final msg = failure.message.toLowerCase();
            final isAuthError = msg.contains('unauthorized') || 
                                msg.contains('expired') || 
                                msg.contains('token');
            if (isAuthError) {
              await logout('isAuthError in checkLoginStatus ($msg)');
            } else {
              // Proceed as authenticated with a placeholder user. 
              // The valid token is still in secure storage and will attach to future requests.
              state = AuthState.authenticated(
                  User(id: 'local_fallback', email: '', name: 'Loading...'));
            }
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
      (user) {
        _clearUserCache();
        state = AuthState.authenticated(user);
      },
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
    try {
      final result = await _verifyOtpUseCase(email: email, otp: otp);
      return result.fold(
        (failure) {
          state = AuthState.error(failure.message);
          return false;
        },
        (user) {
          try {
            _clearUserCache();
          } catch (e) {
            // If cache clearing fails, we still want to log the user in to avoid freezing
            print('Non-fatal error clearing cache: $e');
          }
          state = AuthState.authenticated(user);
          return true;
        },
      );
    } catch (e) {
      state = AuthState.error("Unexpected error: ${e.toString()}");
      return false;
    }
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
      (user) {
        _clearUserCache();
        state = AuthState.authenticated(user);
      },
    );
  }

  /// Logout
  Future<void> logout([String? reason]) async {
    state = AuthState.loading();
    try {
      print('>>> AUTO LOGOUT TRIGGERED. Reason: ${reason ?? "Manual"}');
      await _logoutUseCase(const NoParams());
      state = AuthState.unauthenticated();
      // Defer explicit provider invalidation to avoid Riverpod CircularDependencyError 
      // (e.g. from userProvider which actively watches authProvider)
      Future.microtask(() => _clearUserCache());
    } catch (e) {
      state = AuthState.unauthenticated();
      Future.microtask(() => _clearUserCache());
    }
  }

  /// Safely clears all user-specific data from providers 
  /// before a new user logs in or when logging out to prevent data leaks.
  void _clearUserCache() {
    // Clear all cached provider data on logout or pre-login.
    // _ref.invalidate(userProvider); // Removed to prevent CircularDependencyError (since it watches authProvider contextually)
    _ref.invalidate(homeDashboardProvider);
    _ref.invalidate(dietPlanProvider);
    _ref.invalidate(specialistListProvider);
      
      // Clear Appointment Providers
      _ref.invalidate(userAppointmentsProvider);
      _ref.invalidate(timeSlotsProvider);
      _ref.invalidate(appointmentDetailProvider);
      
      _ref.invalidate(labReportsProvider);
      _ref.invalidate(todayExerciseProvider);
      _ref.invalidate(weeklyScheduleProvider);
      _ref.invalidate(patientHabitHistoryListProvider);
      _ref.invalidate(goalListProvider);
      _ref.invalidate(preferencesProvider);
      
      // Clear Phase Providers
      _ref.invalidate(activePhaseProvider);
      _ref.invalidate(phaseListProvider);
      _ref.invalidate(weeklyViewProvider);
      _ref.invalidate(phaseProgressProvider);
      _ref.invalidate(activePhaseTaskProvider);
      
      // Clear Subscription Providers
      _ref.invalidate(subscriptionProvider);
      _ref.invalidate(featureAccessProvider);
      
      // Clear Questionnaire Providers
      _ref.invalidate(fetchQuestionnaireProvider);
      _ref.invalidate(questionnaireNotifierProvider);

      // Clear remaining Health/Session Providers
    _ref.invalidate(sessionDetailsProvider);
    _ref.invalidate(startSessionProvider);
    _ref.invalidate(completeSessionProvider);
    _ref.invalidate(syncSessionProgressProvider);
    _ref.invalidate(activeProgressProvider);
    _ref.invalidate(labReportDetailsProvider);
    _ref.invalidate(createLabRequestProvider);
    _ref.invalidate(patientHabitHistoryProvider);
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    // Ideally use a UseCase here, but using repository directly for speed/simplicity in this step
    final result = await _authRepository.signInWithGoogle();
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) {
        _clearUserCache();
        state = AuthState.authenticated(user);
      },
    );
  }

  /// Sign in with Apple
  Future<void> signInWithApple() async {
    state = AuthState.loading();
    final result = await _authRepository.signInWithApple();
    result.fold(
      (failure) => state = AuthState.error(failure.message),
      (user) {
        _clearUserCache();
        state = AuthState.authenticated(user);
      },
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
