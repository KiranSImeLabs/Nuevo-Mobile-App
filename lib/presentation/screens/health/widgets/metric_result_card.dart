import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

enum MetricStatus { optimal, suboptimal, stable }

class MetricResultCard extends StatelessWidget {
  final String title;
  final MetricStatus status;
  final String value;
  final String unit;
  final double scoreFraction; // 0.0 to 1.0 (left to right position of the marker on the bars)

  const MetricResultCard({
    super.key,
    required this.title,
    required this.status,
    required this.value,
    required this.unit,
    required this.scoreFraction,
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
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1E1E1E),
                ),
              ),
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
              // We divide the bar into 3 segments matching the design.
              // Roughly: 35% Light orange (Low), 40% Green (Optimal), 25% Pinkish (High)
              // Actually, looking at the design, it's 3 distinct colored bars with gaps.
              
              final totalWidth = constraints.maxWidth;
              const gap = 6.0;
              final lightOrangeWidth = totalWidth * 0.35 - gap;
              final greenWidth = totalWidth * 0.40 - gap;
              final pinkWidth = totalWidth * 0.25; // Last one doesn't need gap subtraction

              // Calculate marker position based on fraction
              final markerPos = totalWidth * scoreFraction;

              return Stack(
                clipBehavior: Clip.none, // Allow marker to slightly overflow vertically
                alignment: Alignment.centerLeft,
                children: [
                  Row(
                    children: [
                      // Section 1: Low (Pale Orange)
                      Container(
                        height: 6,
                        width: lightOrangeWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7DAC0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: gap),
                      // Section 2: Optimal (Bright Green)
                      Container(
                        height: 6,
                        width: greenWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1BE196),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: gap),
                      // Section 3: High (Pale Pink)
                      Container(
                        height: 6,
                        width: pinkWidth,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7D1D4),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ],
                  ),
                  
                  // The positioned Value Marker (Vertical Black tick)
                  Positioned(
                    left: markerPos - 1.5, // Center the marker
                    child: Container(
                      height: 18,
                      width: 3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(1.5),
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
