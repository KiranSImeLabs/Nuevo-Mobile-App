import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../providers/diet_plan_provider.dart';
import '../../../../../data/models/diet_plan_model.dart';
import '../common/guidance_card.dart';
import '../guidance_detail_bottom_sheet.dart';
import 'meal_card.dart';
import 'nutrition_card.dart';

class DietTabContent extends ConsumerWidget {
  const DietTabContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietPlanAsync = ref.watch(dietPlanProvider);

    return dietPlanAsync.when(
      data: (dietPlan) {
        if (dietPlan == null) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text(AppStrings.noNutritionPlan)),
          );
        }
        return _buildDietUI(context, dietPlan);
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Color(0xFFA05E44)),
        ),
      ),
      error: (error, stack) {
        debugPrint('Error loading diet plan: $error');
        return const Center(child: Text(AppStrings.unableToLoadDietPlan));
      },
    );
  }

  Widget _buildDietUI(BuildContext context, DietPlanModel dietPlan) {
    final totalCalories = dietPlan.calories ?? 
        (dietPlan.meals?.fold<int>(0, (sum, meal) => sum + (meal.calories ?? 0)) ?? 0);
    
    final protein = dietPlan.protein ?? 0;
    final waterGlasses = dietPlan.waterGlasses ?? 0;
    final displayGuidance = dietPlan.keyGuidance ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Nutrition Section
        Text(
          AppStrings.todaysNutrition,
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            NutritionCard(value: '$totalCalories', label: AppStrings.calories, bgColor: const Color(0xFFF5EAE8)),
            const SizedBox(width: AppSpacing.md),
            NutritionCard(value: '${protein}g', label: AppStrings.protein, bgColor: const Color(0xFFF5EAE8)),
            const SizedBox(width: AppSpacing.md),
            NutritionCard(value: waterGlasses.toString().padLeft(2, '0'), label: AppStrings.glasses, bgColor: const Color(0xFFF5EAE8)),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Meals Section
        if (dietPlan.meals != null && dietPlan.meals!.isNotEmpty) ...[
          Text(
            AppStrings.todaysMeals,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF4A4A4A),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...dietPlan.meals!.map((meal) => MealCard(meal: meal)),
          const SizedBox(height: AppSpacing.xl),
        ],

        // Key Guidance Section
        if (displayGuidance.isNotEmpty) ...[
          Text(
            AppStrings.keyGuidance,
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF4A4A4A),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...displayGuidance.map((guidance) => GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GuidanceDetailBottomSheet(guidance: guidance),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: GuidanceCard(
                icon: Icons.lightbulb_outline,
                iconUrl: guidance.iconUrl,
                title: guidance.title ?? AppStrings.guidance,
                subtitle: guidance.subtitle ?? AppStrings.tapForDetails,
                iconColor: const Color(0xFFA05E44),
              ),
            ),
          )),
        ],
      ],
    );
  }
}
