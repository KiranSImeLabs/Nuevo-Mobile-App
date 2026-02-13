import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class ClinicianProfileScreen extends StatelessWidget {
  final String name;
  final String role;
  final String? imageUrl; // For future real image
  final String? bio; // Optional bio override

  const ClinicianProfileScreen({
    super.key,
    required this.name,
    required this.role,
    this.imageUrl,
    this.bio,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(AppStrings.clinicianProfile),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildAboutSection(),
              const SizedBox(height: 24),
              _buildRoleCard(),
              const SizedBox(height: 24),
              _buildSessionsSection(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.roseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey.shade300,
            backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
            child: imageUrl == null
                ? Icon(Icons.person, size: 40, color: Colors.grey.shade600)
                : null,
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              // Using slightly brownish/red color for role based on design if needed
            //    color: const Color(0xFF8D6E63), 
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.call_outlined,
            label: AppStrings.call,
            onTap: () {}, // TODO: Implement Call
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            icon: Icons.videocam_outlined,
            label: AppStrings.video,
            onTap: () {}, // TODO: Implement Video
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 80, // Approximate height from design
      decoration: BoxDecoration(
        color: AppColors.roseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF8D6E63), // Brownish icon color
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                color: const Color(0xFF2C2C2C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.about,
          style: AppTextStyles.h4.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: const Color(0xFF4A4A4A),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
           decoration: BoxDecoration(
            color: AppColors.roseSurface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            bio ?? AppStrings.aboutDrSarah, // Use provided bio or default fallback
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoleCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4).withOpacity(0.5), // Pale yellow/gold background
         borderRadius: BorderRadius.circular(16),
         border: Border(
           left: BorderSide(color: Colors.amber.shade300, width: 4), // Left accent border
         )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Row(
             children: [
               Icon(Icons.groups_outlined, size: 20, color: Colors.brown.shade700),
               const SizedBox(width: 8),
               Text(
                AppStrings.yourCareTeamRole,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.brown.shade800,
                ),
              ),
             ],
           ),
          const SizedBox(height: 8),
          Text(
            AppStrings.roleDescription,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.brown.shade800,
              height: 1.4,
               fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsSection(BuildContext context) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            AppStrings.sessions,
            style: AppTextStyles.h4.copyWith(
              fontWeight: FontWeight.w500,
               fontSize: 16,
                color: const Color(0xFF4A4A4A),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
             decoration: BoxDecoration(
              color: AppColors.roseSurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildSessionItem(AppStrings.scheduledConsultations),
                const SizedBox(height: 12),
                _buildSessionItem(AppStrings.programReviews),
                const SizedBox(height: 12),
                _buildSessionItem(AppStrings.ongoingGuidance),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(color: Color(0xFFE0E0E0)),
                ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, size: 18, color: AppColors.textSecondary),
                           const SizedBox(width: 8),
                          Text(
                            AppStrings.nextAvailable,
                            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                       Text(
                        "Tuesday · 11:30 AM", // Mock data
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                           color: const Color(0xFF4A4A4A),
                        ),
                      ),
                   ],
                 ),
                 const SizedBox(height: 24),
                 SizedBox(
                   width: double.infinity,
                   child: ElevatedButton(
                     onPressed: () {
                       // TODO: View Appointments
                     },
                     style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryButtonColor,
                         foregroundColor: Colors.white,
                         padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         const Text(AppStrings.viewAppointments),
                         const SizedBox(width: 8),
                         const Icon(Icons.arrow_forward, size: 18),
                       ],
                     ),
                   ),
                 )
              ],
            ),
          ),
        ],
      );
  }

  Widget _buildSessionItem(String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF8D6E63), width: 1.5),
          ),
          child: const Icon(Icons.check, size: 12, color:  Color(0xFF8D6E63)),
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: AppTextStyles.bodyMedium.copyWith(
             color: const Color(0xFF4A4A4A),
          ),
        ),
      ],
    );
  }
}
