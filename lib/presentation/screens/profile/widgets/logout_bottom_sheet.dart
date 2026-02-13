import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';

class LogoutBottomSheet extends ConsumerWidget {
  const LogoutBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 32),
          
          // Power Icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFA65C4B), // Brown/Rust
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.power_settings_new,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 24),
          
          // Title
          const Text(
            'Log out',
            style: AppTextStyles.h2,
          ),
          const SizedBox(height: 8),
          
          // Subtitle
          Text(
            'Are you sure you want to log out?',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Logout Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close sheet
                ref.read(authProvider.notifier).logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA65C4B), // Brown/Rust
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Log Out',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 20),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
