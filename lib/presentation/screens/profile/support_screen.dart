import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import 'widgets/support_option_tile.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.support,
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
                AppStrings.supportOptions,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFF4A4A4A),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              
              SupportOptionTile(
                icon: Icons.help_outline,
                title: AppStrings.helpCentre,
                subtitle: AppStrings.browseQuestions,
                actionText: AppStrings.viewHelp,
                onTap: () {
                  // TODO: Navigate to Help Centre
                },
              ),
              
              SupportOptionTile(
                icon: Icons.people_outline,
                title: AppStrings.contactCareTeam,
                subtitle: AppStrings.getInTouch,
                actionText: AppStrings.contactCareTeamAction,
                onTap: () {
                  // TODO: Navigate to Contact Care Team
                },
              ),
              
              SupportOptionTile(
                icon: Icons.chat_bubble_outline,
                title: AppStrings.technicalSupport,
                subtitle: AppStrings.appIssues,
                actionText: AppStrings.contactSupport,
                onTap: () {
                  // TODO: Navigate to Technical Support
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
