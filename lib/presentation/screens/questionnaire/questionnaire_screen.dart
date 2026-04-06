import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../providers/questionnaire_provider.dart';
import '../../widgets/common/app_primary_button.dart';
import '../../../../domain/entities/questionnaire.dart';
import 'widgets/questionnaire_success_overlay.dart';

class QuestionnaireScreen extends ConsumerWidget {
  final String questionnaireId;
  final String patientTaskId;

  const QuestionnaireScreen({
    super.key,
    required this.questionnaireId,
    required this.patientTaskId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncQuestionnaire = ref.watch(fetchQuestionnaireProvider(questionnaireId));

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text('Complete task'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: asyncQuestionnaire.when(
        data: (questionnaire) => _buildBody(context, ref, questionnaire),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, Questionnaire questionnaire) {
    final state = ref.watch(questionnaireNotifierProvider(questionnaire));
    final notifier = ref.read(questionnaireNotifierProvider(questionnaire).notifier);

    // Listen to success state for overlay
    ref.listen<QuestionnaireState>(questionnaireNotifierProvider(questionnaire), (previous, next) {
      if (next.submitSuccess && (previous == null || !previous.submitSuccess)) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const QuestionnaireSuccessOverlay(),
        );
      }
      if (next.submitError != null && (previous == null || previous.submitError != next.submitError)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.submitError!), backgroundColor: AppColors.error),
        );
      }
    });

    final currentQuestion = questionnaire.questions[state.currentIndex];
    final isLastQuestion = state.currentIndex == questionnaire.questions.length - 1;
    final progress = (state.currentIndex + 1) / questionnaire.questions.length;

    return Column(
      children: [
        // Segmented Progress Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding, vertical: AppSpacing.md),
          child: Row(
            children: List.generate(questionnaire.questions.length, (index) {
              final isActive = index <= state.currentIndex;
              return Expanded(
                child: Container(
                  height: 8,
                  margin: EdgeInsets.only(right: index < questionnaire.questions.length - 1 ? 8.0 : 0.0),
                  decoration: ShapeDecoration(
                    color: isActive 
                        ? AppColors.primaryButtonColor 
                        : const Color(0xFFF2EAE7), // Muted off-white/light pink
                    shape: const StadiumBorder(),
                  ),
                ),
              );
            }),
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info Card
                _buildInfoCard(questionnaire),
                const SizedBox(height: AppSpacing.xl),

                // Question Counter
                Text(
                  'Question ${state.currentIndex + 1} of ${questionnaire.questions.length}',
                  style: AppTextStyles.label,
                ),
                const SizedBox(height: AppSpacing.md),

                // Question Text
                Text(
                  currentQuestion.text,
                  style: AppTextStyles.h3,
                ),
                const SizedBox(height: AppSpacing.lg),

                // Options
                ...currentQuestion.options.map((option) {
                  final isMultiSelect = currentQuestion.type == 'MULTI_SELECT';
                  final selectedIds = state.selectedOptionIds[currentQuestion.id] ?? {};
                  final isSelected = selectedIds.contains(option.id);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: InkWell(
                      onTap: () {
                        notifier.toggleOption(currentQuestion.id, option.id, isMultiSelect);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.roseSurface : AppColors.cardBackground,
                          border: Border.all(
                            color: isSelected ? AppColors.primaryButtonColor : AppColors.divider,
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                option.text,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                ),
                              ),
                            ),
                            if (isMultiSelect)
                              Icon(
                                isSelected ? Icons.check_box : Icons.check_box_outline_blank,
                                color: isSelected ? AppColors.primaryButtonColor : AppColors.divider,
                              )
                            else
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: isSelected ? AppColors.primaryButtonColor : AppColors.divider,
                              )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),

        // Bottom Navigation
        Container(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppPrimaryButton(
                text: isLastQuestion ? 'Submit' : 'Next Question',
                isLoading: state.isSubmitting,
                onPressed: () {
                  if (isLastQuestion) {
                    notifier.submit(patientTaskId);
                  } else {
                    notifier.nextQuestion();
                  }
                },
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Save for later',
                  style: AppTextStyles.button.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(Questionnaire questionnaire) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Placeholder for the asset image, you might want to replace with Image.asset
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.assignment, color: AppColors.primaryColor),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionnaire.title,
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 4),
                Text(
                  questionnaire.description,
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Text(
                      '5 mins', // Static for now as requested or can be dynamic
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
