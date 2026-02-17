import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import 'widgets/notification_option_tile.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Mock state for the toggles
  bool _programUpdates = false;
  bool _guidanceReminders = false;
  bool _appointmentReminders = true;
  bool _scheduleUpdates = false;
  bool _healthInsights = false;
  bool _resultsAvailable = false;

  @override
  Widget build(BuildContext context) {
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              NotificationOptionTile(
                title: AppStrings.programUpdates,
                value: _programUpdates,
                onChanged: (val) => setState(() => _programUpdates = val),
              ),
              NotificationOptionTile(
                title: AppStrings.guidanceReminders,
                value: _guidanceReminders,
                onChanged: (val) => setState(() => _guidanceReminders = val),
              ),
              NotificationOptionTile(
                title: AppStrings.appointmentReminders,
                value: _appointmentReminders,
                onChanged: (val) => setState(() => _appointmentReminders = val),
              ),
              NotificationOptionTile(
                title: AppStrings.scheduleUpdates,
                value: _scheduleUpdates,
                onChanged: (val) => setState(() => _scheduleUpdates = val),
              ),
              NotificationOptionTile(
                title: AppStrings.healthInsights,
                value: _healthInsights,
                onChanged: (val) => setState(() => _healthInsights = val),
              ),
              NotificationOptionTile(
                title: AppStrings.resultsAvailable,
                value: _resultsAvailable,
                onChanged: (val) => setState(() => _resultsAvailable = val),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
