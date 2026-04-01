import 'package:flutter/material.dart';
import '../../../../../domain/models/health/health_enums.dart';
import '../../../../../domain/models/health/metric_stats.dart';
import '../../../../../core/theme/app_theme.dart';
import 'historical_trends_glass_card.dart';

class HistoricalTrendsOverview extends StatelessWidget {
  final MetricStats stats;
  final MetricType selectedMetric;

  const HistoricalTrendsOverview({super.key, required this.stats, required this.selectedMetric});

  @override
  Widget build(BuildContext context) {
    Color textColor = AppColors.textPrimary;
    Color subTextColor = AppColors.textSecondary;
    final color = selectedMetric.color;

    String emoji = "➖";
    if (stats.trendDirection == "Improving") emoji = "📈";
    else if (stats.trendDirection == "Declining") emoji = "📉";

    return HistoricalTrendsGlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
               Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
                 child: Icon(selectedMetric.icon, color: color, size: 20),
               ),
               const SizedBox(width: 12),
               Text("Average ${selectedMetric.name}", style: AppTextStyles.bodyMedium.copyWith(color: subTextColor, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(stats.avgVal.toStringAsFixed(1), style: AppTextStyles.h1.copyWith(fontSize: 40, letterSpacing: -1.5)),
              const SizedBox(width: 6),
              Padding(padding: const EdgeInsets.only(bottom: 6), child: Text(selectedMetric.unit, style: AppTextStyles.bodyMedium.copyWith(color: subTextColor))),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: (stats.trendDirection == "Improving" ? const Color(0xFF00C48C) : stats.trendDirection == "Declining" ? const Color(0xFFFF5252) : const Color(0xFFFF8A00)).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("$emoji ${stats.trendStrength} Trend", style: AppTextStyles.label.copyWith(color: (stats.trendDirection == "Improving" ? const Color(0xFF00C48C) : stats.trendDirection == "Declining" ? const Color(0xFFFF5252) : const Color(0xFFFF8A00)), fontWeight: FontWeight.w800)),
                  ],
                ),
              ),
              const Spacer(),
              Text(stats.goalGap.abs() < 0.1 ? "On Target" : (stats.goalGap > 0 ? "+${stats.goalGap.toStringAsFixed(1)} vs Goal" : "${stats.goalGap.toStringAsFixed(1)} vs Goal"), style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w700)),
            ],
          )
        ],
      )
    );
  }
}
