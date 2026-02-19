import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart' hide TextDirection;
import '../../../core/theme/app_theme.dart';
import '../../providers/diet_plan_provider.dart';
import '../../../data/models/diet_plan_model.dart'; // Import the model
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/guidance_detail_bottom_sheet.dart';

class HealthScreen extends ConsumerStatefulWidget {
  const HealthScreen({super.key});

  @override
  ConsumerState<HealthScreen> createState() => _HealthScreenState();
}

class _HealthScreenState extends ConsumerState<HealthScreen> {
  int _selectedTabIndex = 0; // Default to 'Exercise'
  final List<String> _tabs = ['Exercise', 'Diet', 'Results', 'Insights'];
  DateTime _selectedDate = DateTime.now();

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
              const Center(
                child: Text(
                  'Health',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
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

              // Content based on selection
              if (_selectedTabIndex == 0)
                _buildExerciseContent()
              else if (_selectedTabIndex == 1)
                _buildDietContent()
              else if (_selectedTabIndex == 2)
                _buildResultsContent()
              else if (_selectedTabIndex == 3)
                _buildInsightsContent()
              else
                Center(child: Text("Content for ${_tabs[_selectedTabIndex]} coming soon"))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseContent() {
    final now = DateTime.now();
    final DateFormat dayFormatter = DateFormat('E'); // Mon, Tue, etc.
    final DateFormat dateFormatter = DateFormat('d'); // 21, 22, etc.

    // Generate 5 days centered on today
    final List<DateTime> dates = List.generate(5, (index) {
      return now.subtract(const Duration(days: 2)).add(Duration(days: index));
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weekly Preview
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Weekly Preview",
              style: AppTextStyles.bodyLarge.copyWith(
                color: const Color(0xFF4A4A4A),
                fontSize: 16,
              ),
            ),
            const Icon(
              Icons.calendar_month_outlined,
              color: Color(0xFFA05E44),
              size: 20,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 30, // Show next 30 days
            itemBuilder: (context, index) {
              // Start from 3 days ago to show some history context, or just today?
              // Design usually shows current week. Let's start from 3 days ago.
              final date = now.subtract(const Duration(days: 3)).add(Duration(days: index));
              final isToday = date.day == now.day && date.month == now.month && date.year == now.year;
              final isSelected = date.day == _selectedDate.day &&
                  date.month == _selectedDate.month &&
                  date.year == _selectedDate.year;
              
              // Disable previous days (before today)
              // We compare date with today (ignoring time)
              final DateTime dateOnly = DateTime(date.year, date.month, date.day);
              final DateTime todayOnly = DateTime(now.year, now.month, now.day);
              final isDisabled = dateOnly.isBefore(todayOnly);

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () {
                    if (!isDisabled) {
                      setState(() {
                        _selectedDate = date;
                      });
                    }
                  },
                  child: _buildDateCell(
                    dayFormatter.format(date).toUpperCase(),
                    dateFormatter.format(date),
                    isSelected,
                    isDisabled: isDisabled,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Today's Exercise
        Text(
          "Today's Exercise",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: () {
            context.push('/health/session-overview');
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                // Image Section (Top Half)
                Container(
                  height: MediaQuery.of(context).size.height * 0.22, // Responsive height (approx 22% of screen)
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    color: Color(0xFFE0E0E0),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
                      },
                    ),
                  ),
                ),
                
                // Content Section (Bottom Half - Dark Brown)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
                    color: Color(0xFF2B1B18), // Dark brown background
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.fitness_center_outlined, color: Colors.white.withOpacity(0.9), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              'Strength',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Title
                      const Text(
                        'Lower Body Strength',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Inter',
                          letterSpacing: -0.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      
                      // Details Row
                      Row(
                        children: [
                          const Icon(Icons.access_time, color: Colors.white, size: 16),
                          const SizedBox(width: 6),
                          const Text(
                            '45 mins',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.local_fire_department, color: Color(0xFFFF9800), size: 16),
                          const SizedBox(width: 6),
                          Flexible( // flexible to prevent overflow
                            child: const Text(
                              'High Intensity',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      
                      // Start Session Button
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white.withOpacity(0.9), width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Start Session',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  child: VerticalDivider(
                                    color: Colors.white,
                                    thickness: 1,
                                    width: 20, // width includes padding
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Plan Overview
        Text(
          "Plan Overview",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
             Expanded(
               child: Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: const Color(0xFFF5EAE8),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text('PROGRAM', style: TextStyle(fontSize: 10, color: Color(0xFF735B4D))),
                     const SizedBox(height: 8),
                     const Text('Week 3 of 12', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                     const SizedBox(height: 16),
                     const Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text('Progress', style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C))),
                         Text('25%', style: TextStyle(fontSize: 12, color: Color(0xFF1E1E1E))),
                       ],
                     ),
                     const SizedBox(height: 8),
                     LinearProgressIndicator(
                       value: 0.25,
                       backgroundColor: const Color(0xFFE0E0E0),
                       valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFA05E44)),
                       borderRadius: BorderRadius.circular(4),
                     ),
                   ],
                 ),
               ),
             ),
             const SizedBox(width: AppSpacing.md),
             Expanded(
               child: Container(
                 padding: const EdgeInsets.all(16),
                 decoration: BoxDecoration(
                   color: const Color(0xFFF5EAE8),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     const Text('CURRENT FOCUS', style: TextStyle(fontSize: 10, color: Color(0xFF735B4D))),
                     const SizedBox(height: 8),
                     const Text('Mobility & Flex', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                     const SizedBox(height: 16),
                     Row(
                        children: [
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFE0E0),
                                    borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text('Active', style: TextStyle(color: Color(0xFFA05E44), fontSize: 10)),
                            ),
                            const SizedBox(width: 8),
                            const Text('+2 sessions', style: TextStyle(fontSize: 10, color: Color(0xFF735B4D))),
                        ],
                     ),
                   ],
                 ),
               ),
             ),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Your Care Team
        Text(
          "Your Care Team",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EAE8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
               const CircleAvatar(
                 radius: 24,
                 backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=11'), // Placeholder image
               ),
               const SizedBox(width: 12),
               const Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text('DR. Mike', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                     Text('Dietitian', style: TextStyle(fontSize: 14, color: Color(0xFF8C8C8C))),
                   ],
                 ),
               ),
               const Icon(Icons.arrow_forward, color: Color(0xFFA05E44), size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateCell(String day, String date, bool isSelected, {bool isDisabled = false}) {
    return Container(
      width: 50,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFFA05E44)
            : (isDisabled ? Colors.transparent : const Color(0xFFF9F9F9)),
        borderRadius: BorderRadius.circular(30), // Pill shape vertical
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: const Color(0xFFA05E44).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
        border: isDisabled ? Border.all(color: Colors.grey.withOpacity(0.2)) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: TextStyle(
              fontSize: 10,
              color: isSelected
                  ? Colors.white.withOpacity(0.8)
                  : (isDisabled ? const Color(0xFFBDBDBD) : const Color(0xFF757575)),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isDisabled ? const Color(0xFFBDBDBD) : const Color(0xFF1E1E1E)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietContent() {
    final dietPlanAsync = ref.watch(dietPlanProvider);

    return dietPlanAsync.when(
      data: (dietPlan) {
        if (dietPlan == null) {
          return const SizedBox(
            height: 100,
            child: Center(child: Text("No nutrition plan assigned.")),
          );
        }
        return _buildDietUI(dietPlan);
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: CircularProgressIndicator(color: Color(0xFFA05E44)),
        ),
      ),
      error: (error, stack) {
        debugPrint('Error loading diet plan: $error');
        // Return empty UI on error, or you could show a retry button. 
        // For now, adhering to "remove static data", we show empty or basic structure.
        return const Center(child: Text("Unable to load diet plan"));
      },
    );
  }

  Widget _buildDietUI(DietPlanModel dietPlan) {
    // Calculate totals or use API values. Default to 0 if null.
    final totalCalories = dietPlan.calories ?? 
        (dietPlan.meals?.fold<int>(0, (sum, meal) => sum + (meal.calories ?? 0)) ?? 0);
    
    final protein = dietPlan.protein ?? 0;
    final waterGlasses = dietPlan.waterGlasses ?? 0;

    // Use ONLY API guidance. No static fallback.
    final displayGuidance = dietPlan.keyGuidance ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Today's Nutrition Section
        Text(
          "Today's Nutrition",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _buildNutritionCard('$totalCalories', 'Calories', const Color(0xFFF5EAE8)),
            const SizedBox(width: AppSpacing.md),
            _buildNutritionCard('${protein}g', 'Protein', const Color(0xFFF5EAE8)),
            const SizedBox(width: AppSpacing.md),
            _buildNutritionCard(waterGlasses.toString().padLeft(2, '0'), 'Glasses', const Color(0xFFF5EAE8)),
          ],
        ),
        const SizedBox(height: AppSpacing.xl),

        // Meals Section
        if (dietPlan.meals != null && dietPlan.meals!.isNotEmpty) ...[
          Text(
            "Today's Meals",
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF4A4A4A),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...dietPlan.meals!.map((meal) => _buildMealCard(meal)).toList(),
          const SizedBox(height: AppSpacing.xl),
        ],

        // Key Guidance Section
        if (displayGuidance.isNotEmpty) ...[
          Text(
            "Key Guidance",
            style: AppTextStyles.bodyLarge.copyWith(
              color: const Color(0xFF4A4A4A),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ...displayGuidance.map((guidance) => GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => GuidanceDetailBottomSheet(guidance: guidance),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: _buildGuidanceCard(
                icon: Icons.lightbulb_outline, // Fallback icon if image fails loading
                iconUrl: guidance.iconUrl,
                title: guidance.title ?? 'Guidance',
                subtitle: guidance.subtitle ?? 'Tap for details',
                iconColor: const Color(0xFFA05E44),
              ),
            ),
          )).toList(),
        ],
      ],
    );
  }

