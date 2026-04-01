import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../providers/health_provider.dart';
import '../../../../providers/specialist_provider.dart';
import '../../../../../data/models/daily_exercise_model.dart';
import 'date_cell.dart';
import 'today_exercise_card.dart';

class ExerciseTabContent extends ConsumerStatefulWidget {
  const ExerciseTabContent({super.key});

  @override
  ConsumerState<ExerciseTabContent> createState() => _ExerciseTabContentState();
}

class _ExerciseTabContentState extends ConsumerState<ExerciseTabContent> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
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
                    child: DateCell(
                      day: dayFormatter.format(date).toUpperCase(),
                      date: dateFormatter.format(date),
                      isSelected: isSelected,
                      isDisabled: isDisabled,
                      onTap: () {
                        setState(() {
                          _selectedDate = date;
                        });
                      },
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
                  return TodayExerciseCard(exerciseData: exerciseData);
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
                  
                  return TodayExerciseCard(exerciseData: selectedExercise);
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
}
