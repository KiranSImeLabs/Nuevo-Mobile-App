import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/home_provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/common/app_error_widget.dart';
import '../../../domain/entities/task.dart' as entities;
import '../../../domain/entities/user.dart' as entities;
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
    final userState = ref.watch(userProvider);
    
    // Call user details if not available
    if (userState.valueOrNull == null && !userState.isLoading && !userState.hasError) {
      Future.microtask(() => ref.read(userProvider.notifier).fetchProfile());
    }

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
                      _buildHeader(context, dashboard.welcome, userState),
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
                      // 5. Task Completed
                      //context.go('/my-plan')
                      if (dashboard.tasksCompleted.isNotEmpty) ...[
                        _buildSectionHeader(
                          context,
                          'Task Completed',
                          onActionTap: () {
                            context.push('/completed-tasks',
                                extra: {'showCompleted': true});
                          },
                          actionLabel: 'See All',
                          showArrow: false,
                        )
                      ],
                      SizedBox(
                                height: ResponsiveUtils.spacing(
                                  context,
                                  base: 24,
                                ),
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
                                onActionTap: () => context.push(
                                  '/completed-tasks',
                                  extra: {'showCompleted': false},
                                ),
                                actionLabel: 'Complete Now',
                                showArrow: true,
                              ),
                              SizedBox(
                          height: ResponsiveUtils.spacing(context, base: 16),
                        ),
                        _buildTasksList(context, dashboard.tasksCompleted),
                        SizedBox(
                          height: ResponsiveUtils.spacing(context, base: 24),
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
        error: (err, stack) => AppErrorWidget(message: err.toString(), onRetry: () => ref.refresh(homeDashboardProvider)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WelcomeData welcome, AsyncValue<entities.User?> userState) {
    final userImageUrl = userState.value?.profileImageUrl;
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                width: ResponsiveUtils.iconSize(context, base: 48),
                height: ResponsiveUtils.iconSize(context, base: 48),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                clipBehavior: Clip.antiAlias,
                child: (userImageUrl != null && userImageUrl.isNotEmpty)
                    ? (userImageUrl.toLowerCase().endsWith('.svg')
                        ? Image.asset(
                            'assets/images/details_image.png',
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            userImageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) => Image.asset(
                              'assets/images/details_image.png',
                              fit: BoxFit.cover,
                            ),
                          ))
                    : Image.asset(
                        'assets/images/details_image.png',
                        fit: BoxFit.cover,
                      ),
              ),
              SizedBox(width: ResponsiveUtils.spacing(context, base: 12)),
              Expanded(
                child: Column(
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
                        height: 1.2,
                        color: const Color(0xFF3E160D),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
            //child: InfoCard(value: stats.nuevoAge ?? '--', label: 'Nuevo Age'),
            child: InfoCard(value:'--', label: 'Nuevo Age'),
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
      onCardTap: () => context.push('/your-program'),
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
              onTap: () => _handleQuickAccessTap(context, e),
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

  void _handleQuickAccessTap(BuildContext context, HomeQuickAccessItem item) {
    final titleLower = item.title.toLowerCase();
    final idLower = item.id.toLowerCase();

    if (idLower.contains('insight') || titleLower.contains('insight')) {
      context.push('/quick-health', extra: {'initialTabIndex': 3}); // Route to Insights tab
      return;
    }

    if (idLower.contains('exercise') || titleLower.contains('exercise')) {
      context.push('/quick-health');
      return;
    }

    if (idLower.contains('nutrition') || titleLower.contains('nutrition')) {
      context.push('/quick-health', extra: {'initialTabIndex': 1}); // Route to Diet tab
      return;
    }

    if (idLower.contains('appointment') || titleLower.contains('appointment')) {
      context.go('/appointments');
      return;
    }

    if (idLower.contains('health') || titleLower.contains('health')) {
      context.push('/quick-health');
      return;
    }

    switch (item.id) {
      case 'daily-exercise':
        context.push('/quick-health');
        break;
      case 'daily-nutrition':
        context.push('/quick-health', extra: {'initialTabIndex': 1});
        break;
      case 'appointments':
        context.go('/appointments');
        break;
      case 'health-insight':
        context.push('/quick-health', extra: {'initialTabIndex': 3});
        break;
      default:
        // Handle unknown or show toast
        break;
    }
  }
}
