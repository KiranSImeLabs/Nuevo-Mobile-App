import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/home_provider.dart';
import '../../../domain/entities/task.dart';
import '../../utils/responsive_utils.dart';
import '../../../core/theme/app_theme.dart';

class TaskDetailScreen extends ConsumerWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(homeDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F8),
      appBar: AppBar(
        title: const Text(
          'Task Details',
          style: TextStyle(
            color: Color(0xFF17110D),
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF17110D)),
          onPressed: () => context.pop(),
        ),
      ),
      body: dashboardState.when(
        data: (dashboard) {
          // Find task in either list
          final task = _findTask(dashboard.actionRequired, dashboard.tasksCompleted, taskId);

          if (task == null) {
            return const Center(child: Text('Task not found'));
          }

          return SingleChildScrollView(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image or Icon
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    image: task.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(task.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: task.imageUrl == null
                      ? Icon(Icons.task, size: 64, color: Colors.grey[400])
                      : null,
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),

                // Title
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF17110D),
                    height: 1.3,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),

                // Metadata Row
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildMetaChip(Icons.access_time, '${task.durationMinutes} min'),
                    _buildMetaChip(Icons.category, task.type.name.toUpperCase()),
                    if (task.isCompleted)
                        _buildMetaChip(Icons.check_circle, 'COMPLETED', color: Colors.green),
                  ],
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 32)),

                // Description Header
                Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF17110D),
                  ),
                ),
                SizedBox(height: 12),
                
                // Description Body
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Text(
                    task.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Task? _findTask(List<Task> actions, List<Task> completed, String id) {
    try {
      return actions.firstWhere((t) => t.id == id);
    } catch (_) {
      try {
        return completed.firstWhere((t) => t.id == id);
      } catch (_) {
        return null;
      }
    }
  }

  Widget _buildMetaChip(IconData icon, String label, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: (color ?? const Color(0xFF964A38)).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (color ?? const Color(0xFF964A38)).withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? const Color(0xFF964A38)),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color ?? const Color(0xFF964A38),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
