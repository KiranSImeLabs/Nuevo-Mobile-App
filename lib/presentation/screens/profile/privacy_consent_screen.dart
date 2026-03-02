import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../presentation/providers/preferences_provider.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_theme.dart';
import 'widgets/consent_option_card.dart';
import 'widgets/legal_option_tile.dart';
import '../../widgets/common/app_webview.dart';

class PrivacyConsentScreen extends ConsumerStatefulWidget {
  const PrivacyConsentScreen({super.key});

  @override
  ConsumerState<PrivacyConsentScreen> createState() => _PrivacyConsentScreenState();
}

class _PrivacyConsentScreenState extends ConsumerState<PrivacyConsentScreen> {


  @override
  Widget build(BuildContext context) {
    final preferencesState = ref.watch(preferencesProvider);
    final consent = preferencesState.data.consent;

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
        child: preferencesState.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                      value: consent.dataSharingConsent,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateConsentPreferences(dataSharingConsent: val),
                      onTapDetails: () {
                        // TODO: Navigate to Data Sharing details
                      },
                    ),
                    
                    ConsentOptionCard(
                      title: AppStrings.researchParticipation,
                      subtitle: AppStrings.researchSubtitle,
                      value: consent.researchParticipation,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateConsentPreferences(researchParticipation: val),
                      onTapDetails: () {
                        // TODO: Navigate to Research Participation details
                      },
                    ),
                    
                    ConsentOptionCard(
                      title: AppStrings.communicationPreferences,
                      subtitle: AppStrings.communicationSubtitle,
                      value: consent.communicationPreferences,
                      onChanged: (val) => ref
                          .read(preferencesProvider.notifier)
                          .updateConsentPreferences(
                              communicationPreferences: val),
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
                         AppWebView.open(
                          context,
                          url: AppStrings.privacyPolicyUrl,
                          title: AppStrings.privacyPolicy,
                        );
                      },
                    ),
                    
                    LegalOptionTile(
                      title: AppStrings.termsOfService,
                      onTap: () {
                        AppWebView.open(
                          context,
                          url: AppStrings.termsOfServiceUrl,
                          title: AppStrings.termsOfService,
                        );
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
