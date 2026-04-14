import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../utils/responsive_utils.dart';
import '../../../domain/entities/session.dart';
import '../../widgets/appointments/appointment_card.dart';
import 'package:go_router/go_router.dart';
import '../../providers/specialist_provider.dart';
import '../../providers/appointment_provider.dart';

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
    final appointmentsState = ref.watch(userAppointmentsProvider);

    // Filter appointments from state
    final List<Session> upcomingAppointments = [];
    final List<Session> pastAppointments = [];

    appointmentsState.whenData((data) {
      final now = DateTime.now();
      for (final detail in data.appointments) {
        final session = Session.fromAppointmentDetail(detail);
        
        final isUpcoming = detail.period == 'upcoming' || 
            (detail.period == null && session.scheduledTime.isAfter(now));
            
        final isPast = detail.period == 'past' || 
            (detail.period == null && session.scheduledTime.isBefore(now));

        if (isUpcoming) {
          upcomingAppointments.add(session);
        } else if (isPast) {
          pastAppointments.add(session);
        }
      }
    });

    // Mock Data for "Sessions to Schedule" (keeping placeholders until business logic for these is defined via specialists)
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
              /* _buildSectionHeader(context, 'Upcoming'),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
              appointmentsState.when(
                data: (_) {
                  if (upcomingAppointments.isEmpty) {
                    return _buildEmptyState(context, 'No upcoming appointments.');
                  }
                  return Column(
                    children: upcomingAppointments
                        .map((session) => AppointmentCard(
                              session: session,
                              type: AppointmentCardType.upcoming,
                            ))
                        .toList(),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, _) => Center(child: Text('Error: $error')),
              ),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 24)), */

              // 3. Past Appointments
              _buildSectionHeader(context, 'Past Appointments'),
              SizedBox(height: ResponsiveUtils.spacing(context, base: 12)),
              appointmentsState.when(
                data: (_) {
                  if (pastAppointments.isEmpty) {
                    return _buildEmptyState(context, 'No past appointments.');
                  }
                  return Column(
                    children: pastAppointments
                        .map((session) => AppointmentCard(
                              session: session,
                              type: AppointmentCardType.past,
                            ))
                        .toList(),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (error, _) => const SizedBox.shrink(),
              ),
              // Add some bottom padding for scroll
              SizedBox(height: ResponsiveUtils.spacing(context, base: 40)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveUtils.spacing(context, base: 16),
      ),
      child: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
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
