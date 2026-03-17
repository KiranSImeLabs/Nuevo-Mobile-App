import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/home_provider.dart';
import '../../providers/specialist_provider.dart';
import '../../providers/goal_provider.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/wellness_program.dart';
import '../../widgets/common/care_team_member_card.dart';
import '../../providers/phase_provider.dart';

class YourProgramScreen extends  ConsumerStatefulWidget {
  const YourProgramScreen({super.key});

  @override
  ConsumerState<YourProgramScreen> createState() => _YourProgramScreenState();
}

class _YourProgramScreenState extends ConsumerState<YourProgramScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(specialistListProvider.notifier).fetchSpecialists();
      ref.read(phaseListProvider.notifier).fetchPhases();
      ref.read(activePhaseProvider.notifier).fetchActivePhase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(homeDashboardProvider);
    final specialistState = ref.watch(specialistListProvider);
    final phaseState = ref.watch(phaseListProvider);
    final activePhaseState = ref.watch(activePhaseProvider);
    
    return Scaffold(
      backgroundColor: const Color(0xFFFCF9F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCF9F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textSecondary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Your Program',
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, base: 16),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF17110D),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveUtils.getHorizontalPadding(context),
          vertical: ResponsiveUtils.spacing(context, base: 20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            dashboardState.when(
              data: (data) => _buildMainProgramCard(context, program: data.yourProgram),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => _buildMainProgramCard(context, program: null),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),
            Text(
              'Program Phases',
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, base: 16),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF17110D),
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
            activePhaseState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
              data: (activePhaseData) {
                final activeOrderIndex = activePhaseData.phase.phase?.orderIndex ?? 0;

                return phaseState.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => const Text('Failed to load phases'),
                  data: (phases) {
                    if (phases.isEmpty) return const Text('No phases available');
                    return Column(
                      children: phases.map((phase) {
                        final isActive = phase.orderIndex == activeOrderIndex;
                        final isLocked = phase.orderIndex > activeOrderIndex;
                        final isPast = phase.orderIndex < activeOrderIndex;

                        String subtitle = '${phase.name}';
                        if (isActive) {
                          try {
                            final firstPendingTask = activePhaseData.tasks.firstWhere(
                              (t) => t.status == 'PENDING',
                            );
                            if (firstPendingTask.phaseTask != null) {
                              subtitle = 'Focus: ${firstPendingTask.phaseTask!.title}';
                            }
                          } catch (_) {
                            // No pending task found, keep default subtitle
                          }
                        }

                        IconData iconData = Icons.assignment_outlined;
                        if (isLocked) {
                          iconData = Icons.lock_outline;
                        } else if (isActive) {
                          iconData = Icons.autorenew;
                        } else if (isPast) {
                          iconData = Icons.check_circle_outline;
                        }

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: ResponsiveUtils.spacing(context, base: 12)),
                          child: _buildPhaseCard(
                            context,
                            phase:'Phase ${phase.orderIndex}',
                            title: subtitle,
                            iconData: iconData,
                            isActive: isActive,
                            isLocked: isLocked,
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
            
            SizedBox(height: ResponsiveUtils.spacing(context, base: 32)),
            Text(
              AppStrings.yourCareTeam,
              style: TextStyle(
                fontSize: ResponsiveUtils.fontSize(context, base: 16),
                fontWeight: FontWeight.w400,
                color: const Color(0xFF17110D),
              ),
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
            specialistState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => const Text(AppStrings.notFound),
              data: (specialists) {
                if (specialists.isEmpty) {
                  return const Text(AppStrings.notAvailable);
                }
                return Column(
                  children: specialists.map((specialist) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, base: 12)),
                      child: CareTeamMemberCard(
                        name: specialist.fullName,
                        role: specialist.role,
                        placeholderColor: Colors.blue.shade100,
                        imageUrl: specialist.profileImage, // Now nullable, handled in widget
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
            ),
            SizedBox(height: ResponsiveUtils.spacing(context, base: 40)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainProgramCard(BuildContext context, {WellnessProgram? program}) {
    final title = program?.name ?? AppStrings.notFound;
    final description = program?.description ?? AppStrings.notAvailable;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 20)),
      decoration: BoxDecoration(
        color: const Color(0xFF6B3528),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.change_circle_outlined,
              color: const Color(0xFF6B3528),
              size: ResponsiveUtils.iconSize(context, base: 28),
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
          Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, base: 18),
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          SizedBox(height: ResponsiveUtils.spacing(context, base: 4)),
          Text(
            description,
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, base: 14),
              fontWeight: FontWeight.w300,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhaseCard(
    BuildContext context, {
    required String phase,
    required String title,
    required IconData iconData,
    required bool isActive,
    required bool isLocked,
  }) {
    final bgColor = isActive ? const Color(0xFF964A38) : const Color(0xFFF6ECE9);
    final textColor = isActive ? Colors.white : const Color(0xFF17110D);
    final subtitleColor = isActive ? Colors.white.withOpacity(0.9) : const Color(0xFF735B4D);

    Widget iconWidget;
    if (isLocked) {
      iconWidget = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDFDFDF), width: 1.5),
        ),
        child: Icon(iconData, color: const Color(0xFFBDBDBD), size: ResponsiveUtils.iconSize(context, base: 20)),
      );
    } else {
      iconWidget = Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : const Color(0xFF964A38),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          iconData,
          color: isActive ? const Color(0xFF964A38) : Colors.white,
          size: ResponsiveUtils.iconSize(context, base: 20),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 16)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          iconWidget,
          SizedBox(width: ResponsiveUtils.spacing(context, base: 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  phase,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 14),
                    fontWeight: FontWeight.w400,
                    color: subtitleColor,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 2)),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.fontSize(context, base: 16),
                    fontWeight: FontWeight.w400,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          if (isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Active',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, base: 12),
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

}