  Widget _buildMealCard(MealModel meal) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Meal Image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EAE8),
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: meal.imageUrl != null 
                    ? NetworkImage(meal.imageUrl!) 
                    : const AssetImage('assets/images/daily_nutrition.png') as ImageProvider,
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {
                   // Fallback if network image fails? 
                   // The NetworkImage doesn't easily allow fallback in DecorationImage.
                   // But typically we rely on valid URLs.
                },
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name ?? 'Unknown Meal',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                if (meal.time != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    meal.time!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8C8C8C),
                    ),
                  ),
                ],
                if (meal.calories != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${meal.calories} kcal',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFA05E44),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFBDBDBD)),
        ],
      ),
    );
  }



  Widget _buildGuidanceCard({
    required IconData icon,
    String? iconUrl,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    bool isSvg = iconUrl?.toLowerCase().endsWith('.svg') ?? false;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8), 
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconUrl != null ? Colors.transparent : iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: iconUrl != null
                  ? (isSvg 
                      ? SvgPicture.network(
                          iconUrl,
                          placeholderBuilder: (BuildContext context) => Icon(icon, color: iconColor, size: 24),
                        )
                      : Image.network(
                          iconUrl, 
                          errorBuilder: (ctx, err, stack) => Icon(icon, color: iconColor, size: 24),
                        ))
                  : Image.asset(
                      'assets/images/daily_nutrition.png',
                      errorBuilder: (ctx, err, stack) => Icon(icon, color: Colors.white, size: 24),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8C8C8C),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward,
            color: Color(0xFFA05E44),
            size: 20,
          ),
        ],
      ),
    );
  }


  Widget _buildResultsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildResultCard(
          icon: Icons.science_outlined,
          title: 'Metabolic Panel',
          date: 'Oct 24, 2023',
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildResultCard(
          icon: Icons.grid_on_outlined, // Placeholder for cells/lipid
          title: 'Lipid Profile',
          date: 'Aug 12, 2023',
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildResultCard(
          icon: Icons.coronavirus_outlined, // Placeholder for molecule/vitamin D
          title: 'Vitamin D Panel',
          date: 'Collected Yesterday',
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.xl),
        
        // Book New Test Section
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: _DashedBorder.all(
              color: const Color(0xFFE0E0E0),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFFA05E44),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text(
                'Book a New Test',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E1E1E),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              const Text(
                'Keep track of your health markers by\nscheduling your next lab visit.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF757575),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Your Nuevo Age Section
        Text(
          "Your Nuevo Age",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EAE8),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "32",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF1E1E1E),
                        fontFamily: 'Inter',
                      ),
                    ),
                    TextSpan(
                      text: " Years",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E1E1E),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "5 years younger than your biological age",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8C8C8C),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Recent Insights Section
        Text(
          "Recent Insights",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildGuidanceCard(
          icon: Icons.bed_outlined, // Sleep icon
          title: 'Sleep Quality Improved',
          subtitle: 'Your average sleep time increased by 45 minutes this week',
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildGuidanceCard(
          icon: Icons.track_changes_outlined, // Activity/Target icon
          title: 'Activity Goal Met',
          subtitle: "You've hit your daily step goal 5 days in a row!",
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildGuidanceCard(
          icon: Icons.psychology_outlined, // Stress/Mind icon
          title: 'Stress Levels',
          subtitle: 'Consider adding relaxation techniques to your routine',
          iconColor: const Color(0xFFA05E44),
        ),
      ],
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String date,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF1E1E1E),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8C8C8C),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward,
            color: Color(0xFFA05E44),
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionCard(String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF8C8C8C),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

// Custom Dashed Border Implementation
class _DashedBorder extends BoxBorder {
  const _DashedBorder({this.color = const Color(0xFF000000), this.width = 1.0});

  final Color color;
  final double width;

  static _DashedBorder all({
    Color color = const Color(0xFF000000),
    double width = 1.0,
  }) {
    return _DashedBorder(color: color, width: width);
  }

  @override
  BorderSide get top => BorderSide(color: color, width: width);

  @override
  BorderSide get bottom => BorderSide(color: color, width: width);

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(width);

  @override
  bool get isUniform => true;

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke;

    final Path path = Path();
    if (borderRadius != null) {
      path.addRRect(borderRadius.toRRect(rect));
    } else {
      path.addRect(rect);
    }

    final Path dashPath = Path();
    const double dashWidth = 5.0;
    const double dashSpace = 3.0;
    double distance = 0.0;

    for (final ui.PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  ShapeBorder scale(double t) {
    return _DashedBorder(color: color, width: width * t);
  }
}
