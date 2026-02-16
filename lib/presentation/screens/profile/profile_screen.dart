import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';
import '../../../core/theme/app_theme.dart';
import 'widgets/logout_bottom_sheet.dart';
import '../../widgets/profile_image_picker_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  File? _selectedImage;

  void _handleImageSelection(File image) {
    setState(() {
      _selectedImage = image;
    });
    // TODO: Implement actual upload logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image selected for upload')),
    );
  }

  void _showImagePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ProfileImagePickerSheet(
        onImageSelected: _handleImageSelection,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Info Card
              userState.when(
                data: (user) {
                  final name = user?.name ?? 'Warren I. Ford';
                  final email = user?.email ?? 'sarah.johnson@email.com';
                  
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5EAE8), // Pinkish/Beige
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        // Avatar with Edit Icon
                        Stack(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey,
                                image: DecorationImage(
                                  image: _selectedImage != null
                                      ? FileImage(_selectedImage!) as ImageProvider
                                      : const AssetImage('assets/images/details_image.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Fallback if asset missing (won't show if image provider works)
                              child: _selectedImage == null 
                                  ? const SizedBox() // Assume asset exists or logic handles it
                                  : null, 
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _showImagePicker,
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF8D6E63), // Brown
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: AppTextStyles.h3.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF8D6E63), // Brownish text
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const SizedBox(),
              ),
              
              const SizedBox(height: 32),
              
              Text(
                'Settings',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              // Settings List
              _buildSettingsTile(
                context,
                icon: Icons.person_outline,
                label: 'Account Settings',
                onTap: () => context.push('/account-settings'),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.shield_outlined, // Privacy
                label: 'Privacy & consent',
                onTap: () => context.push('/privacy-consent'),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.account_balance_wallet_outlined,
                label: 'Payments',
                onTap: () => context.push('/payments'),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.notifications_outlined,
                label: 'Notification',
                onTap: () => context.push('/notifications'),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.medical_services_outlined, // Doctor
                label: 'Doctor List',
                onTap: () => context.push('/doctor-list'),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.headset_mic_outlined, // Support
                label: 'Support',
                onTap: () => context.push('/support'),
              ),
              _buildSettingsTile(
                context,
                icon: Icons.power_settings_new,
                label: 'Logout',
                onTap: () {
                   showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const LogoutBottomSheet(),
                  );
                },
                isLast: true, 
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8), // Pinkish/Beige background for tiles
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: const Color(0xFF8D6E63), size: 20),
        ),
        title: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
