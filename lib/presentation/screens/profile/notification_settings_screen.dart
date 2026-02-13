import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notifications',
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
              _buildNotificationToggle(context, 'Push Notifications', true),
              _buildNotificationToggle(context, 'Email Notifications', true),
              _buildNotificationToggle(context, 'Appointment Reminders', true),
              _buildNotificationToggle(context, 'Promotional Offers', false),
            ],
          ),
        ),
      ),
    );
  }

    Widget _buildNotificationToggle(BuildContext context, String title, bool value) {
    // Mock state for now
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Switch(
            value: value, 
            onChanged: (val) {},
            activeColor: const Color(0xFF964A38),
          ),
        ],
      ),
    );
  }
}
