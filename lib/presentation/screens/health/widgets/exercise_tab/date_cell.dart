import 'package:flutter/material.dart';

class DateCell extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback onTap;

  const DateCell({
    super.key,
    required this.day,
    required this.date,
    required this.isSelected,
    this.isDisabled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
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
      ),
    );
  }
}
