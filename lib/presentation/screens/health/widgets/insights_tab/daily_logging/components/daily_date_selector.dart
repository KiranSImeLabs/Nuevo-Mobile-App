import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyDateSelector extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const DailyDateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<DailyDateSelector> createState() => _DailyDateSelectorState();
}

class _DailyDateSelectorState extends State<DailyDateSelector> {
  late final ScrollController _dateScrollController;

  @override
  void initState() {
    super.initState();
    _dateScrollController = ScrollController();
    
    // Scroll date selector to the end (today) after layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dateScrollController.hasClients) {
        _dateScrollController.jumpTo(_dateScrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _dateScrollController.dispose();
    super.dispose();
  }

  String _formatDateKey(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final List<DateTime> pastDays = List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });

    return Container(
      height: 76,
      margin: const EdgeInsets.only(bottom: 24),
      child: ListView.builder(
        controller: _dateScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: pastDays.length,
        itemBuilder: (context, index) {
          final date = pastDays[index];
          final isSelected =
              _formatDateKey(date) == _formatDateKey(widget.selectedDate);

          final dayName = DateFormat('EE').format(date);
          final dayNum = DateFormat('d').format(date);

          return GestureDetector(
            onTap: () => widget.onDateSelected(date),
            child: Container(
              width: 55,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFA05E44)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFA05E44)
                      : const Color(0xFFDCD2CE),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    dayName,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : const Color(0xFFA0A0A0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dayNum,
                    style: TextStyle(
                      fontSize: 18,
                      color: isSelected
                          ? Colors.white
                          : const Color(0xFF42332D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
