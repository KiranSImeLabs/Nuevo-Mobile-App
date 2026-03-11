import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/usecases/subscription/check_feature_access_usecase.dart';
import '../../domain/usecases/subscription/get_subscription_status_usecase.dart';
import '../../domain/usecases/usecase.dart';
import 'core_providers.dart';

/// Subscription State Provider (AsyncValue)
/// Fetches and holds the current subscription status
final subscriptionProvider = FutureProvider<Subscription>((ref) async {
  final getStatus = ref.watch(getSubscriptionStatusUseCaseProvider);
  final result = await getStatus(const NoParams());
  return result.fold(
    (failure) => throw failure.message,
    (subscription) => subscription,
  );
});

/// Feature Access Family Provider
/// Checks if a specific feature is accessible
/// Usage: ref.watch(featureAccessProvider('video_calls'))
final featureAccessProvider = FutureProvider.family<bool, String>((ref, featureName) async {
  final checkAccess = ref.watch(checkFeatureAccessUseCaseProvider);
  final result = await checkAccess(FeatureParams(featureName: featureName));
  return result.fold(
    (failure) => false, // Default to false on error for safety
    (isUnlocked) => isUnlocked,
  );
});
