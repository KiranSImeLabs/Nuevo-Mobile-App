import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/usecase.dart';
import '../../domain/usecases/user/get_user_profile_usecase.dart';
import '../../domain/usecases/user/update_user_profile_usecase.dart';
import 'auth_provider.dart';
import 'auth_state.dart';
import 'core_providers.dart';

/// User Profile Notifier
/// Manages fetching and updating user profile
class UserNotifier extends StateNotifier<AsyncValue<User?>> {
  final GetUserProfileUseCase _getUserProfileUseCase;
  final UpdateUserProfileUseCase _updateUserProfileUseCase;
  final Ref _ref;

  UserNotifier(
    this._ref, {
    required GetUserProfileUseCase getUserProfile,
    required UpdateUserProfileUseCase updateUserProfile,
  })  : _getUserProfileUseCase = getUserProfile,
        _updateUserProfileUseCase = updateUserProfile,
        super(const AsyncValue.loading());

  /// Fetch User Profile
  Future<void> fetchProfile() async {
    state = const AsyncValue.loading();
    final result = await _getUserProfileUseCase(const NoParams());
    result.fold(
      (failure) => state = AsyncValue.error(failure.message, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  /// Update Profile
  Future<void> updateProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    // Optimistic update or set loading
    // state = const AsyncValue.loading(); 
    
    final result = await _updateUserProfileUseCase(UpdateProfileParams(
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
    ));
    
    result.fold(
      (failure) {
         // Handle error, maybe revert state if optimistic
         state = AsyncValue.error(failure.message, StackTrace.current);
      },
      (user) => state = AsyncValue.data(user),
    );
  }
}

/// User Provider
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<User?>>((ref) {
  // Watch auth state changes - fetch profile when authenticated
  final authState = ref.watch(authProvider);
  
  final notifier = UserNotifier(
    ref,
    getUserProfile: ref.watch(getUserProfileUseCaseProvider),
    updateUserProfile: ref.watch(updateUserProfileUseCaseProvider),
  );
  
  // Auto-fetch profile when authenticated
  if (authState.status == AuthStatus.authenticated && authState.user == null) {
    // Only fetch if we don't have user data yet (or handled inside notifier)
    // Delaying slightly to avoid build interruptions or just rely on manual fetch
    Future.microtask(() => notifier.fetchProfile());
  }
  
  return notifier;
});
