import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Appointments', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Manage your upcoming and past appointments with healthcare professionals.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
