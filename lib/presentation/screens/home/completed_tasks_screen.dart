import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/home_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/home/task_card.dart';
import '../../widgets/common/app_error_widget.dart';

class CompletedTasksScreen extends ConsumerWidget {
  const CompletedTasksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(homeDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F8),
      appBar: AppBar(
        title: const Text(
          'Completed Tasks',
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
          final tasks = dashboard.tasksCompleted;


          if (tasks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No completed tasks yet',
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
            separatorBuilder: (context, index) => SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
            itemBuilder: (context, index) {
              return TaskCard(
                task: tasks[index],
                width: double.infinity,
                onTap: () => context.push('/task/${tasks[index].id}'),
              );
            },
          );
        },
        loading: () {

          return const Center(child: CircularProgressIndicator());
        },
        error: (err, _) => AppErrorWidget(message: err.toString()),
      ),
    );
  }
}
