import 'package:equatable/equatable.dart';
import '../task.dart';
import '../wellness_program.dart';
import 'welcome_data.dart';
import 'wellness_progress.dart';
import 'quick_stats.dart';
import 'home_quick_access_item.dart';

export 'welcome_data.dart';
export 'wellness_progress.dart';
export 'quick_stats.dart';
export 'home_quick_access_item.dart';

class HomeDashboard extends Equatable {
  final WelcomeData welcome;
  final WellnessProgress wellnessProgress;
  final QuickStats quickStats;
  final List<Task> actionRequired;
  final List<Task> tasksCompleted;
  final WellnessProgram? yourProgram;
  final List<HomeQuickAccessItem> quickAccess;

  const HomeDashboard({
    required this.welcome,
    required this.wellnessProgress,
    required this.quickStats,
    required this.actionRequired,
    required this.tasksCompleted,
    this.yourProgram,
    required this.quickAccess,
  });

  @override
  List<Object?> get props => [
        welcome,
        wellnessProgress,
        quickStats,
        actionRequired,
        tasksCompleted,
        yourProgram,
        quickAccess,
      ];
}
