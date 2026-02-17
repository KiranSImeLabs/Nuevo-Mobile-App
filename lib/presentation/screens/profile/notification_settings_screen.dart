import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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


  @override
  Widget build(BuildContext context) {
    final preferencesState = ref.watch(preferencesProvider);
    final notification = preferencesState.data.notification;

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
        child: preferencesState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    NotificationOptionTile(
                      title: AppStrings.programUpdates,
                      value: notification.programUpdates,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateNotificationPreferences(programUpdates: val),
                    ),
                    NotificationOptionTile(
                      title: AppStrings.guidanceReminders,
                      value: notification.guidanceReminders,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateNotificationPreferences(guidanceReminders: val),
                    ),
                    NotificationOptionTile(
                      title: AppStrings.appointmentReminders,
                      value: notification.appointmentReminders,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateNotificationPreferences(
                              appointmentReminders: val),
                    ),
                    NotificationOptionTile(
                      title: AppStrings.scheduleUpdates,
                      value: notification.scheduleUpdates,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateNotificationPreferences(scheduleUpdates: val),
                    ),
                    NotificationOptionTile(
                      title: AppStrings.healthInsights,
                      value: notification.healthInsights,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateNotificationPreferences(healthInsights: val),
                    ),
                    NotificationOptionTile(
                      title: AppStrings.resultsAvailable,
                      value: notification.resultsAvailable,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateNotificationPreferences(resultsAvailable: val),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
