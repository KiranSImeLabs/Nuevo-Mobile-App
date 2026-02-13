import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';

/// Reusable info card widget for displaying key information
class InfoCard extends StatelessWidget {
  final String value;
  final String label;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    Key? key,
    required this.value,
    required this.label,
    this.backgroundColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: ResponsiveUtils.spacing(context, base: 68),
        width: double.infinity,
        padding: const EdgeInsets.all(8), // Fixed padding from spec
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFFF6ECE9), // Updated background color
          borderRadius: BorderRadius.circular(8), // Updated border radius
        ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically given fixed height
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, base: 24),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF3E160D),
              height: 1.0,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2), // Reduced spacing to fit in 68px height
          Text(
            label,
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, base: 12),
              fontWeight: FontWeight.w400,
              color: const Color(0xFF3E160D),
            ),
            maxLines: 1, // Reduced max lines to ensure fit
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
  }
}
