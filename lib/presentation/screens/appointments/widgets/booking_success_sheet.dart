import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../domain/entities/session.dart';
import '../confirm_booking_screen.dart'; // For BookingConfirmationArgs

class BookingSuccessSheet extends StatelessWidget {
  final Session session;
  final DateTime selectedDate;
  final String selectedTime;

  const BookingSuccessSheet({
    super.key,
    required this.session,
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 48,
              height: 4,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          // Success Icon
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Color(0xFFA65C4B), // Brown/Redish color
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          
          Text(
            'Session booked',
            style: AppTextStyles.h3.copyWith(fontSize: 24, fontWeight: FontWeight.normal),
          ),
          const SizedBox(height: 12),
          
          Text(
            "Your appointment has been added to your schedule. We'll send you a reminder before the session.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          
          // Appointment Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EAE8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
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
                        // image: DecorationImage(...)
                      ),
                      // child: ClipRRect(
                      //   borderRadius: BorderRadius.circular(24),
                      //   child: Image.asset('assets/images/details_image.png', fit: BoxFit.cover),
                      // ), 
                        child: const Icon(Icons.person, color: AppColors.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.professionalName ?? 'Specialist',
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${session.title} • ${session.durationMinutes} min',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(color: Color(0xFFE0E0E0), height: 1),
                const SizedBox(height: 16),
                
                // Date & Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18, color: Color(0xFF5D4037)),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, MMMM d, yyyy').format(selectedDate),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF5D4037),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18, color: Color(0xFF5D4037)),
                    const SizedBox(width: 8),
                    Text(
                      selectedTime, // simplistic, normally range: "10:00 AM - 10:30 AM"
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: const Color(0xFF5D4037),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Action Button
           ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close sheet
              
              final args = BookingConfirmationArgs(
                session: session,
                selectedDate: selectedDate,
                selectedTime: selectedTime,
              );
              
              context.push('/appointment-details', extra: args);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryButtonColor,
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
                Text(
                  'View Appointment',
                  style: AppTextStyles.button.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 24), // Safe area margin bottom
        ],
      ),
    );
  }
}
