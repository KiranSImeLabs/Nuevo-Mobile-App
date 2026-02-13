import '../../../domain/entities/home/home_dashboard.dart';
import '../../../domain/entities/task.dart';
import '../../../domain/entities/wellness_program.dart';
import '../wellness_program_model.dart';
import 'welcome_data_model.dart';
import 'wellness_progress_model.dart';
import 'quick_stats_model.dart';
import 'home_quick_access_item_model.dart';

class HomeDashboardModel extends HomeDashboard {
  const HomeDashboardModel({
    required super.welcome,
    required super.wellnessProgress,
    required super.quickStats,
    required super.actionRequired,
    required super.tasksCompleted,
    super.yourProgram,
    required super.quickAccess,
  });

  factory HomeDashboardModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return HomeDashboardModel(
      welcome: WelcomeDataModel.fromJson(data['welcome']),
      wellnessProgress: WellnessProgressModelResponse.fromJson(data['wellnessProgress']),
      quickStats: QuickStatsModel.fromJson(data['quickStats']),
      actionRequired: (data['actionRequired'] as List<dynamic>?)
              ?.map((e) => _parseTask(e))
              .toList() ??
          [],
      tasksCompleted: (data['tasksCompleted'] as List<dynamic>?)
              ?.map((e) => _parseTask(e))
              .toList() ??
          [],
      yourProgram: data['yourProgram'] != null
          ? WellnessProgramModel.fromJson(data['yourProgram']).toEntity()
          : null,
      quickAccess: (data['quickAccess'] as List<dynamic>?)
              ?.map((e) => HomeQuickAccessItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }

  static Task _parseTask(Map<String, dynamic> json) {
    // Parse duration string "5 minutes" to int 5
    int duration = 0;
    if (json['duration'] != null) {
      final durationStr = json['duration'].toString();
      final digits =  durationStr.replaceAll(RegExp(r'[^0-9]'), '');
      duration = int.tryParse(digits) ?? 0;
    }

    return Task(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Unknown Task',
      description: '', // Not in API
      durationMinutes: duration,
      imageUrl: json['thumbnail'],
      isCompleted: (json['status'] as String?)?.toLowerCase() == 'completed',
      type: TaskType.general, // Default as not in API
      dueDate: null,
      completedAt: null,
    );
  }

  HomeDashboard toEntity() {
    return this;
  }
}
