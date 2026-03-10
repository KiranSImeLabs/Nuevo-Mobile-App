import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/care_team_member_card.dart';
import '../../providers/home_provider.dart';
import '../../providers/specialist_provider.dart';
import '../../providers/goal_provider.dart';
import '../../providers/phase_provider.dart';
import 'diet_plan_detail_screen.dart';

class MyPlanScreen extends ConsumerStatefulWidget {
  const MyPlanScreen({super.key});

  @override
  ConsumerState<MyPlanScreen> createState() => _MyPlanScreenState();
}

class _MyPlanScreenState extends ConsumerState<MyPlanScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(specialistListProvider.notifier).fetchSpecialists();
      ref.read(goalListProvider.notifier).fetchGoals();
      ref.read(phaseListProvider.notifier).fetchPhases();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(AppStrings.myPlan),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildHeaderCard(),
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle(AppStrings.phaseTimeline),
                  const SizedBox(height: 12),
                  _buildPhaseTimeline(),
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle(AppStrings.yourCareTeam),
                  const SizedBox(height: 12),
                  _buildCareTeam(context),
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle(AppStrings.goals),
                  const SizedBox(height: 12),
                  _buildGoalsSection(context),
                  const SizedBox(height: 24),
                  
                  _buildSectionTitle(AppStrings.planPillars),
                  const SizedBox(height: 12),
                  _buildPlanPillars(),
                  const SizedBox(height: 32),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: const Color(0xFF4A4A4A), // Slightly softer black for headers
      ),
    );
  }

  Widget _buildHeaderCard() {
    final dashboardState = ref.watch(homeDashboardProvider);
    
    return dashboardState.when(
      data: (dashboard) {
        final program = dashboard.yourProgram;
        if (program == null) {
          return const SizedBox.shrink();
        }
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF6B3528), // Deep brown from design
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.self_improvement,
                      color: Color(0xFF6B3528),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          program.name,
                          style: AppTextStyles.h3.copyWith(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          program.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.8),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.overview,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildPhaseTimeline() {
    final phaseState = ref.watch(phaseListProvider);

    return phaseState.when(
      loading: () => Column(
        children: [
          _buildTimelineItem(AppStrings.assess, isCompleted: true, isFirst: true),
          _buildTimelineItem(AppStrings.reset, isCompleted: true, isActive: true),
          _buildTimelineItem(AppStrings.elevate, isActive: false),
          _buildTimelineItem(AppStrings.sustain, isActive: false, isLast: true),
        ],
      ),
      error: (err, stack) => const Text('Failed to load phase timeline'),
      data: (phases) {
        if (phases.isEmpty) return const Text('No timeline phases available');
        return Column(
          children: phases.asMap().entries.map((entry) {
            final index = entry.key;
            final phase = entry.value;
            final isFirst = index == 0;
            final isLast = index == phases.length - 1;

            // Simple active/completed logic based on orderIndex for UI correctness till backend supplies statuses
            final isCompleted = phase.orderIndex < 3;
            final isActive = phase.orderIndex == 2;

            return _buildTimelineItem(
              phase.name,
              isActive: isActive,
              isCompleted: isCompleted,
              isFirst: isFirst,
              isLast: isLast,
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildTimelineItem(
    String title, {
    bool isActive = false,
    bool isCompleted = false,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                 if (!isFirst)
                  Container(
                    width: 2,
                    height: 12, // Reduced height for smoother connection
                    // If previous was completed, use solid color, else dotted or light
                     color: const Color(0xFF8D5B4C).withOpacity(0.3),
                  ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFF8D5B4C) // Checkbox filled color
                        : const Color(0xFFE5DCD8), // Inactive circle color
                    shape: BoxShape.circle,
                  ),
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                if (!isLast)
                   Expanded(
                    child: CustomPaint(
                      size: const Size(2, double.infinity),
                      painter: _DottedLinePainter(
                          color: const Color(0xFF8D5B4C).withOpacity(0.5)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0), // Spacing between items
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: AppColors.roseSurface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF5D4037),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCareTeam(BuildContext context) {
    final specialistsState = ref.watch(specialistListProvider);

    return specialistsState.when(
      data: (specialists) {
        if (specialists.isEmpty) {
          return const Text('No care team members found.');
        }
        return Column(
          children: specialists.map((specialist) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: CareTeamMemberCard(
                name: specialist.fullName,
                role: specialist.role,
                placeholderColor: Colors.blue.shade100, 
                onTap: () => context.push(
                  '/clinician-profile',
                  extra: {
                    'name': specialist.fullName,
                    'role': specialist.role,
                    'id': specialist.id,
                  },
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildGoalsSection(BuildContext context) {
    final goalsState = ref.watch(goalListProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.roseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Text(
                AppStrings.goals, 
                 style: AppTextStyles.h4.copyWith(fontSize: 16, color: const Color(0xFF4A4A4A))
               ),
               IconButton(
                 onPressed: () {
                   context.push('/edit-goals');
                 },
                 icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF8D6E63)),
                 padding: EdgeInsets.zero,
                 constraints: const BoxConstraints(),
                 style: IconButton.styleFrom(
                   tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                 ),
               ),
            ],
          ),
          const SizedBox(height: 16),
          goalsState.when(
            data: (goals) {
              if (goals.isEmpty) {
                return Text(
                  'No goals added yet.',
                  style: AppTextStyles.bodyMedium.copyWith(color: const Color(0xFF4A4A4A)),
                );
              }
              return Column(
                children: goals.map((goal) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildGoalItem(Icons.bookmark_border, goal.goal),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF8D6E63)), // Brownish icon
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFF4A4A4A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanPillars() {
    return Builder(
      builder: (context) {
        return Row(
          children: [
            Expanded(
              child: _buildPillarCard(
                icon: Icons.fitness_center_outlined,
                title: AppStrings.exercisePlan,
                subtitle: AppStrings.strengthFoundations,
                onTap: () {
                  // Navigate to Exercise Plan (Future Impl)
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPillarCard(
                icon: Icons.restaurant_menu,
                title: AppStrings.nutritionPlan,
                subtitle: AppStrings.wholeFoodFocus,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const DietPlanDetailScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }
    );
  }

  Widget _buildPillarCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.roseSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF8D6E63),
                size: 20,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C2C2C),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 16),
            const Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward,
                color: Color(0xFF8D6E63),
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Helper for dotted line
class _DottedLinePainter extends CustomPainter {
  final Color color;
  const _DottedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    double startY = 4; // Start a bit lower
    while (startY < size.height) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + 4),
        paint,
      );
      startY += 8;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
