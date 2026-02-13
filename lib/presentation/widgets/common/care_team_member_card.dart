import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CareTeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  // In a real app, this would likely be an image URL or Asset path
  // but for now we are using a placeholder color + icon as per previous implementation
  final Color? placeholderColor;
  final String? imageUrl;
  final VoidCallback? onTap;

  const CareTeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    this.placeholderColor,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.roseSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: placeholderColor ?? Colors.grey.shade200,
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
              child: imageUrl == null
                  ? Icon(Icons.person, color: Colors.grey.shade700)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF2C2C2C),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    role,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward,
              color: Color(0xFF8D6E63), // Brownish arrow from design
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
