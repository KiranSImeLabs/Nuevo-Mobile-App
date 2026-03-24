import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';
import '../../../domain/entities/session.dart';
import '../../widgets/appointments/appointment_card.dart';
import 'package:go_router/go_router.dart';
import '../../providers/specialist_provider.dart';

class AppointmentsScreen extends ConsumerStatefulWidget {
  const AppointmentsScreen({super.key});

  @override
  ConsumerState<AppointmentsScreen> createState() => _AppointmentsScreenState();
}

class _AppointmentsScreenState extends ConsumerState<AppointmentsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(specialistListProvider.notifier).fetchSpecialists();
    });
  }

  @override
  Widget build(BuildContext context) {
    final specialistState = ref.watch(specialistListProvider);


    // Mock Data
    final sessionsToSchedule = [
      Session(
        id: '1',
        title: 'Nutrition Consultation',
        type: SessionType.dietitian,
        scheduledTime: DateTime.now(), // Placeholder
        durationMinutes: 30,
        professionalName: 'Lisa Thompson',
        isCompleted: false,
      ),
      Session(
        id: '2',
        title: 'Follow-up Check-in',
        type: SessionType.doctor,
        scheduledTime: DateTime.now(), // Placeholder
        durationMinutes: 15,
        professionalName: 'Dr. Sarah Martinez',
        isCompleted: false,
      ),
    ];

    final upcomingAppointments = [
      Session(
        id: '3',
        title: 'Telehealth Visit',
        type: SessionType.doctor,
        scheduledTime: DateTime.now().add(const Duration(hours: 2)), // Today 2:30PM
        durationMinutes: 30,
        professionalName: 'Dr. Sarah Martinez',
        notes: 'Virtual Visit',
        isCompleted: false,
      ),
      Session(
        id: '4',
        title: 'Fitness Assessment',
        type: SessionType.trainer,
        scheduledTime: DateTime.now().add(const Duration(hours: 3)),
        durationMinutes: 45,
        professionalName: 'Make Chen',
        notes: 'Wellness Center, Room 204',
        isCompleted: false,
      ),
    ];

    final pastAppointments = [
       Session(
        id: '5',
        title: 'Initial Consultation',
        type: SessionType.doctor,
        scheduledTime: DateTime(2024, 12, 20),
        durationMinutes: 30,
        professionalName: 'Dr. Sarah Martinez',
        isCompleted: true,
      ),
      Session(
        id: '6',
        title: 'Initial Consultation',
        type: SessionType.doctor,
        scheduledTime: DateTime(2024, 12, 20),
        durationMinutes: 30,
        professionalName: 'Dr. Sarah Martinez',
        isCompleted: true,
      ),
       Session(
        id: '7',
        title: 'Initial Consultation',
        type: SessionType.doctor,
        scheduledTime: DateTime(2024, 12, 20),
        durationMinutes: 30,
        professionalName: 'Dr. Sarah Martinez',
        isCompleted: true,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB), // Slightly off-white/beige as per design
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Text(
                  'Appointments',
                  style: AppTextStyles.h2.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: ResponsiveUtils.fontSize(context, base: 18),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),

              // 1. Sessions to Schedule
              _buildSectionHeader(context, 'Sessions to Schedule'),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
              specialistState.when(
                data: (specialists) {
                  if (specialists.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.spacing(context, base: 16),
                      ),
                      child: Text(
                        'No doctors available to schedule.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }

                  return Column(
                    children: List.generate(specialists.length, (index) {
                      final doctor = specialists[index];
                      final templateSession = sessionsToSchedule[index % sessionsToSchedule.length];
                      
                      final mappedSession = Session(
                        id: doctor.id, 
                        title: templateSession.title,
                        type: templateSession.type,
                        scheduledTime: templateSession.scheduledTime,
                        durationMinutes: templateSession.durationMinutes,
                        professionalName: doctor.fullName,
                        isCompleted: false,
                      );

                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: ResponsiveUtils.spacing(context, base: 12),
                        ),
                        child: AppointmentCard(
                          session: mappedSession,
                          type: AppointmentCardType.schedule,
                          onActionTap: () => context.push('/select-time', extra: mappedSession),
                        ),
                      );
                    }),
                  );
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Failed to load doctors.',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),

              // 2. Upcoming
              _buildSectionHeader(context, 'Upcoming'),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
               ...upcomingAppointments.map((session) => AppointmentCard(
                session: session,
                type: AppointmentCardType.upcoming,
              )),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 24)),

              // 3. Past Appointments
              _buildSectionHeader(context, 'Past Appointments'),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
               ...pastAppointments.map((session) => AppointmentCard(
                session: session,
                type: AppointmentCardType.past,
              )),
              // Add some bottom padding for scroll
              SizedBox(height: ResponsiveUtils.spacing(context, base: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.h3.copyWith(
        fontWeight: FontWeight.w400,
        color: const Color(0xFF17110D), // Dark text
        fontSize: ResponsiveUtils.fontSize(context, base: 16),
      ),
    );
  }
}
