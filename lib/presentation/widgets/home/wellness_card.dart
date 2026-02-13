import 'package:flutter/material.dart';
import '../../../domain/entities/home/wellness_progress.dart';
import '../../utils/responsive_utils.dart';

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
    // Calculate percentage integer (0-100)
    final int percentage = wellnessProgress.progressPercent;
    print('🔍 DEBUG: WellnessCard percentage: $percentage');
    print('🔍 DEBUG: WellnessCard subtitle: ${wellnessProgress.subtitle}');
    
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 126, // Fixed height from spec
          padding: const EdgeInsets.all(12), // Fixed padding from spec
          decoration: BoxDecoration(
            color: Colors.blue, // Visual Debug: Blue background
            borderRadius: BorderRadius.circular(12), // Fixed radius from spec
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Icon Box + Text
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
                      padding: const EdgeInsets.all(8.0), // Padding inside white box
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
              
              // Bottom Row: Progress Bars + Percentage
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Progress Bars
                  Expanded(
                    child: _buildProgressBars(context, percentage),
                  ),
                  const SizedBox(width: 12),
                  // Percentage Text
                  Text(
                    '$percentage%',
                    style: const TextStyle(
                      fontSize: 32, // Large percentage text
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.0,
                      fontFamily: 'Outfit', // Using Outfit for numbers if available, else standard
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  /// Build vertical progress bars
  Widget _buildProgressBars(BuildContext context, int percentage) {
    const int totalBars = 10;
    // Calculate how many bars should be active based on percentage
    final int activeBars = (percentage / 100 * totalBars).round();
    
    const double barHeight = 36.0; // Updated height
    const double barWidth = 8.0; // slightly thinner to fit more elegantly
    
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
                  ? const Color(0xFF9E5C4B) // Lighter brown/terracotta for active (matched from image)
                  : const Color(0xFF53281E), // Darker brown for inactive (matched from image background shade)
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

