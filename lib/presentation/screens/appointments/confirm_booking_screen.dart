import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/session.dart';
import '../../../data/models/appointment_model.dart';
import 'widgets/booking_success_sheet.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/appointment_provider.dart';

/// Arguments passed from SelectTimeScreen → ConfirmBookingScreen
class BookingArgs {
  final Session session;
  final TimeSlot selectedSlot;
  final String memberId;

  const BookingArgs({
    required this.session,
    required this.selectedSlot,
    required this.memberId,
  });
}

class ConfirmBookingScreen extends ConsumerStatefulWidget {
  final BookingArgs args;

  const ConfirmBookingScreen({
    super.key,
    required this.args,
  });

  @override
  ConsumerState<ConfirmBookingScreen> createState() =>
      _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends ConsumerState<ConfirmBookingScreen> {
  bool _isLoading = false;

  Future<void> _handleConfirm() async {
    setState(() => _isLoading = true);

    try {
      final repository = ref.read(appointmentRepositoryProvider);
      final response = await repository.bookAppointment(
        memberId: widget.args.memberId,
        startTime: widget.args.selectedSlot.startTime,
      );

      if (!mounted) return;

      if (response.success) {
        final appointmentId = response.data?.appointment?.id ?? '';
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => BookingSuccessSheet(
            session: widget.args.session,
            selectedSlot: widget.args.selectedSlot,
            appointmentId: appointmentId,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(response.message ?? 'Failed to book appointment')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final slot = widget.args.selectedSlot;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Confirm booking',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Booking Details Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EAE8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.args.session.title,
                                style: AppTextStyles.h3.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Part of your Insight Program',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8D5D1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Upcoming',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.primaryButtonColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Divider(color: Color(0xFFE0E0E0), height: 1),
                    const SizedBox(height: 24),

                    // Details
                    _buildDetailRow(
                      context,
                      icon: Icons.calendar_today_outlined,
                      label: 'Date',
                      value: _parseDateFromStartTime(slot.startTime),
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      context,
                      icon: Icons.access_time,
                      label: 'Time',
                      value: slot.displayTime,
                    ),
                    const SizedBox(height: 24),
                    _buildDetailRow(
                      context,
                      icon: Icons.person_outline,
                      label: 'With',
                      value: widget.args.session.professionalName ?? 'Specialist',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Confirm Button
              ElevatedButton(
                onPressed: _isLoading ? null : _handleConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryButtonColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Confirm booking',
                            style: AppTextStyles.button.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 20),
                        ],
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// Attempt to parse a human-readable date from the ISO startTime string
  String _parseDateFromStartTime(String startTime) {
    try {
      final dt = DateTime.parse(startTime).toLocal();
      return DateFormat('EEEE, d MMMM').format(dt);
    } catch (_) {
      return startTime;
    }
  }

  Widget _buildDetailRow(BuildContext context,
      {required IconData icon,
      required String label,
      required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF964A38)),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
