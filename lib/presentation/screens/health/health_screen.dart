import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart' hide TextDirection;
import '../../../core/theme/app_theme.dart';
import '../../providers/diet_plan_provider.dart';
import '../../providers/health_provider.dart';
import '../../../data/models/diet_plan_model.dart';
import '../../../data/models/daily_exercise_model.dart';
import '../../../data/models/weekly_schedule_model.dart';
import '../../../data/models/lab_report_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../providers/specialist_provider.dart';
import '../../providers/lab_reports_provider.dart';
import 'widgets/guidance_detail_bottom_sheet.dart';
import 'widgets/health_results_tab.dart';
import 'widgets/health_insights_tab.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';

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
  DateTime _selectedDate = DateTime.now(); // Always land on current date

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
                Center(child: Text(AppStrings.contentComingSoon.replaceFirst('%s', _tabs[_selectedTabIndex])))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseContent() {
    final weeklyScheduleAsync = ref.watch(weeklyScheduleProvider);
    final todayExerciseAsync = ref.watch(todayExerciseProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Weekly Preview
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.weeklyPreview,
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
        
        // Weekly Schedule List
        SizedBox(
          height: 80,
          child: weeklyScheduleAsync.when(
            data: (weeklyData) {
              if (weeklyData == null || weeklyData.schedules == null || weeklyData.schedules!.isEmpty) {
                 return const Center(child: Text(AppStrings.noScheduleAvailable));
              }
              
              final schedules = weeklyData.schedules!;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final scheduleItem = schedules[index];
                  if (scheduleItem.scheduledDate == null) return const SizedBox.shrink();

                  DateTime date;
                  try {
                    date = DateTime.parse(scheduleItem.scheduledDate!);
                  } catch (e) {
                    return const SizedBox.shrink();
                  }

                  final DateFormat dayFormatter = DateFormat('E');
                  final DateFormat dateFormatter = DateFormat('d');
                  
                  // Selected state
                  final isSelected = date.day == _selectedDate.day &&
                      date.month == _selectedDate.month &&
                      date.year == _selectedDate.year;
                  
                  // Past days check
                  final now = DateTime.now();
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
              );
            },
            loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFA05E44))),
            error: (err, stack) => const Center(child: Text(AppStrings.yourWeeklyScheduleWillAppear)),
          ),
        ),
        
        const SizedBox(height: AppSpacing.xl),

        // Dynamic Title
        Builder(
          builder: (context) {
            final now = DateTime.now();
            final isToday = _selectedDate.day == now.day &&
                 _selectedDate.month == now.month &&
                 _selectedDate.year == now.year;

            return Text(
              isToday ? AppStrings.todaysExercise : AppStrings.exercisePreview,
              style: AppTextStyles.bodyLarge.copyWith(
                color: const Color(0xFF4A4A4A),
                fontSize: 16,
              ),
            );
          },
        ),
        const SizedBox(height: AppSpacing.md),
        
        // Exercise Card
        Builder(
          builder: (context) {
            final now = DateTime.now();
            final isToday = _selectedDate.day == now.day &&
                 _selectedDate.month == now.month &&
                 _selectedDate.year == now.year;

            if (isToday) {
              return todayExerciseAsync.when(
                data: (exerciseData) {
                  if (exerciseData == null || exerciseData.session == null) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(AppStrings.noExerciseToday),
                    ));
                  }
                  return _buildTodayExerciseCard(exerciseData);
                },
                loading: () => const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Color(0xFFA05E44))),
                ),
                error: (err, stack) => const Center(child: Text(AppStrings.unableToLoadExercise)),
              );
            } else {
              return weeklyScheduleAsync.when(
                data: (weeklyData) {
                  if (weeklyData == null || weeklyData.schedules == null) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(AppStrings.noScheduleAvailable),
                      ));
                  }
                  
                  DailyExerciseModel? selectedExercise;
                  for (var s in weeklyData.schedules!) {
                    if (s.scheduledDate != null) {
                        try {
                          final date = DateTime.parse(s.scheduledDate!);
                          if (date.year == _selectedDate.year && 
                              date.month == _selectedDate.month && 
                              date.day == _selectedDate.day) {
                              selectedExercise = s;
                              break;
                          }
                        } catch (_) {}
                    }
                  }
                  
                  if (selectedExercise == null || selectedExercise.session == null) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(AppStrings.noExerciseThisDate),
                      ));
                  }
                  
                  return _buildTodayExerciseCard(selectedExercise);
                },
                loading: () => const Center(child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Color(0xFFA05E44))),
                ),
                error: (err, stack) => const Center(child: Text(AppStrings.unableToLoadExercise)),
              );
            }
          },
        ),
        const SizedBox(height: AppSpacing.xl),


        // Plan Overview
        Text(
          AppStrings.planOverview,
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
                     const Text(AppStrings.program, style: TextStyle(fontSize: 10, color: Color(0xFF735B4D))),
                     const SizedBox(height: 8),
                     Text(AppStrings.weekOf.replaceFirst('%s', '3').replaceFirst('%s', '12'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                     const SizedBox(height: 16),
                     const Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Text(AppStrings.progress, style: TextStyle(fontSize: 12, color: Color(0xFF8C8C8C))),
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
                     const Text(AppStrings.currentFocus, style: TextStyle(fontSize: 10, color: Color(0xFF735B4D))),
                     const SizedBox(height: 8),
                     const Text(AppStrings.mobilityAndFlex, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                     const SizedBox(height: 16),
                     Row(
                        children: [
                            Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFFE0E0),
                                    borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(AppStrings.activeSession, style: TextStyle(color: Color(0xFFA05E44), fontSize: 10)),
                            ),
                            const SizedBox(width: 8),
                            Text(AppStrings.plusSessions.replaceFirst('%s', '2'), style: const TextStyle(fontSize: 10, color: Color(0xFF735B4D))),
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
          AppStrings.yourCareTeam,
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        
        Consumer(
          builder: (context, ref, child) {
            final specialistsAsync = ref.watch(specialistListProvider);
            
            return specialistsAsync.when(
              data: (specialists) {
                if (specialists.isEmpty) {
                  return const Text(
                    AppStrings.noCareTeamAssigned,
                    style: TextStyle(color: Color(0xFF757575), fontSize: 14),
                  );
                }
                
                return Column(
                  children: specialists.map((specialist) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          context.push(
                            '/clinician-profile',
                            extra: {
                              'id': specialist.id,
                              'name': specialist.fullName,
                              'role': specialist.role,
                              'imageUrl': specialist.profileImage,
                              'bio': specialist.biography,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EAE8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                               CircleAvatar(
                                 radius: 24,
                                 backgroundColor: const Color(0xFFE0D6D1),
                                 backgroundImage: specialist.profileImage != null && specialist.profileImage!.isNotEmpty
                                     ? NetworkImage(specialist.profileImage!) 
                                     : null,
                                 child: specialist.profileImage == null || specialist.profileImage!.isEmpty
                                     ? const Icon(Icons.person, color: Color(0xFFA05E44))
                                     : null,
                               ),
                               const SizedBox(width: 12),
                               Expanded(
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Text(specialist.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                     Text(specialist.role, style: const TextStyle(fontSize: 14, color: Color(0xFF8C8C8C))),
                                   ],
                                 ),
                               ),
                               const Icon(Icons.arrow_forward, color: Color(0xFFA05E44), size: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(color: Color(0xFFA05E44)),
                ),
              ),
              error: (err, stack) => const Text(
                AppStrings.noCareTeamAssigned,
                style: TextStyle(color: Color(0xFF757575), fontSize: 14),
              ),
            );
          }
        ),
      ],
    );
  }

  Widget _buildTodayExerciseCard(DailyExerciseModel exerciseData) {
    final session = exerciseData.session!;
    
    // Check if we have progress, else default to 0
    // Based on requirements, if there's no progress field in the design we just show the card
    
    return GestureDetector(
      onTap: () {
        context.push('/health/session-overview', extra: session);
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
                child: Builder(
                  builder: (context) {
                    final stepImageUrls = session.steps
                            ?.map((s) => s.imageUrl)
                            .where((url) => url != null && url.isNotEmpty)
                            .map((url) => _formatImageUrl(url, ''))
                            .cast<String>()
                            .toList() ??
                        [];
                    
                    if (stepImageUrls.isNotEmpty) {
                      return _ExerciseImageCarousel(imageUrls: stepImageUrls);
                    } else {
                      return Image.network(
                        _formatImageUrl(session.imageUrl, 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=1740&q=80'),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
                        },
                      );
                    }
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
                  if (session.purpose != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/icn_purpose.svg',
                            colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.srcIn),
                            height: 14,
                            width: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            session.purpose!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (session.purpose != null)
                    const SizedBox(height: 16),
                  
                  // Title
                  Text(
                    session.title ?? AppStrings.exerciseSession,
                    style: const TextStyle(
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
                      const Icon(Icons.schedule_outlined, color: Colors.white, size: 16),
                      const SizedBox(width: 6),
                      Text(
                        '${session.duration ?? 0} ${AppStrings.mins}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          String? displayIntensity = session.intensity;
                          
                          if (displayIntensity != null && displayIntensity.isNotEmpty) {
                            final isHigh = displayIntensity.toLowerCase().contains('high');
                            return Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if (isHigh)
                                    const Icon(Icons.whatshot, color: Color(0xFFFF9800), size: 18)
                                  else
                                    SvgPicture.asset(
                                      'assets/icons/icn_intensity.svg',
                                      colorFilter: const ColorFilter.mode(Color(0xFFFF9800), BlendMode.srcIn),
                                      height: 18,
                                      width: 18,
                                    ),
                                  const SizedBox(width: 6),
                                  Flexible( // flexible to prevent overflow
                                    child: Text(
                                      displayIntensity,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 0.1,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
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
                          AppStrings.startSession,
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
    );
  }

  String _formatImageUrl(String? url, String fallback) {
    if (url == null || url.isEmpty) return fallback;
    if (url.startsWith('http')) return url;
    
    final uri = Uri.parse(ApiConstants.baseUrl);
    final baseDomain = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    
    if (url.startsWith('/')) {
      return '$baseDomain$url';
    }
    return '$baseDomain/$url';
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
            child: Center(child: Text(AppStrings.noNutritionPlan)),
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
        return const Center(child: Text(AppStrings.unableToLoadDietPlan));
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
          AppStrings.todaysNutrition,
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _buildNutritionCard('$totalCalories', AppStrings.calories, const Color(0xFFF5EAE8)),
            const SizedBox(width: AppSpacing.md),
            _buildNutritionCard('${protein}g', AppStrings.protein, const Color(0xFFF5EAE8)),
            const SizedBox(width: AppSpacing.md),
            _buildNutritionCard(waterGlasses.toString().padLeft(2, '0'), AppStrings.glasses, const Color(0xFFF5EAE8)),
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
          ...dietPlan.meals!.map((meal) => _buildMealCard(meal)).toList(),
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
              child: _buildGuidanceCard(
                icon: Icons.lightbulb_outline, // Fallback icon if image fails loading
                iconUrl: guidance.iconUrl,
                title: guidance.title ?? AppStrings.guidance,
                subtitle: guidance.subtitle ?? AppStrings.tapForDetails,
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
                  meal.name ?? AppStrings.unknownMeal,
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
                    '${meal.calories} ${AppStrings.kcal}',
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
    return const HealthResultsTab();
  }

  Widget _buildInsightsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Recent Insights Section
        Text(
          AppStrings.recentInsights,
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildGuidanceCard(
          icon: Icons.bed_outlined, // Sleep icon
          title: AppStrings.sleepQualityImproved,
          subtitle: AppStrings.sleepQualityDesc,
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildGuidanceCard(
          icon: Icons.track_changes_outlined, // Activity/Target icon
          title: AppStrings.activityGoalMet,
          subtitle: AppStrings.activityGoalDesc,
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.md),
        _buildGuidanceCard(
          icon: Icons.psychology_outlined, // Stress/Mind icon
          title: AppStrings.stressLevels,
          subtitle: AppStrings.stressLevelsDesc,
          iconColor: const Color(0xFFA05E44),
        ),
        const SizedBox(height: AppSpacing.xl),
        
        // New Daily Logging UI
        Text(
          "Daily Log",
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFF4A4A4A),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        const HealthInsightsTab(),
      ],
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

class _ExerciseImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  
  const _ExerciseImageCarousel({required this.imageUrls});

  @override
  State<_ExerciseImageCarousel> createState() => _ExerciseImageCarouselState();
}

class _ExerciseImageCarouselState extends State<_ExerciseImageCarousel> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    if (widget.imageUrls.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
        if (!mounted) return;
        if (_currentPage < widget.imageUrls.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        
        if (_pageController.hasClients) {
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
    }
    
    if (widget.imageUrls.length == 1) {
      return Image.network(
        widget.imageUrls.first,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
        },
      );
    }
    
    return PageView.builder(
      controller: _pageController,
      itemCount: widget.imageUrls.length,
      onPageChanged: (index) {
        _currentPage = index;
      },
      itemBuilder: (context, index) {
        return Image.network(
          widget.imageUrls[index],
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
          },
        );
      },
    );
  }
}
