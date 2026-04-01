import 'package:flutter/material.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_theme.dart';
import '../common/guidance_card.dart';
import '../historical_trends_banner.dart';
import 'daily_logging_view.dart';

class InsightsTabContent extends StatelessWidget {
  const InsightsTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Your Nuevo Age Section
        Text(
          "Your Nuevo Age",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EAE8), // Matches the nutrition card background color
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  const Text(
                    "--",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      color: Colors.green,//Color(0xFF1E1E1E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Years",
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xFF1E1E1E).withAlpha(150),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                "-- years younger than your biological age",
                style: TextStyle(
                  fontSize: 14,
                  color: const Color(0xFF1E1E1E).withAlpha(150),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Recent Insights Section
        Text(
          AppStrings.recentInsights,
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const GuidanceCard(
          icon: Icons.bed_outlined, // Sleep icon
          title: AppStrings.sleepQualityImproved,
          subtitle: AppStrings.sleepQualityDesc,
          iconColor: Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        const GuidanceCard(
          icon: Icons.track_changes_outlined, // Activity/Target icon
          title: AppStrings.activityGoalMet,
          subtitle: AppStrings.activityGoalDesc,
          iconColor: Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        const GuidanceCard(
          icon: Icons.psychology_outlined, // Stress/Mind icon
          title: AppStrings.stressLevels,
          subtitle: AppStrings.stressLevelsDesc,
          iconColor: Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.xl),
        
        // Historical Trends Banner
        const HistoricalTrendsBanner(),
        const SizedBox(height: AppSpacing.md),
        
        // New Daily Logging UI
        Text(
          "Daily Log",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const DailyLoggingView(),
      ],
    );
  }
}
