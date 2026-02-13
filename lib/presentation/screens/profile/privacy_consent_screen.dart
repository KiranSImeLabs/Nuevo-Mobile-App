import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class PrivacyConsentScreen extends StatelessWidget {
  const PrivacyConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Privacy & Consent',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              _buildSettingItem(context, 'Data Sharing', true),
              _buildSettingItem(context, 'Marketing Communications', false),
              _buildSettingItem(context, 'Analytics', true),
              const SizedBox(height: 24),
              _buildLinkItem(context, 'Terms and Conditions'),
              _buildLinkItem(context, 'Privacy Policy'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, String title, bool value) {
    // Mock state for now
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
          Switch(
            value: value, 
            onChanged: (val) {},
            activeColor: const Color(0xFF964A38),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkItem(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF8D6E63)),
        ],
      ),
    );
  }
}
