import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MyPlanScreen extends StatelessWidget {
  const MyPlanScreen({super.key});

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
              Text('My Plan', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Your personalized wellness plan and program details will appear here.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              _buildPlanCard(
                'Insight Program',
                'Advanced assessment and specialist-led profiling',
                Icons.insights,
                AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h4),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTextStyles.caption),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
