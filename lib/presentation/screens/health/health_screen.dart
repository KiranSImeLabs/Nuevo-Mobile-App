import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class HealthScreen extends StatelessWidget {
  const HealthScreen({super.key});

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
              Text('Health', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Track your health metrics, vitals, and wellness insights.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
