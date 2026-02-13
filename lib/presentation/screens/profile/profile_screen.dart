import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile', style: AppTextStyles.h1),
              const SizedBox(height: AppSpacing.xl),
              userState.when(
                data: (user) {
                  if (user == null) return const SizedBox();
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primaryLight,
                        child: Text(
                          user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                          style: AppTextStyles.h1.copyWith(color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(user.name, style: AppTextStyles.h3),
                      Text(user.email, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      const SizedBox(height: AppSpacing.xl),
                      _buildMenuItem(Icons.person, 'Account Settings', () {}),
                      _buildMenuItem(Icons.notifications, 'Notifications', () {}),
                      _buildMenuItem(Icons.security, 'Privacy & Security', () {}),
                      _buildMenuItem(Icons.help, 'Help & Support', () {}),
                      const SizedBox(height: AppSpacing.lg),
                      _buildMenuItem(
                        Icons.logout,
                        'Logout',
                        () => ref.read(authProvider.notifier).logout(),
                        isDestructive: true,
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                error: (_, __) => const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap, {bool isDestructive = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md, horizontal: AppSpacing.lg),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            Icon(icon, color: isDestructive ? AppColors.error : AppColors.textSecondary),
            const SizedBox(width: AppSpacing.md),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDestructive ? AppColors.error : AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
