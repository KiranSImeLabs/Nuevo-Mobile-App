import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/preferences.dart';
import '../../domain/usecases/user/update_preferences_usecase.dart';
import '../../domain/usecases/user/update_preferences_usecase.dart';
import '../../domain/usecases/user/get_preferences_usecase.dart';
import '../../domain/usecases/usecase.dart';
import 'core_providers.dart';

/// Preferences State
class PreferencesState {
  final bool isLoading;
  final Preferences data;
  final String? error;

  const PreferencesState({
    this.isLoading = false,
    required this.data,
    this.error,
  });

  factory PreferencesState.initial() {
    return const PreferencesState(
      data: Preferences(
        notification: NotificationPreferences(
          programUpdates: false,
          guidanceReminders: false,
          appointmentReminders: false,
          scheduleUpdates: false,
          healthInsights: false,
          resultsAvailable: false,
        ),
        consent: ConsentPreferences(
          dataSharingConsent: false,
          researchParticipation: false,
          communicationPreferences: false,
        ),
      ),
    );
  }

  PreferencesState copyWith({
    bool? isLoading,
    Preferences? data,
    String? error,
  }) {
    return PreferencesState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

/// Preferences Notifier
class PreferencesNotifier extends StateNotifier<PreferencesState> {
  final UpdatePreferencesUseCase _updatePreferencesUseCase;
  final GetPreferencesUseCase _getPreferencesUseCase;

  PreferencesNotifier({
    required UpdatePreferencesUseCase updatePreferences,
    required GetPreferencesUseCase getPreferences,
  })  : _updatePreferencesUseCase = updatePreferences,
        _getPreferencesUseCase = getPreferences,
        super(PreferencesState.initial()) {
    getPreferencesData();
  }

  /// Fetch Preferences
  Future<void> getPreferencesData() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _getPreferencesUseCase(const NoParams());

    if (!mounted) return;

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (preferences) => state = state.copyWith(
        isLoading: false,
        data: preferences,
      ),
    );
  }

  /// Update Notification Preferences
  Future<void> updateNotificationPreferences({
    bool? programUpdates,
    bool? guidanceReminders,
    bool? appointmentReminders,
    bool? scheduleUpdates,
    bool? healthInsights,
    bool? resultsAvailable,
  }) async {
    final currentNotification = state.data.notification;
    final newNotification = currentNotification.copyWith(
      programUpdates: programUpdates,
      guidanceReminders: guidanceReminders,
      appointmentReminders: appointmentReminders,
      scheduleUpdates: scheduleUpdates,
      healthInsights: healthInsights,
      resultsAvailable: resultsAvailable,
    );

    final newPreferences = state.data.copyWith(notification: newNotification);
    await _updatePreferences(newPreferences);
  }

  /// Update Consent Preferences
  Future<void> updateConsentPreferences({
    bool? dataSharingConsent,
    bool? researchParticipation,
    bool? communicationPreferences,
  }) async {
    final currentConsent = state.data.consent;
    final newConsent = currentConsent.copyWith(
      dataSharingConsent: dataSharingConsent,
      researchParticipation: researchParticipation,
      communicationPreferences: communicationPreferences,
    );

    final newPreferences = state.data.copyWith(consent: newConsent);
    await _updatePreferences(newPreferences);
  }

  /// Internal method to call API to update preferences
  Future<void> _updatePreferences(Preferences newPreferences) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _updatePreferencesUseCase(newPreferences);

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
      },
      (preferences) {
        state = state.copyWith(
          isLoading: false,
          data: preferences,
        );
      },
    );
  }
}

/// Preferences Provider
final preferencesProvider = StateNotifierProvider<PreferencesNotifier, PreferencesState>((ref) {
  return PreferencesNotifier(
    updatePreferences: ref.watch(updatePreferencesUseCaseProvider),
    getPreferences: ref.watch(getPreferencesUseCaseProvider),
  );
});
