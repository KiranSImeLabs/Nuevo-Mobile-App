import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/core_providers.dart';
import '../../providers/goal_provider.dart';
import '../../../domain/usecases/goal/delete_goal_usecase.dart';
import '../../../domain/usecases/goal/create_goal_usecase.dart';

class EditGoalsScreen extends ConsumerStatefulWidget {
  const EditGoalsScreen({super.key});

  @override
  ConsumerState<EditGoalsScreen> createState() => _EditGoalsScreenState();
}

class _EditGoalsScreenState extends ConsumerState<EditGoalsScreen> {
  // Mock data for suggested goals
  final List<Map<String, dynamic>> _suggestedGoals = [
    {'icon': Icons.schedule, 'text': AppStrings.prioritizeSleep},
    {'icon': Icons.water_drop_outlined, 'text': AppStrings.increaseHydration},
    {'icon': Icons.self_improvement, 'text': AppStrings.practiceMindfulness},
  ];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(goalListProvider.notifier).fetchGoals();
    });
  }

  void _deleteGoal(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.deleteGoal),
        content: const Text(AppStrings.deleteGoalConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the first dialog (confirmation)
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );
              
              final navigator = Navigator.of(context);
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final deleteGoalUseCase = ref.read(deleteGoalUseCaseProvider);
              final result = await deleteGoalUseCase(DeleteGoalParams(id: id));
              
              navigator.pop(); // Hide loading
              
              result.fold(
                (failure) {
                  scaffoldMessenger.showSnackBar(
                    SnackBar(content: Text(failure.message), backgroundColor: AppColors.error),
                  );
                },
                (_) {
                  ref.read(goalListProvider.notifier).fetchGoals(); // Refresh state
                },
              );
            },
            child: const Text(
              AppStrings.deleteGoal, // Or specific "Delete" string if needed
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  void _addNewGoal() {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.addNewGoal),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: AppStrings.enterNewGoal),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                final text = controller.text;
                Navigator.pop(context); // Close the original dialog
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final createGoalUseCase = ref.read(createGoalUseCaseProvider);
                final result = await createGoalUseCase(CreateGoalParams(goal: text));
                
                navigator.pop(); // Hide loading indicator
                
                result.fold(
                  (failure) {
                    scaffoldMessenger.showSnackBar(
                      SnackBar(content: Text(failure.message), backgroundColor: AppColors.error),
                    );
                  },
                  (_) {
                    ref.read(goalListProvider.notifier).fetchGoals(); // Refresh state
                  },
                );
              }
            },
            child: const Text(AppStrings.add),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text(AppStrings.editGoals),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.refineFocus,
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppStrings.refineFocusDesc,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildGoalsList(),
              const SizedBox(height: 32),
              Text(
                AppStrings.suggestedForReset,
                style: AppTextStyles.h4.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                  color: const Color(0xFF4A4A4A),
                ),
              ),
              const SizedBox(height: 16),
              _buildSuggestedGoalsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.roseSurface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.goals,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                // const Icon(
                //   Icons.edit_outlined,
                //   size: 20,
                //   color: Color(0xFF8D6E63),
                // ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFEFEBE9)),
          Consumer(
            builder: (context, ref, child) {
              final goalsState = ref.watch(goalListProvider);
              return goalsState.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      error.toString(),
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
                data: (goals) {
                  if (goals.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          "No goals found. Add a new goal to get started.",
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: goals.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.transparent, // Clean look as per design
                    ),
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            const Icon(Icons.star_outline, size: 20, color: Color(0xFF8D6E63)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                goal.goal,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: const Color(0xFF4A4A4A),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20, color: Color(0xFF8D6E63)),
                              onPressed: () => _deleteGoal(goal.id),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
          const Divider(height: 1, color: Color(0xFFEFEBE9)),
          InkWell(
            onTap: _addNewGoal,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.add, size: 20, color: Color(0xFF8D6E63)),
                  const SizedBox(width: 12),
                  Text(
                    AppStrings.addNewGoal,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: const Color(0xFF8D6E63),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestedGoalsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _suggestedGoals.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final goal = _suggestedGoals[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.roseSurface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  goal['icon'],
                  size: 20,
                  color: const Color(0xFF8D6E63),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  goal['text'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFF4A4A4A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
