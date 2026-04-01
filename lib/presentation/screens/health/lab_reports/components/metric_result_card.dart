import 'package:flutter/material.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../data/models/lab_report_model.dart';
import '../../../../widgets/health/health_parameter_meter.dart';

enum MetricStatus { optimal, suboptimal, stable }

class MetricResultCard extends StatelessWidget {
  final String title;
  final MetricStatus status;
  final String value;
  final String unit;
  final double scoreFraction; // 0.0 to 1.0 (left to right position of the marker on the bars)
  final double? numericValue;
  final ReferenceRange? referenceRange;

  const MetricResultCard({
    super.key,
    required this.title,
    required this.status,
    required this.value,
    required this.unit,
    required this.scoreFraction,
    this.numericValue,
    this.referenceRange,
  });

  @override
  Widget build(BuildContext context) {
    Color badgeBgColor;
    Color badgeTextColor;
    String statusText;

    switch (status) {
      case MetricStatus.optimal:
        badgeBgColor = const Color(0xFFEEDDDF); // Matches design pale orange/pink
        badgeTextColor = const Color(0xFFB57C6C);
        statusText = 'Optimal';
        break;
      case MetricStatus.suboptimal:
        badgeBgColor = const Color(0xFFEEDDDF);
        badgeTextColor = const Color(0xFFB57C6C);
        statusText = 'Suboptimal';
        break;
      case MetricStatus.stable:
        badgeBgColor = const Color(0xFFEEDDDF);
        badgeTextColor = const Color(0xFFB57C6C);
        statusText = 'Stable';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8), // Base card color matching design
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Title & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1E1E1E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: badgeBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: badgeTextColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Value Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8C8C8C), // Grey unit color
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Indicator Bar Map (Low, Optimal, High Sections)
          LayoutBuilder(
            builder: (context, constraints) {
              final double totalWidth = constraints.maxWidth;

              return Stack(
                alignment: Alignment.centerLeft,
                clipBehavior: Clip.none,
                children: [
                  // Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4C7A1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2ECC71),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),

                      Expanded(
                        child: Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5B7B1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Indicator
                  Positioned(
                    left: (scoreFraction * totalWidth).clamp(0.0, totalWidth) - 4, // 8px total width, shift by half to center precisely 
                    top: -12, // Indicator height 20, bar height 6. Shift up by 12 to center the 8px base bulb on the 6px line exactly
                    child: SizedBox(
                      width: 8,
                      height: 20,
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        clipBehavior: Clip.none,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: 4,
                              height: 16, // Elongated stem overlapping into the bulb
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E1E1E),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          Container(
                            width: 8,
                            height: 8, // Rounded bulb base
                            decoration: const BoxDecoration(
                              color: Color(0xFF1E1E1E),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
