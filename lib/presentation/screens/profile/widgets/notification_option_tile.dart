import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class NotificationOptionTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  const NotificationOptionTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8), // Matches the light pinkish/beige background from design
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              CupertinoIcons.clock,
              color: AppColors.primaryButtonColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFF4A4A4A), // Dark grey/brown text
                fontSize: 15,
              ),
            ),
          ),
          // Toggle Switch
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryButtonColor,
            activeTrackColor: AppColors.primaryButtonColor,
          ),
        ],
      ),
    );
  }
}
