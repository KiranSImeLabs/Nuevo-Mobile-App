import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../providers/home_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/task.dart' as entities;
import '../../../domain/entities/wellness_program.dart';
import '../../../domain/entities/home/home_dashboard.dart';
import '../../utils/responsive_utils.dart';
import '../../widgets/home/wellness_card.dart';
import '../../widgets/home/info_card.dart';
import '../../widgets/home/task_card.dart';
import '../../widgets/home/program_card.dart';
import '../../widgets/home/quick_access_grid.dart';
import '../../widgets/home/quick_access_card.dart';
import '../../widgets/home/dietitian_session_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(homeDashboardProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFDF9F8),
      body: dashboardState.when(
        data: (dashboard) {
          return SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: () async {
                return ref.refresh(homeDashboardProvider.future);
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.getHorizontalPadding(context),
                    vertical: ResponsiveUtils.spacing(context, base: 20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Header with profile and notification
                      _buildHeader(context, dashboard.welcome),
                      SizedBox(
                        height: ResponsiveUtils.spacing(context, base: 24),
                      ),

                      // 2. Wellness Reset Card (Using WellnessProgress)
                      _buildWellnessSection(
                        context,
                        dashboard.wellnessProgress,
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(context, base: 20),
                      ),

                      // 3. Info Cards (Age & Session)
                      _buildInfoSection(context, dashboard.quickStats),
                      SizedBox(
                        height: ResponsiveUtils.spacing(context, base: 24),
                      ),

                      // 4. Action Required
                      // Force show section per request
                      Builder(
                        builder: (context) {
                          final List<entities.Task> actions =
                              dashboard.actionRequired;

                          // Only show header if empty, show list only if not empty
                          return Column(
                            children: [
                              _buildSectionHeader(
                                context,
                                'Action required',
                                onActionTap: () => context.go('/my-plan'),
                                actionLabel: 'Complete Now',
                                showArrow: true,
                              ),
                              // Widget below removed per user request "remove the pression quesioner widget completly"
                              // if (actions.isNotEmpty) ...[
                              //   SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
                              //   _buildTasksList(context, actions),
                              // ],
                              SizedBox(
                                height: ResponsiveUtils.spacing(
                                  context,
                                  base: 24,
                                ),
                              ),
                            ],
                          );
                        },
                      ),

                      // 5. Task Completed
                      if (dashboard.tasksCompleted.isNotEmpty) ...[
                        _buildSectionHeader(
                          context,
                          'Task Completed',
                          onActionTap: () {
                            context.push('/completed-tasks');
                          },
                          actionLabel: 'See All',
                          showArrow: false,
                        ),
                        SizedBox(
                          height: ResponsiveUtils.spacing(context, base: 16),
                        ),
                        _buildTasksList(context, dashboard.tasksCompleted),
                        SizedBox(
                          height: ResponsiveUtils.spacing(context, base: 24),
                        ),
                      ],

                      // 6. Program Card
                      // "Your Program" header removed per request
                      // _buildSectionHeader(
                      //   context,
                      //   'Your Program',
                      //   showArrow: false,
                      // ),
                      // SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
                      _buildProgramSection(context, dashboard.yourProgram),
                      SizedBox(
                        height: ResponsiveUtils.spacing(context, base: 24),
                      ),

                      // 7. Quick Access Grid
                      _buildSectionHeader(
                        context,
                        'Quick Access',
                        showArrow: false,
                      ),
                      SizedBox(
                        height: ResponsiveUtils.spacing(context, base: 16),
                      ),
                      _buildQuickAccessSection(context, dashboard.quickAccess),

                      // Bottom padding for scroll
                      SizedBox(
                        height: ResponsiveUtils.spacing(context, base: 40),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $err'),
              ElevatedButton(
                onPressed: () => ref.refresh(homeDashboardProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WelcomeData welcome) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: ResponsiveUtils.iconSize(context, base: 24),
              backgroundImage: const NetworkImage(
                'https://i.pravatar.cc/150?u=a042581f4e29026704d',
              ), // Placeholder
            ),
            SizedBox(width: ResponsiveUtils.spacing(context, base: 12)),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  welcome.greeting,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 12),
                    color: const Color(0xFF3E160D).withOpacity(0.6),
                  ),
                ),
                Text(
                  '${welcome.firstName} ${welcome.lastName}'.trim(),
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 20),
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF3E160D),
                  ),
                ),
              ],
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 8)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: const Color(0xFF3E160D),
            size: ResponsiveUtils.iconSize(context, base: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildWellnessSection(
    BuildContext context,
    WellnessProgress progress,
  ) {
    return WellnessCard(wellnessProgress: progress);
  }

  Widget _buildInfoSection(BuildContext context, QuickStats stats) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InfoCard(value: stats.nuevoAge ?? '--', label: 'Nuevo Age'),
          ),
          SizedBox(width: ResponsiveUtils.spacing(context, base: 8)),
          Expanded(
            child: DietitianSessionCard(
              sessionInfo: stats.nextSession,
              onTap: () {
                // Handle tap, e.g., navigate to session details
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onActionTap,
    String? actionLabel,
    bool showArrow = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, base: 16),
            fontWeight: FontWeight.w300,
            color: const Color(0xFF17110D),
            height: 1.5,
            letterSpacing: 0,
            fontFamily: 'Inter',
          ),
        ),
        if (actionLabel != null && onActionTap != null)
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  actionLabel,
                  style: TextStyle(
                    color: const Color(0xFF964A38),
                    fontSize: ResponsiveUtils.fontSize(context, base: 12),
                    fontWeight: FontWeight.w300,
                    height: 16 / 12,
                    letterSpacing: 0,
                    fontFamily: 'Inter',
                  ),
                ),
                if (showArrow) ...[
                  SizedBox(width: ResponsiveUtils.spacing(context, base: 6)),
                  Icon(
                    Icons.arrow_forward,
                    size: ResponsiveUtils.iconSize(context, base: 14),
                    color: const Color(0xFF964A38),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildTasksList(BuildContext context, List<entities.Task> tasks) {
    return SizedBox(
      height: ResponsiveUtils.spacing(context, base: 110),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: tasks.length,
        separatorBuilder: (_, __) =>
            SizedBox(width: ResponsiveUtils.spacing(context, base: 12)),
        itemBuilder: (context, index) => TaskCard(
          task: tasks[index],
          onTap: () => context.go('/task/${tasks[index].id}'),
        ),
      ),
    );
  }

  Widget _buildProgramSection(BuildContext context, WellnessProgram? program) {
    // Fallback if program is null
    final displayProgram =
        program ??
        const WellnessProgram(
          id: 'program-insight',
          name: 'Insight Program',
          description: 'Advanced assessment and specialist-led profiling',
          progressPercentage: 0,
          habitsCount: 0,
        );

    return ProgramCard(
      program: displayProgram,
      onViewPlan: () => context.go('/my-plan'),
    );
  }

  Widget _buildQuickAccessSection(
    BuildContext context,
    List<HomeQuickAccessItem> items,
  ) {
    return QuickAccessGrid(
      items: items
          .map(
            (e) => QuickAccessItem(
              title: e.title,
              icon: _getIconForName(e.icon),
              onTap: () => _handleQuickAccessTap(context, e.id),
            ),
          )
          .toList(),
    );
  }

  IconData _getIconForName(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'dumbbell':
      case 'exercise':
        return Icons.fitness_center;
      case 'nutrition':
      case 'apple':
        return Icons.restaurant;
      case 'calendar':
      case 'appointments':
        return Icons.calendar_today_outlined;
      case 'heart':
      case 'health':
        // For custom images, QuickAccessItem uses imagePath if available.
        // Here we return an icon, but if we want images we need to map IDs/icons to asset paths.
        // The API returns "icon": "dumbbell".
        // QuickAccessItem accepts icon OR imagePath.
        // Let's try to map to assets if they match known ones to keep UI consistent.
        return Icons.favorite_outline;
      default:
        return Icons.grid_view;
    }
  }

  void _handleQuickAccessTap(BuildContext context, String id) {
    switch (id) {
      case 'daily-exercise':
        context.go('/daily-exercise');
        break;
      case 'daily-nutrition':
        context.go('/daily-nutrition');
        break;
      case 'appointments':
        context.go('/appointments');
        break;
      case 'health-insight':
        context.go('/health');
        break;
      default:
        // Handle unknown or show toast
        break;
    }
  }
}
