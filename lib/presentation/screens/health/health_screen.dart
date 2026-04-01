import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_strings.dart';
import '../../providers/specialist_provider.dart';

import 'widgets/health_results_tab.dart';
import 'widgets/exercise_tab/exercise_tab_content.dart';
import 'widgets/diet_tab/diet_tab_content.dart';
import 'widgets/insights_tab/insights_tab_content.dart';

class HealthScreen extends ConsumerStatefulWidget {
  final int initialTabIndex;
  
  const HealthScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  late int _selectedTabIndex;
  final List<String> _tabs = [AppStrings.tabExercise, AppStrings.tabDiet, AppStrings.tabResults, AppStrings.tabInsights];

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    
    // Fetch specialists when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(specialistListProvider.notifier).fetchSpecialists();
    });
  }

  @override
  void didUpdateWidget(covariant HealthScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTabIndex != oldWidget.initialTabIndex) {
      _selectedTabIndex = widget.initialTabIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Stack(
                alignment: Alignment.center,
                children: [
                  if (Navigator.of(context).canPop())
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.go('/home');
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      AppStrings.healthTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Tabs
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(_tabs.length, (index) {
                    final isSelected = _selectedTabIndex == index;
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSpacing.sm),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFA05E44) // Brown color from design
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: const Color(0xFFA05E44),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            _tabs[index],
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF735B4D),
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),

              // Content based on selection (Refactored using clean architecture & IndexedStack for zero-hang performance)
              IndexedStack(
                index: _selectedTabIndex,
                children: const [
                  ExerciseTabContent(),
                  DietTabContent(),
                  HealthResultsTab(),
                  InsightsTabContent(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
