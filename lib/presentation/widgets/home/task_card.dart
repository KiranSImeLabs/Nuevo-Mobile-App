import 'package:flutter/material.dart';
import '../../../domain/entities/task.dart' as entities;
import '../../utils/responsive_utils.dart';

/// Task card widget for displaying individual tasks
class TaskCard extends StatelessWidget {
  final entities.Task task;
  final VoidCallback? onTap;
  final double? width;

  const TaskCard({
    Key? key,
    required this.task,
    this.onTap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive width: 75% of screen on mobile, fixed 268 on larger screens
        // OR use provided width
        final cardWidth = width ?? (ResponsiveUtils.isSmallScreen(context) 
            ? MediaQuery.of(context).size.width * 0.75 
            : 268.0); 

        return GestureDetector(
          onTap: onTap,
          child: Container(
            width: cardWidth,
            height: 92, // Fixed height per spec
            margin: EdgeInsets.only(
              right: ResponsiveUtils.spacing(context, base: 12),
              bottom: 4, // shadow allowance
            ),
            padding: const EdgeInsets.all(10), // Padding 10 per spec
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12), // Radius 12 per spec
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Task Image
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 72, // Adjusted to fit 92 height - 20 padding
                    height: 72,
                    color: Colors.grey[200],
                    child: task.imageUrl != null
                        ? Image.network(
                            task.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => _buildPlaceholderImage(context),
                          )
                        : _buildPlaceholderImage(context),
                  ),
                ),
                const SizedBox(width: 8), // Gap 8 per spec
                
                // Task Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center, // Center vertically
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(context, base: 14), // Reduced slightly to 14 to fit better if 2 lines
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1E1E1E),
                          height: 1.2, // Tighter line height
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(), // Use Spacer to push content apart slightly if needed, or just SizedBox
                      
                      // Duration & Action Row combined or separate? 
                      // Spec image has them separate lines or same? 
                      // "Pre-session questionnaire" (Title)
                      // "5 minutes" (Time)
                      // "Complete Now ->" (Action)
                      // 3 lines might be tight in 72px.
                      // Let's check: 
                      // Title (2 lines max): ~34px
                      // Time: 12px
                      // Action: 14px
                      // 34+12+14 = 60. + Spacing.
                      
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12, // Smaller icon
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${task.durationMinutes} minutes',
                            style: TextStyle(
                              fontSize: ResponsiveUtils.fontSize(context, base: 12),
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4), // Tight spacing

                      // Action or Status
                      if (task.isCompleted)
                        Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 14,
                              color: Color(0xFF4CAF50), // Green for success
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Completed',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4CAF50),
                              ),
                            ),
                          ],
                        )
                      else
                        Row(
                          children: [
                            Text(
                              'Complete Now',
                              style: TextStyle(
                                fontSize: 12, // Reduced to 12 matches spec image better usually for action link
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF964A38),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward,
                              size: 12,
                              color: Color(0xFF964A38),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Build placeholder image when no image is available
  Widget _buildPlaceholderImage(BuildContext context) {
    return Center(
      child: Icon(
        _getTaskIcon(),
        size: ResponsiveUtils.iconSize(context, base: 32),
        color: Colors.grey[400],
      ),
    );
  }

  /// Get icon based on task type
  IconData _getTaskIcon() {
    switch (task.type) {
      case entities.TaskType.questionnaire:
        return Icons.assignment_outlined;
      case entities.TaskType.exercise:
        return Icons.fitness_center_outlined;
      case entities.TaskType.nutrition:
        return Icons.restaurant_outlined;
      case entities.TaskType.appointment:
        return Icons.calendar_today_outlined;
      case entities.TaskType.general:
      default:
        return Icons.task_outlined;
    }
  }
}
