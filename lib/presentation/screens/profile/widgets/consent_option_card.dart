import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ConsentOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback onTapDetails;

  const ConsentOptionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.onTapDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8), // Light pink/beige background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF4A4A4A),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Using CupertinoSwitch for iOS style look or Switch.adaptive
              SizedBox(
                height: 24,
                child: Transform.scale(
                  scale: 0.8,
                  child: Switch.adaptive(
                    value: value,
                    onChanged: onChanged,
                    activeColor: const Color(0xFF964A38), // Brown/Red active color
                    activeTrackColor: const Color(0xFF964A38),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(right: 48.0), // Space for switch
            child: Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: const Color(0xFF8D6E63), // Muted brown text
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: onTapDetails,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View Details',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: const Color(0xFF964A38), // Link color
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Color(0xFF964A38),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
