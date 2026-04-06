import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../domain/entities/preferences.dart';
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
  ConsentPreferences? _localConsent;

  String _getConsentName(String key) {
    switch (key) {
      case 'dataSharingConsent': return AppStrings.dataSharingConsent;
      case 'researchParticipation': return AppStrings.researchParticipation;
      case 'communicationPreferences': return AppStrings.communicationPreferences;
      default: return 'Consent';
    }
  }

  void _toggleSetting(String key, bool newValue) async {
    if (_localConsent == null) return;

    // 1. Optimistically update local state
    setState(() {
      switch (key) {
        case 'dataSharingConsent':
          _localConsent = _localConsent!.copyWith(dataSharingConsent: newValue);
          break;
        case 'researchParticipation':
          _localConsent = _localConsent!.copyWith(researchParticipation: newValue);
          break;
        case 'communicationPreferences':
          _localConsent = _localConsent!.copyWith(communicationPreferences: newValue);
          break;
      }
    });

    final notifier = ref.read(preferencesProvider.notifier);

    // 2. Call provider API
    try {
      switch (key) {
        case 'dataSharingConsent':
          await notifier.updateConsentPreferences(dataSharingConsent: newValue);
          break;
        case 'researchParticipation':
          await notifier.updateConsentPreferences(researchParticipation: newValue);
          break;
        case 'communicationPreferences':
          await notifier.updateConsentPreferences(communicationPreferences: newValue);
          break;
      }

      final error = ref.read(preferencesProvider).error;
      if (error != null) {
        // Failed! Revert
        if (mounted) {
          setState(() {
            _localConsent = ref.read(preferencesProvider).data.consent;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to update ${_getConsentName(key)}. Reverted.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      } else {
        // Success!
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${_getConsentName(key)} ${newValue ? 'enabled' : 'disabled'} successfully.'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _localConsent = ref.read(preferencesProvider).data.consent;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('An unexpected error occurred.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final preferencesState = ref.watch(preferencesProvider);
    
    // Initialize or sync local state if we aren't loading
    // Because _updatePreferences sets isLoading=true, and then false when done.
    if (_localConsent == null || !preferencesState.isLoading && ref.read(preferencesProvider).error == null) {
      _localConsent = preferencesState.data.consent;
    }

    final consent = _localConsent!;

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
        child: Stack(
          children: [
            SingleChildScrollView(
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
                    onChanged: (val) => _toggleSetting('dataSharingConsent', val),
                    onTapDetails: () {
                      // TODO: Navigate to Data Sharing details
                    },
                  ),
                  
                  ConsentOptionCard(
                    title: AppStrings.researchParticipation,
                    subtitle: AppStrings.researchSubtitle,
                    value: consent.researchParticipation,
                    onChanged: (val) => _toggleSetting('researchParticipation', val),
                    onTapDetails: () {
                      // TODO: Navigate to Research Participation details
                    },
                  ),
                  
                  ConsentOptionCard(
                    title: AppStrings.communicationPreferences,
                    subtitle: AppStrings.communicationSubtitle,
                    value: consent.communicationPreferences,
                    onChanged: (val) => _toggleSetting('communicationPreferences', val),
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
            if (preferencesState.isLoading)
              Container(
                color: Colors.white.withAlpha(128),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
