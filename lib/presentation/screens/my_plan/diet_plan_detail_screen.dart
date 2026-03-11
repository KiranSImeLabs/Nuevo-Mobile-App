import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/diet_plan_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../widgets/common/app_error_widget.dart';

class DietPlanDetailScreen extends ConsumerWidget {
  const DietPlanDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietPlanAsync = ref.watch(dietPlanProvider);

    return Scaffold(
      backgroundColor: AppColors.surfaceColor,
      appBar: AppBar(
        title: const Text('Nutrition Plan'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: dietPlanAsync.when(
        data: (dietPlan) {
          if (dietPlan == null || dietPlan.meals == null || dietPlan.meals!.isEmpty) {
            return const Center(child: Text('No diet plan available.'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: dietPlan.meals!.length,
            itemBuilder: (context, index) {
              final meal = dietPlan.meals![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        meal.name ?? 'Meal ${index + 1}',
                        style: AppTextStyles.h4.copyWith(color: AppColors.primaryColor),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meal.time ?? 'Time: Not specified',
                        style: AppTextStyles.caption.copyWith(
                          color: meal.time != null ? Colors.grey : Colors.red.shade300,
                          fontStyle: meal.time != null ? FontStyle.normal : FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        meal.description ?? 'Description: Not available',
                        style: AppTextStyles.bodyMedium.copyWith(
                           color: meal.description != null ? AppColors.textPrimary : Colors.grey,
                           fontStyle: meal.description != null ? FontStyle.normal : FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('Foods:', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      if (meal.foods != null && meal.foods!.isNotEmpty)
                        ...meal.foods!.map((food) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.circle, size: 6, color: AppColors.primaryColor),
                              const SizedBox(width: 8),
                              Expanded(child: Text(food, style: AppTextStyles.bodyMedium)),
                            ],
                          ),
                        ))
                      else
                        Text(
                          'No foods listed',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          meal.calories != null ? '${meal.calories} kcal' : 'Calories: Not specified',
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.bold,
                            color: meal.calories != null ? AppColors.textPrimary : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => AppErrorWidget(message: error.toString()),
      ),
    );
  }
}
