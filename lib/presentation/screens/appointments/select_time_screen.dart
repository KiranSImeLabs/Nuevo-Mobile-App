import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/session.dart';
import '../../../data/models/appointment_model.dart';
import 'confirm_booking_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/appointment_provider.dart';

class SelectTimeScreen extends ConsumerStatefulWidget {
  final Session session;

  const SelectTimeScreen({
    super.key,
    required this.session,
  });

  @override
  ConsumerState<SelectTimeScreen> createState() => _SelectTimeScreenState();
}

class _SelectTimeScreenState extends ConsumerState<SelectTimeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeSlot? _selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Select a time',
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProviderInfoCard(),
              const SizedBox(height: 24),
              _buildCustomCalendar(),
              const SizedBox(height: 24),
              Text(
                'Available times',
                style: AppTextStyles.h3.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              if (_selectedDay != null) _buildTimeSlotsList(),
              const SizedBox(height: 32),
              _buildContinueButton(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProviderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: const Icon(Icons.person, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.session.professionalName ?? 'Specialist',
                  style: AppTextStyles.h3.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${widget.session.title} • ${widget.session.durationMinutes} min',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: _selectedTimeSlot != null && _selectedDay != null
          ? () {
              final args = BookingArgs(
                session: widget.session,
                selectedSlot: _selectedTimeSlot!,
                memberId: widget.session.id,
              );
              context.push('/confirm-booking', extra: args);
            }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryButtonColor,
        disabledBackgroundColor: AppColors.primaryButtonColor.withOpacity(0.5),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Continue',
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
    );
  }

  Widget _buildCustomCalendar() {
    final now = DateTime.now();
    final isCurrentMonth =
        _focusedDay.year == now.year && _focusedDay.month == now.month;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EAE8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left,
                    color: isCurrentMonth
                        ? Colors.grey[400]
                        : AppColors.textSecondary),
                onPressed: isCurrentMonth
                    ? null
                    : () {
                        setState(() {
                          _focusedDay = DateTime(
                              _focusedDay.year, _focusedDay.month - 1);
                        });
                      },
              ),
              Text(
                DateFormat('MMMM yyyy').format(_focusedDay),
                style: AppTextStyles.h3.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right,
                    color: AppColors.textSecondary),
                onPressed: () {
                  setState(() {
                    _focusedDay =
                        DateTime(_focusedDay.year, _focusedDay.month + 1);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map((day) {
              return SizedBox(
                width: 32,
                child: Center(
                  child: Text(
                    day,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          _buildCalendarGrid(),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final daysInMonth =
        DateUtils.getDaysInMonth(_focusedDay.year, _focusedDay.month);
    final firstDayOfMonth =
        DateTime(_focusedDay.year, _focusedDay.month, 1);
    final int weekdayOffset = firstDayOfMonth.weekday % 7;

    final List<Widget> rows = [];
    List<Widget> dayWidgets = [];

    for (int i = 0; i < weekdayOffset; i++) {
      final prevMonth =
          DateTime(_focusedDay.year, _focusedDay.month - 1);
      final daysInPrevMonth =
          DateUtils.getDaysInMonth(prevMonth.year, prevMonth.month);
      final dayNum = daysInPrevMonth - (weekdayOffset - i) + 1;

      dayWidgets.add(SizedBox(
        width: 32,
        height: 32,
        child: Center(
          child: Text('$dayNum',
              style: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
        ),
      ));
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(_focusedDay.year, _focusedDay.month, i);
      final isSelected =
          _selectedDay != null && DateUtils.isSameDay(_selectedDay, date);
      final isPastDate = date.isBefore(today);

      dayWidgets.add(GestureDetector(
        onTap: isPastDate
            ? null
            : () {
                setState(() {
                  _selectedDay = date;
                  _selectedTimeSlot = null;
                });
              },
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border:
                isSelected ? Border.all(color: const Color(0xFFA65C4B)) : null,
            color: Colors.transparent,
          ),
          child: Center(
            child: Text(
              '$i',
              style: TextStyle(
                color: isPastDate
                    ? const Color(0xFFBDBDBD)
                    : (isSelected
                        ? const Color(0xFFA65C4B)
                        : AppColors.textPrimary),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ));

      if (dayWidgets.length == 7) {
        rows.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.from(dayWidgets),
        ));
        dayWidgets = [];
        rows.add(const SizedBox(height: 12));
      }
    }

    if (dayWidgets.isNotEmpty) {
      int nextMonthDay = 1;
      while (dayWidgets.length < 7) {
        dayWidgets.add(SizedBox(
          width: 32,
          height: 32,
          child: Center(
            child: Text('$nextMonthDay',
                style:
                    const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14)),
          ),
        ));
        nextMonthDay++;
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.from(dayWidgets),
      ));
    }

    return Column(children: rows);
  }

  Widget _buildTimeSlotsList() {
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDay!);
    final memberId = widget.session.id;
    final key = (memberId: memberId, date: dateStr);
    final timeSlotsAsync = ref.watch(timeSlotsProvider(key));

    return timeSlotsAsync.when(
      data: (slotResponse) {
        if (!slotResponse.isWorkingDay) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'No slots available on this day',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }

        if (slotResponse.slots.isEmpty || slotResponse.availableSlots == 0) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                'No available time slots',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: slotResponse.slots.map((slot) {
            final isSelected =
                _selectedTimeSlot?.startTime == slot.startTime;
            final isUnavailable = !slot.available;

            return GestureDetector(
              onTap: isUnavailable
                  ? null
                  : () {
                      setState(() {
                        _selectedTimeSlot = slot;
                      });
                    },
              child: Container(
                width: (MediaQuery.of(context).size.width - 48 - 24) / 3,
                padding: const EdgeInsets.symmetric(vertical: 12),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isUnavailable
                      ? const Color(0xFFEEEEEE)
                      : isSelected
                          ? const Color(0xFF964A38)
                          : const Color(0xFFF5EAE8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  slot.displayTime,
                  style: TextStyle(
                    color: isUnavailable
                        ? const Color(0xFFBDBDBD)
                        : isSelected
                            ? Colors.white
                            : const Color(0xFF5D4037),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Text(
            'Failed to load time slots.\nPlease try again.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
