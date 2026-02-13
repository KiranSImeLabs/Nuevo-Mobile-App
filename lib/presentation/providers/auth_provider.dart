import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/usecase.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
import 'core_providers.dart';

/// Auth Notifier
/// Manages global authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final SignupUseCase _signupUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetUserProfileUseCase _getUserProfileUseCase;
  final AuthRepository _authRepository; // Needed for checking initial login status
  final Ref _ref;

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required GetUserProfileUseCase getUserProfileUseCase,
    required AuthRepository authRepository,
    required Ref ref,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _logoutUseCase = logoutUseCase,
        _getUserProfileUseCase = getUserProfileUseCase,
        _authRepository = authRepository,
        _ref = ref,
        super(AuthState.initial()) {
    checkLoginStatus();

    // Listen for global logout events (unauthorized 401s)
    // We use this event system to break circular dependency with DioClient
    _ref.listen<int>(logoutEventProvider, (previous, next) {
      if (next > (previous ?? 0)) {
        print('🚨 Global logout event received, logging out...');
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
            print('🔍 Session invalid on startup, clearing tokens: ${failure.message}');
            await logout(); // This handles state update and storage cleanup
          },
          (user) {
            print('✅ Session validated for user: ${user.email}');
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

  /// Signup
  /// Signup
  Future<void> signup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phoneNumber,
  }) async {
    state = AuthState.loading();
    final result = await _signupUseCase(SignupParams(
      email: email,
      password: password,
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
}

/// Global Auth Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref: ref,
    loginUseCase: ref.watch(loginUseCaseProvider),
    signupUseCase: ref.watch(signupUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    getUserProfileUseCase: ref.watch(getUserProfileUseCaseProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});
