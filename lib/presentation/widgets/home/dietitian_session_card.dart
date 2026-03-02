import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';
import '../../../domain/entities/home/quick_stats.dart';

class DietitianSessionCard extends StatelessWidget {
  final SessionInfo? sessionInfo;
  final VoidCallback? onTap;

  const DietitianSessionCard({
    super.key,
    this.sessionInfo,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (sessionInfo == null) {
      return _buildEmptyState(context);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ResponsiveUtils.spacing(context, base: 68),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFF6ECE9), // Matches InfoCard default
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row 1: Time (Large) and Date (Small)
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    sessionInfo!.time,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, base: 22),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF3E160D),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    sessionInfo!.date,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, base: 12),
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF3E160D).withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            // Row 2: Label
            Text(
              sessionInfo!.label,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, base: 12),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF3E160D),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      height: ResponsiveUtils.spacing(context, base: 68),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6ECE9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'No Session',
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, base: 12),
            color: const Color(0xFF3E160D).withOpacity(0.5),
          ),
        ),
      ),
    );
  }
}
