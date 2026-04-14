import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';
import '../../providers/phase_provider.dart';
import '../../providers/core_providers.dart';
import '../../../data/models/phase_model.dart';
import '../../../domain/usecases/phase/phase_usecases.dart';
import 'package:flutter_svg/flutter_svg.dart';

class YourTasksScreen extends ConsumerStatefulWidget {
  final String programName;
  final String programDescription;
  final String phaseId;
  final bool isActive;

  const YourTasksScreen({
    super.key,
    required this.programName,
    required this.programDescription,
    required this.phaseId,
    required this.isActive,
  });

  @override
  ConsumerState<YourTasksScreen> createState() => _YourTasksScreenState();
}



class _YourTasksScreenState extends ConsumerState<YourTasksScreen> {
  int _durationWeeks = 1;
  bool _isLoadingPhase = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _initializeData();
    });
  }

  Future<void> _initializeData() async {
    try {
      final getPhaseByIdUseCase = ref.read(getPhaseByIdUseCaseProvider);
      final phaseResult = await getPhaseByIdUseCase(PhaseByIdParams(widget.phaseId));
      
      phaseResult.fold(
        (failure) {
           if (mounted) setState(() => _isLoadingPhase = false);
        },
        (phaseData) {
           if (mounted) {
             setState(() {
               _durationWeeks = phaseData.durationWeeks;
               _isLoadingPhase = false;
             });
           }
           
           if (widget.isActive) {
             ref.read(weeklyViewProvider.notifier).fetchCurrentWeek();
           } else {
             final phaseTasks = phaseData.phaseTasks;
             int weekNumber = phaseTasks.isNotEmpty ? phaseTasks.first.weekNumberGlobal : 1;
             ref.read(weeklyViewProvider.notifier).fetchWeekByNumber(weekNumber);
           }
        }
      );
    } catch (e) {
      if (mounted) setState(() => _isLoadingPhase = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final weeklyViewState = ref.watch(weeklyViewProvider);

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
          'Your Tasks',
          style: TextStyle(
            fontSize: ResponsiveUtils.fontSize(context, base: 16),
            fontWeight: FontWeight.w400,
            color: const Color(0xFF17110D),
          ),
        ),
        centerTitle: true,
      ),
      body: weeklyViewState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (weeklyView) {
          final pendingTasks = weeklyView.tasks.where((t) => t.legacyStatus == 'PENDING').toList();
          final completedTasks = weeklyView.tasks.where((t) => t.legacyStatus == 'COMPLETED').toList();

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveUtils.getHorizontalPadding(context),
              vertical: ResponsiveUtils.spacing(context, base: 20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(context),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),
                _buildCurrentPhaseWeekCard(context, weeklyView),
                SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
                _buildWeekNavigation(context, weeklyView),
                if (pendingTasks.isNotEmpty) ...[
                  SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Action Required',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(context, base: 16),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF17110D),
                        ),
                      ),
                      const Icon(Icons.error_outline, color: Color(0xFF964A38), size: 20),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
                  ...pendingTasks.map((t) => Padding(
                        padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, base: 12)),
                        child: _buildPendingTaskCard(context, t),
                      )),
                ],
                if (completedTasks.isNotEmpty) ...[
                  SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completed Tasks',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(context, base: 16),
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF17110D),
                        ),
                      ),
                      const Icon(Icons.check_circle_outline, color: Color(0xFF438A7A), size: 20),
                    ],
                  ),
                  SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
                  ...completedTasks.map((t) => Padding(
                        padding: EdgeInsets.only(bottom: ResponsiveUtils.spacing(context, base: 12)),
                        child: _buildCompletedTaskCard(context, t),
                      )),
                ],
                SizedBox(height: ResponsiveUtils.spacing(context, base: 40)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 20)),
      decoration: BoxDecoration(
        color: const Color(0xFF6B3528),
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
                      widget.programName,
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.fontSize(context, base: 18),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.programDescription,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: ResponsiveUtils.fontSize(context, base: 14),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPhaseWeekCard(BuildContext context, WeeklyViewModel weeklyView) {
    if (_isLoadingPhase) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 16)),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5F3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5DCD8), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weeklyView.phaseName,
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, base: 16),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF17110D),
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 4)),
              Text(
                'Week: ${weeklyView.weekInPhase}/$_durationWeeks',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, base: 14),
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF735B4D),
                ),
              ),
            ],
          ),
          if (widget.isActive)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF964A38),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Active',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, base: 12),
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation(BuildContext context, WeeklyViewModel weeklyView) {
    if (_isLoadingPhase) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveUtils.spacing(context, base: 16),
        vertical: ResponsiveUtils.spacing(context, base: 12),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F5F3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_left, color: Color(0xFF6B3528)),
            onPressed: () {
              final weekNumber = weeklyView.currentWeekGlobal - 1;
              if (weekNumber >= 1) {
                ref.read(weeklyViewProvider.notifier).fetchWeekByNumber(weekNumber);
              }
            },
          ),
          Text(
            'Week: ${weeklyView.weekInPhase}/$_durationWeeks',
            style: TextStyle(
              fontSize: ResponsiveUtils.fontSize(context, base: 14),
              fontWeight: FontWeight.w500,
              color: const Color(0xFF17110D),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return ListView.builder(
                    itemCount: _durationWeeks,
                    itemBuilder: (context, index) {
                      final inputValue = index + 1;
                      return ListTile(
                        title: Text('Week $inputValue'),
                        onTap: () {
                          Navigator.pop(context);
                          if (inputValue == weeklyView.weekInPhase) return;
                          
                          int weekNumber;
                          if (inputValue < weeklyView.weekInPhase) {
                            weekNumber = weeklyView.currentWeekGlobal - (weeklyView.weekInPhase - inputValue);
                          } else {
                            weekNumber = weeklyView.currentWeekGlobal + (inputValue - weeklyView.weekInPhase);
                          }
                          
                          ref.read(weeklyViewProvider.notifier).fetchWeekByNumber(weekNumber);
                        },
                      );
                    },
                  );
                },
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE5DCD8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${weeklyView.weekInPhase}',
                style: TextStyle(
                  fontSize: ResponsiveUtils.fontSize(context, base: 14),
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF6B3528),
                ),
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              colorFilter: const ColorFilter.mode(Color(0xFF6B3528), BlendMode.srcIn),
              width: 24,
              height: 24,
            ),
            onPressed: () {
              final weekNumber = weeklyView.currentWeekGlobal + 1;
              if (weeklyView.weekInPhase < _durationWeeks) {
                ref.read(weeklyViewProvider.notifier).fetchWeekByNumber(weekNumber);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTaskCard(BuildContext context, PatientTaskModel task) {
    return GestureDetector(
      onTap: () async {
        if (task.visualIndicator == 'toggle' && task.statusOptions.isNotEmpty) {
           return; // Do nothing, let user tap the options directly
        }

        if (task.taskType == 'QUESTIONNAIRE') {
           showDialog(
             context: context,
             barrierDismissible: false,
             builder: (ctx) => const Center(child: CircularProgressIndicator()),
           );

           try {
             final response = await ref.read(apiClientProvider).getTaskById(task.id);
             if (context.mounted) {
               Navigator.of(context).pop(); // dismiss loading
             }

             if (response.success && response.data != null) {
               final fullTask = response.data!;
               final qId = fullTask.phaseTask?.questionnaireId;
               
               if (qId != null && qId.isNotEmpty) {
                 if (context.mounted) {
                   context.push('/questionnaire/$qId/${task.id}');
                 }
               } else {
                 if (context.mounted) {
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Questionnaire ID not found for this task')),
                   );
                 }
               }
             } else {
               if (context.mounted) {
                 ScaffoldMessenger.of(context).showSnackBar(
                   SnackBar(content: Text(response.message ?? 'Failed to fetch task details')),
                 );
               }
             }
           } catch (e) {
             if (context.mounted) {
               Navigator.of(context).pop(); // dismiss loading
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(content: Text('Error fetching task: $e')),
               );
             }
           }
        } 
        else if (task.taskType == 'APPOINTMENT') {
         // context.push('/connecting-session');
        } else {
           context.push('/task/${task.id}');
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5DCD8), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    task.taskName.isNotEmpty ? task.taskName : 'Task',
                    style: TextStyle(
                      fontSize: ResponsiveUtils.fontSize(context, base: 16),
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF17110D),
                    ),
                  ),
                  if (task.practitioner.isNotEmpty) ...[
                    SizedBox(height: ResponsiveUtils.spacing(context, base: 4)),
                    Text(
                      task.practitioner,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(context, base: 14),
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF735B4D),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFF6ECE9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF6B3528),
                size: 14,
              ),
            ),
          ],
        ),
        if (task.visualIndicator == 'toggle' && task.statusOptions.isNotEmpty) ...[
          SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
          Row(
            children: task.statusOptions.map((opt) {
              final isSelected = opt == task.statusValue;
              return GestureDetector(
                onTap: isSelected ? null : () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    useRootNavigator: true,
                    builder: (ctx) => const Center(child: CircularProgressIndicator()),
                  );
                  
                  await Future.delayed(const Duration(milliseconds: 100));
                  
                  try {
                    final success = await ref.read(activePhaseTaskProvider.notifier).updateStatus(task.id, opt);
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                      if (success) {
                        final currentWeek = ref.read(weeklyViewProvider).value?.currentWeekGlobal;
                        if (currentWeek != null) {
                          ref.read(weeklyViewProvider.notifier).fetchWeekByNumber(currentWeek);
                        } else {
                          ref.read(weeklyViewProvider.notifier).fetchCurrentWeek();
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to update task status')),
                        );
                      }
                    }
                  } catch (e) {
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF6B3528) : Colors.white,
                    border: Border.all(color: isSelected ? const Color(0xFF6B3528) : const Color(0xFFDFDFDF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    opt,
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF735B4D),
                      fontSize: ResponsiveUtils.fontSize(context, base: 14),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTaskCard(BuildContext context, PatientTaskModel task) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveUtils.spacing(context, base: 16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5DCD8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.taskName.isNotEmpty ? task.taskName : 'Task',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.fontSize(context, base: 16),
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF17110D),
                      ),
                    ),
                    if (task.practitioner.isNotEmpty) ...[
                      SizedBox(height: ResponsiveUtils.spacing(context, base: 4)),
                      Text(
                        task.practitioner,
                        style: TextStyle(
                          fontSize: ResponsiveUtils.fontSize(context, base: 14),
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF735B4D),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF438A7A), // Greenish completed color
                size: 24,
              ),
            ],
          ),
          if (task.statusOptions.isNotEmpty && task.taskType == 'APPOINTMENT') ...[
             SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
             Row(
                children: task.statusOptions.where((opt) => opt == task.statusValue).map((opt) {
                   final isSelected = true; // since we pre-filtered, it is true
                   return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF6B3528) : Colors.white,
                        border: Border.all(color: isSelected ? const Color(0xFF6B3528) : const Color(0xFFDFDFDF)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        opt,
                        style: TextStyle(
                          color: isSelected ? Colors.white : const Color(0xFF735B4D),
                          fontSize: ResponsiveUtils.fontSize(context, base: 14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                   );
                }).toList(),
             ),
          ] else if (task.taskType == 'QUESTIONNAIRE') ...[
             SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
             Container(
               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
               decoration: BoxDecoration(
                  color: const Color(0xFFE8F3EE),
                  borderRadius: BorderRadius.circular(8),
               ),
               child: Text(
                  'Done',
                  style: TextStyle(
                     color: const Color(0xFF438A7A),
                     fontSize: ResponsiveUtils.fontSize(context, base: 12),
                     fontWeight: FontWeight.w500,
                  ),
               ),
             ),
          ] else ...[
              // Fallback for visual indicator toggles like Low/Partially/Fully
               if (task.statusOptions.isNotEmpty && task.visualIndicator == 'toggle') ...[
                  SizedBox(height: ResponsiveUtils.spacing(context, base: 16)),
                  Row(
                    children: task.statusOptions.map((opt) {
                      final isSelected = opt == task.statusValue;
                      return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF6B3528) : Colors.white,
                            border: Border.all(color: isSelected ? const Color(0xFF6B3528) : const Color(0xFFDFDFDF)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            opt,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF735B4D),
                              fontSize: ResponsiveUtils.fontSize(context, base: 14),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                      );
                    }).toList(),
                  ),
               ]
          ]
        ],
      ),
    );
  }
}
