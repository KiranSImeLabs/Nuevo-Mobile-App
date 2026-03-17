import 'package:flutter/material.dart';

class InsightSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const InsightSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFCF3F0), // Light beige from design
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF73584D), size: 28),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF42332D),
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Wrap children in a white container
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFCF8F6),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
