import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Support',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support Options',
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              
              _buildSupportCard(
                context,
                icon: Icons.help_outline,
                title: 'Help centre',
                subtitle: 'Browse common questions',
                actionText: 'View Help',
                onTap: () {},
              ),
              
              const SizedBox(height: 16),
              
              _buildSupportCard(
                context,
                icon: Icons.people_outline,
                title: 'Contact your care team',
                subtitle: 'Get in touch directly',
                actionText: 'Contact Care Team',
                onTap: () {},
              ),
              
              const SizedBox(height: 16),
              
              _buildSupportCard(
                context,
                icon: Icons.chat_bubble_outline,
                title: 'Technical support',
                subtitle: 'App or login issues',
                actionText: 'Contact Support',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSupportCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8), // Pinkish background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF8D6E63), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: const Color(0xFF8D6E63), // Brownish
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onTap,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  actionText,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF8D6E63), // Brown
                    fontWeight: FontWeight.w600,
                  ), // Using generic style
                ),
                const Icon(Icons.arrow_forward, size: 20, color: Color(0xFF8D6E63)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
