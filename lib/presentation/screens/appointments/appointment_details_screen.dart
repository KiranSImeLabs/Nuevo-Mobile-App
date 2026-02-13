import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';
import 'confirm_booking_screen.dart'; // For BookingConfirmationArgs
import 'package:go_router/go_router.dart';

class AppointmentDetailsScreen extends StatelessWidget {
  final BookingConfirmationArgs args;

  const AppointmentDetailsScreen({
    super.key,
    required this.args,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Appointment details',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Session Title
              Text(
                args.session.title, // e.g., "Dietitian review"
                style: AppTextStyles.h3.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              // Provider Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EAE8), // Pinkish
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Avatar
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const Icon(Icons.person, color: AppColors.primaryColor), // Placeholder
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'With',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                args.session.professionalName ?? 'Dr. Sarah Smith', // Fallback or from session
                                style: AppTextStyles.h3.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: Color(0xFFE0E0E0), height: 1),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8D5D1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Upcoming',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primaryButtonColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Date & Time Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EAE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      label: 'Date and Time',
                      value: 'Today', // Logic for "Today" vs Date needed, but for now fixed or formatted
                      subValue: DateFormat('EEEE, d MMMM').format(args.selectedDate),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'Start time',
                      value: args.selectedTime,
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.timer_outlined,
                      label: 'Duration',
                      value: '${args.session.durationMinutes} minutes',
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(
                      icon: Icons.videocam_outlined,
                      label: 'Session type',
                      value: 'Virtual consultation',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // About this session
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EAE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About this session',
                      style: AppTextStyles.h3.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This session is part of your Insight Program and focuses on nutrition review and guidance.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Notification Alert
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF9DB), // Yellow
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 4,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFC107),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.notifications_none, size: 20, color: Color(0xFF5D4037)),
                              const SizedBox(width: 8),
                              Text(
                                'Notification Alert',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF5D4037),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Divider(color: Color(0xFFEBE0C0), height: 1),
                          const SizedBox(height: 8),
                          Text(
                            "You'll receive a reminder before the session begins.",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),

              // Join Session Button
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.push('/connecting-session');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF964A38),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.videocam_outlined, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Join Session',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Opens secure video call',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    String? subValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF964A38)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  if (subValue != null)
                    Text(
                      subValue,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
