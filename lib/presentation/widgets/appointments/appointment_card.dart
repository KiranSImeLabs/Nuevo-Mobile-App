import 'package:flutter/material.dart';
import '../../utils/responsive_utils.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/session.dart';

enum AppointmentCardType {
  schedule,
  upcoming,
  past,
}

class AppointmentCard extends StatelessWidget {
  final Session session;
  final AppointmentCardType type;
  final VoidCallback? onActionTap;

  const AppointmentCard({
    super.key,
    required this.session,
    required this.type,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    // Determine card styling based on type
    final isSchedule = type == AppointmentCardType.schedule;
    final isPast = type == AppointmentCardType.past;
    
    final backgroundColor = isSchedule 
        ? const Color(0xFFF5EAE8) // Updated per user request
        : const Color(0xFFF5EAE8);
        // Actually, screenshot shows:
        // Schedule: Pinkish
        // Upcoming: Pinkish
        // Past: Pinkish/Greyish? They look similar in the screenshot, maybe slight variation.
        // Let's stick to the subtle pink/beige for all cards as per general theme, 
        // but maybe differentiate based on exact design if needed.
        // Screenshot check:
        // "Sessions to Schedule": Pinkish bg
        // "Upcoming": Pinkish bg
        // "Past Appointments": Pinkish bg
        // They all seem to share the same card background color: Color(0xFFF9F3F1) or similar.

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, base: 12)),
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon/Avatar
              Container(
                width: ResponsiveUtils.spacing(context, base: 40),
                height: ResponsiveUtils.spacing(context, base: 40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  // If it's a person (Upcoming/Past), maybe show image. 
                  // For now using icons as placeholder or simple logic.
                  // Screenshot shows icons for "Nutrition", "Check-in", and Photos for Doctors.
                ),
                alignment: Alignment.center,
                child: _buildIcon(context),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, base: 12)),
              
              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.title,
                      style: AppTextStyles.h3.copyWith(
                        fontWeight: FontWeight.w400,
                        fontSize: ResponsiveUtils.fontSize(context, base: 16),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getSubtitle(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: ResponsiveUtils.fontSize(context, base: 13),
                      ),
                    ),
                    if (type != AppointmentCardType.schedule && !isPast) ...[
                       const SizedBox(height: 8),
                       _buildTimeInfo(context),
                    ],
                    // For past appointments, we also see date/time in subtitle usually, or below.
                    // Screenshot: "Dr. Sarah Martinez • Dec 20, 2024"
                    // This is sufficient in subtitle for past.
                  ],
                ),
              ),
            ],
          ),
          
          // Action Button (Only for Schedule and Upcoming)
          if (!isPast) ...[
            SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
            _buildActionButton(context),
          ],
        ],
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    // If we had real avatars, we'd use them here.
    // For now, simple icons based on title or type.
    if (type == AppointmentCardType.upcoming || session.professionalName != null) {
        // In a real app complexity, we'd look for an avatar URL.
        // Returning a generic person icon or specific icon.
        // Screenshot shows photos for upcoming.
        return Icon(
          Icons.person,
          color: AppColors.primaryColor,
          size: ResponsiveUtils.iconSize(context, base: 24),
        );
    }
    
    // Default icons for "Schedule" items
    return Icon(
      Icons.assignment_outlined, // Placeholder
      color: const Color(0xFF964A38),
      size: ResponsiveUtils.iconSize(context, base: 20),
    );
  }

  String _getSubtitle() {
    if (session.professionalName != null) {
      if (type == AppointmentCardType.schedule) {
         return '${session.professionalName} • ${session.durationMinutes} min';
      }
      if (type == AppointmentCardType.past) {
        // Format: Dr. Name • Date
         // Using a simple date formatter or static string for mock
         return '${session.professionalName} • Dec 20, 2024'; 
      }
      return session.professionalName!;
    }
    return '${session.durationMinutes} min';
  }

  Widget _buildTimeInfo(BuildContext context) {
      // "Today   2:30PM   Virtual Visit"
      return Row(
          children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('Today', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text('2:30PM', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              // Add Virtual/Location if needed
          ],
      );
  }

  Widget _buildActionButton(BuildContext context) {
    final label = type == AppointmentCardType.schedule ? 'Book time' : 'Join Now';
    
    return GestureDetector(
      onTap: onActionTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF964A38).withOpacity(0.5)),
          borderRadius: BorderRadius.circular(8),
          color: Colors.transparent, // Transparent inside as per design, just border
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: const Color(0xFF964A38),
                fontSize: ResponsiveUtils.fontSize(context, base: 14),
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.arrow_forward,
              size: ResponsiveUtils.iconSize(context, base: 16),
              color: const Color(0xFF964A38),
            ),
          ],
        ),
      ),
    );
  }
}
