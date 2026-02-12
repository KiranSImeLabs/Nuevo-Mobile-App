import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
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
  final AuthRepository _authRepository; // Needed for checking initial login status

  AuthNotifier({
    required LoginUseCase loginUseCase,
    required SignupUseCase signupUseCase,
    required LogoutUseCase logoutUseCase,
    required AuthRepository authRepository,
  })  : _loginUseCase = loginUseCase,
        _signupUseCase = signupUseCase,
        _logoutUseCase = logoutUseCase,
        _authRepository = authRepository,
        super(AuthState.initial()) {
    checkLoginStatus();
  }

  /// Check if user is already logged in on app start
  Future<void> checkLoginStatus() async {
    state = AuthState.loading();
    try {
      final isLoggedIn = await _authRepository.isLoggedIn();
      if (isLoggedIn) {
        // Typically we would fetch the user profile here too
        // For now, we set it to authenticated, but user data might be null initially
        // until ProfileProvider works. Or we can chain calls.
        
        // Assuming we rely on UserProfileProvider to fetch user details
        // state = AuthState.authenticated(null); // User is null initially
        
        // Ideally we should try to get the user here or mark as 'authenticated' 
        // and let the UI trigger a fetch.
        
        // Let's mark as authenticated but without user object for now if we can't fetch it easily here
        // without introducing circular dependency with UserProvider.
        // Or we can inject GetUserProfileUseCase here too.
        state = const AuthState(status: AuthStatus.authenticated);
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
    loginUseCase: ref.watch(loginUseCaseProvider),
    signupUseCase: ref.watch(signupUseCaseProvider),
    logoutUseCase: ref.watch(logoutUseCaseProvider),
    authRepository: ref.watch(authRepositoryProvider),
  );
});
