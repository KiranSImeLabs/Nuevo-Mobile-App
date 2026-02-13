import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/app_constants.dart';
import '../../core/network/dio_client.dart';
import '../../data/datasources/local/local_data_source.dart';
import '../../data/datasources/remote/api_client.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/subscription_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/logout_usecase.dart';
import '../../domain/usecases/auth/refresh_token_usecase.dart';
import '../../domain/usecases/auth/signup_usecase.dart';
import '../../domain/usecases/auth/forgot_password_usecase.dart';
import '../../domain/usecases/subscription/check_feature_access_usecase.dart';
import '../../domain/usecases/subscription/get_subscription_status_usecase.dart';
import '../../domain/usecases/subscription/is_subscription_active_usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/user/update_user_profile_usecase.dart';
// import 'auth_provider.dart'; // Removing to break circularity

// ============================================
// Core Dependencies
// ============================================

/// A simple provider to signal that a logout should occur (e.g. on 401 unauthorized access)
/// This helps break circular dependencies between DioClient and AuthProvider
final logoutEventProvider = StateProvider<int>((ref) => 0);

/// Shared Preferences Provider
/// Must be overridden in main.dart:
/// ProviderScope(overrides: [sharedPreferencesProvider.overrideWithValue(prefs)])
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

/// Flutter Secure Storage Provider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Dio Client Provider
final dioClientProvider = Provider<DioClient>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return DioClient(
    getAccessToken: () async {
      return await secureStorage.read(key: StorageKeys.accessToken);
    },
    onUnauthorized: () {
      // Trigger logout event without directly depending on authProvider
      ref.read(logoutEventProvider.notifier).state++;
    },
  );
});

// ============================================
// Data Sources
// ============================================

/// Remote Data Source (API Client)
final apiClientProvider = Provider<ApiClient>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return ApiClient(dioClient: dioClient);
});

/// Local Data Source
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalDataSource(
    secureStorage: secureStorage,
    preferences: sharedPreferences,
  );
});

// ============================================
// Repositories
// ============================================

/// Auth Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return AuthRepositoryImpl(
    apiClient: apiClient,
    localDataSource: localDataSource,
  );
});

/// Subscription Repository
final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return SubscriptionRepositoryImpl(apiClient: apiClient);
});

/// User Repository
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return UserRepositoryImpl(
    apiClient: apiClient,
    localDataSource: localDataSource,
  );
});

// ============================================
// Use Cases - Auth
// ============================================

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository: repository);
});

final signupUseCaseProvider = Provider<SignupUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignupUseCase(repository: repository);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository: repository);
});

final refreshTokenUseCaseProvider = Provider<RefreshTokenUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return RefreshTokenUseCase(repository: repository);
});

final forgotPasswordUseCaseProvider = Provider<ForgotPasswordUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return ForgotPasswordUseCase(repository);
});

// ============================================
// Use Cases - Subscription
// ============================================

final getSubscriptionStatusUseCaseProvider = Provider<GetSubscriptionStatusUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return GetSubscriptionStatusUseCase(repository: repository);
});

final checkFeatureAccessUseCaseProvider = Provider<CheckFeatureAccessUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return CheckFeatureAccessUseCase(repository: repository);
});

final isSubscriptionActiveUseCaseProvider = Provider<IsSubscriptionActiveUseCase>((ref) {
  final repository = ref.watch(subscriptionRepositoryProvider);
  return IsSubscriptionActiveUseCase(repository: repository);
});

// ============================================
// Use Cases - User
// ============================================

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return GetUserProfileUseCase(repository: repository);
});

final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((ref) {
  final repository = ref.watch(userRepositoryProvider);
  return UpdateUserProfileUseCase(repository: repository);
});
