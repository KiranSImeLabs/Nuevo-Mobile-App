import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import 'widgets/consent_option_card.dart';
import 'widgets/legal_option_tile.dart';

class PrivacyConsentScreen extends StatefulWidget {
  const PrivacyConsentScreen({super.key});

  @override
  State<PrivacyConsentScreen> createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends State<PrivacyConsentScreen> {
  // Local state for demonstration purposes
  bool _dataSharing = true;
  bool _researchParticipation = false;
  bool _communicationPreferences = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppStrings.privacyAndConsent,
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
              // Consents Section
              Text(
                AppStrings.consents,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFF4A4A4A),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              
              ConsentOptionCard(
                title: AppStrings.dataSharingConsent,
                subtitle: AppStrings.dataSharingSubtitle,
                value: _dataSharing,
                onChanged: (val) => setState(() => _dataSharing = val),
                onTapDetails: () {
                  // TODO: Navigate to Data Sharing details
                },
              ),
              
              ConsentOptionCard(
                title: AppStrings.researchParticipation,
                subtitle: AppStrings.researchSubtitle,
                value: _researchParticipation,
                onChanged: (val) => setState(() => _researchParticipation = val),
                onTapDetails: () {
                  // TODO: Navigate to Research Participation details
                },
              ),
              
              ConsentOptionCard(
                title: AppStrings.communicationPreferences,
                subtitle: AppStrings.communicationSubtitle,
                value: _communicationPreferences,
                onChanged: (val) => setState(() => _communicationPreferences = val),
                onTapDetails: () {
                  // TODO: Navigate to Communication Preferences details
                },
              ),

              const SizedBox(height: 32),

              // Legal Section
              Text(
                AppStrings.legal,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: const Color(0xFF4A4A4A),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),

              LegalOptionTile(
                title: AppStrings.privacyPolicy,
                onTap: () {
                  // TODO: Navigate to Privacy Policy
                },
              ),
              
              LegalOptionTile(
                title: AppStrings.termsOfService,
                onTap: () {
                  // TODO: Navigate to Terms of Service
                },
              ),
              
              LegalOptionTile(
                title: AppStrings.dataProtection,
                onTap: () {
                  // TODO: Navigate to Data Protection
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
