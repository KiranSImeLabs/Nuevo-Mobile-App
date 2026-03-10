import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/preferences.dart';
import '../../../../presentation/providers/preferences_provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import 'widgets/notification_option_tile.dart';
class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  NotificationPreferences? _localNotification;

  String _getNotificationName(String key) {
    switch (key) {
      case 'programUpdates': return AppStrings.programUpdates;
      case 'guidanceReminders': return AppStrings.guidanceReminders;
      case 'appointmentReminders': return AppStrings.appointmentReminders;
      case 'scheduleUpdates': return AppStrings.scheduleUpdates;
      case 'healthInsights': return AppStrings.healthInsights;
      case 'resultsAvailable': return AppStrings.resultsAvailable;
      default: return 'Notification';
    }
  }

  void _toggleSetting(String key, bool newValue) async {
    if (_localNotification == null) return;

    // 1. Optimistically update local state
    setState(() {
      switch (key) {
        case 'programUpdates':
          _localNotification = _localNotification!.copyWith(programUpdates: newValue);
          break;
        case 'guidanceReminders':
          _localNotification = _localNotification!.copyWith(guidanceReminders: newValue);
          break;
        case 'appointmentReminders':
          _localNotification = _localNotification!.copyWith(appointmentReminders: newValue);
          break;
        case 'scheduleUpdates':
          _localNotification = _localNotification!.copyWith(scheduleUpdates: newValue);
          break;
        case 'healthInsights':
          _localNotification = _localNotification!.copyWith(healthInsights: newValue);
          break;
        case 'resultsAvailable':
          _localNotification = _localNotification!.copyWith(resultsAvailable: newValue);
          break;
      }
    });

    final notifier = ref.read(preferencesProvider.notifier);

    // 2. Call provider API
    try {
      switch (key) {
        case 'programUpdates':
          await notifier.updateNotificationPreferences(programUpdates: newValue);
          break;
        case 'guidanceReminders':
          await notifier.updateNotificationPreferences(guidanceReminders: newValue);
          break;
        case 'appointmentReminders':
          await notifier.updateNotificationPreferences(appointmentReminders: newValue);
          break;
        case 'scheduleUpdates':
          await notifier.updateNotificationPreferences(scheduleUpdates: newValue);
          break;
        case 'healthInsights':
          await notifier.updateNotificationPreferences(healthInsights: newValue);
          break;
        case 'resultsAvailable':
          await notifier.updateNotificationPreferences(resultsAvailable: newValue);
          break;
      }

      final error = ref.read(preferencesProvider).error;
      if (error != null) {
        // Failed! Revert
        if (mounted) {
          setState(() {
            _localNotification = ref.read(preferencesProvider).data.notification;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update ${_getNotificationName(key)}. Reverted.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } else {
        // Success!
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getNotificationName(key)} ${newValue ? 'enabled' : 'disabled'} successfully.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _localNotification = ref.read(preferencesProvider).data.notification;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferencesState = ref.watch(preferencesProvider);
    
    // Initialize or sync local state if we aren't loading
    // Because _updatePreferences sets isLoading=true, and then false when done.
    if (_localNotification == null || !preferencesState.isLoading && ref.read(preferencesProvider).error == null) {
      _localNotification = preferencesState.data.notification;
    }

    final notification = _localNotification!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.notifications,
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  NotificationOptionTile(
                    title: AppStrings.programUpdates,
                    value: notification.programUpdates,
                    onChanged: (val) => _toggleSetting('programUpdates', val),
                  ),
                  NotificationOptionTile(
                    title: AppStrings.guidanceReminders,
                    value: notification.guidanceReminders,
                    onChanged: (val) => _toggleSetting('guidanceReminders', val),
                  ),
                  NotificationOptionTile(
                    title: AppStrings.appointmentReminders,
                    value: notification.appointmentReminders,
                    onChanged: (val) => _toggleSetting('appointmentReminders', val),
                  ),
                  NotificationOptionTile(
                    title: AppStrings.scheduleUpdates,
                    value: notification.scheduleUpdates,
                    onChanged: (val) => _toggleSetting('scheduleUpdates', val),
                  ),
                  NotificationOptionTile(
                    title: AppStrings.healthInsights,
                    value: notification.healthInsights,
                    onChanged: (val) => _toggleSetting('healthInsights', val),
                  ),
                  NotificationOptionTile(
                    title: AppStrings.resultsAvailable,
                    value: notification.resultsAvailable,
                    onChanged: (val) => _toggleSetting('resultsAvailable', val),
                  ),
                ],
              ),
            ),
            if (preferencesState.isLoading)
              Container(
                color: Colors.white.withAlpha(128),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
