import 'package:flutter/material.dart';
import '../../../domain/entities/home/wellness_progress.dart';
import '../../utils/responsive_utils.dart';
import '../../../core/theme/app_theme.dart';
/// Wellness progress card widget matching updated UI specs
/// Specs: width: 335, height: 126, bg: #6B3528, radius: 12, padding: 12
class WellnessCard extends StatelessWidget {
  final WellnessProgress wellnessProgress;

  const WellnessCard({
    Key? key,
    required this.wellnessProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int percentage = wellnessProgress.progressPercent;
    
    return Container(
      height: 126,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF6B3528),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Top Row: Content (Icon+Text)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon Box
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/wellness_icon.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.spa,
                      color: Color(0xFF6B3528),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Text Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wellnessProgress.phaseName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        height: 1.2,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wellnessProgress.subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.2,
                        fontFamily: 'Inter',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _buildProgressBars(context, percentage),
              ),
              const SizedBox(width: 70),
              Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  height: 1.0,
                  fontFamily: 'Outfit',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build vertical progress bars
  Widget _buildProgressBars(BuildContext context, int percentage) {
    const int totalBars = 10;
    // Calculate how many bars should be active based on percentage
    final int activeBars = (percentage / 100 * totalBars).round();
    
    const double barHeight = 36.0;
    const double barWidth = 9.0;
    
    return Container(
      height: barHeight,
      alignment: Alignment.bottomLeft,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(totalBars, (index) {
          final isActive = index < activeBars;
          
          return Container(
            width: barWidth,
            height: barHeight, 
            decoration: BoxDecoration(
              color: isActive
                  ? const Color(0xFF9E5C4B)
                  : AppColors.primaryColor,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

