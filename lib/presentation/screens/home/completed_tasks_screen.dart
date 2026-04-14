import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/phase_provider.dart';
import '../../providers/core_providers.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/home/task_card.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../../domain/entities/task.dart' as entities;
import '../../../data/models/phase_model.dart';

class CompletedTasksScreen extends ConsumerWidget {
  /// When [showCompleted] is true, shows tasks where isCompleted == true.
  /// When false, shows tasks where isCompleted == false (Action Required).
  final bool showCompleted;

  const CompletedTasksScreen({super.key, this.showCompleted = true});

  entities.Task _mapPatientTaskToEntity(PatientTaskModel pTask) {
    entities.TaskType type;
    final String actualType = (pTask.taskType.isNotEmpty ? pTask.taskType : (pTask.phaseTask?.taskType ?? '')).toUpperCase();
    
    switch (actualType) {
      case 'QUESTIONNAIRE':
        type = entities.TaskType.questionnaire;
        break;
      case 'APPOINTMENT':
        type = entities.TaskType.appointment;
        break;
      case 'EXERCISE':
        type = entities.TaskType.exercise;
        break;
      case 'NUTRITION':
        type = entities.TaskType.nutrition;
        break;
      default:
        type = entities.TaskType.general;
    }
    return entities.Task(
      id: pTask.id,
      title: pTask.taskName.isNotEmpty ? pTask.taskName : (pTask.phaseTask?.title ?? 'Task'),
      description: pTask.phaseTask?.description ?? '',
      durationMinutes: pTask.phaseTask?.points ?? 5,
      isCompleted: pTask.legacyStatus == 'COMPLETED' || pTask.status == 'COMPLETED',
      type: type,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activePhaseState = ref.watch(activePhaseProvider);

    final String title = showCompleted ? 'Completed Tasks' : 'Action Required';
    final String emptyMessage =
        showCompleted ? 'No completed tasks yet' : 'No pending actions';
    final IconData emptyIcon =
        showCompleted ? Icons.check_circle_outline : Icons.task_alt_outlined;

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F8),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
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
      body: activePhaseState.when(
        data: (activePhase) {
          final patientTasks = activePhase.tasks.where((t) {
            final isTCompleted = t.legacyStatus == 'COMPLETED' || t.status == 'COMPLETED';
            return isTCompleted == showCompleted;
          }).toList();

          final tasks = patientTasks.map(_mapPatientTaskToEntity).toList();

          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    emptyIcon,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    emptyMessage,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 20)),
            itemCount: tasks.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
            itemBuilder: (context, index) {
              return TaskCard(
                task: tasks[index],
                width: double.infinity,
                onTap: tasks[index].isCompleted ? null : () async {
                  final pTask = patientTasks[index];
                  final type = (pTask.taskType.isNotEmpty ? pTask.taskType : (pTask.phaseTask?.taskType ?? '')).toUpperCase();
                  
                  if (type == 'QUESTIONNAIRE') {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (ctx) => const Center(child: CircularProgressIndicator()),
                    );
                    
                    // Yield the frame to ensure the dialog is fully pushed before popping
                    await Future.delayed(const Duration(milliseconds: 100));
                    
                    try {
                      final response = await ref.read(apiClientProvider).getTaskById(pTask.id);
                      if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
                      
                      if (response.success && response.data != null) {
                        final qId = response.data!.phaseTask?.questionnaireId;
                        if (qId != null && qId.isNotEmpty) {
                          if (context.mounted) context.push('/questionnaire/$qId/${pTask.id}');
                        } else {
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Questionnaire ID not found for this task')),
                          );
                        }
                      } else {
                        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(response.message ?? 'Failed to fetch task details')),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error fetching task: $e')),
                        );
                      }
                    }
                  } else if (type == 'APPOINTMENT') {
                    context.push('/connecting-session');
                  } else {
                    context.push('/task/${pTask.id}');
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => AppErrorWidget(
          message: err.toString(),
          onRetry: () => ref.read(activePhaseProvider.notifier).fetchActivePhase(),
        ),
      ),
    );
  }
}
