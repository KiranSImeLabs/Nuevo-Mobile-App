import 'package:flutter/material.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../data/models/diet_plan_model.dart';
import '../../../../../core/constants/app_constants.dart';

class MealCard extends StatelessWidget {
  final MealModel meal;

  const MealCard({super.key, required this.meal});

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

  @override
  Widget build(BuildContext context) {
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
                    ? NetworkImage(_formatImageUrl(meal.imageUrl!, '')) 
                    : const AssetImage('assets/images/daily_nutrition.png') as ImageProvider,
                fit: BoxFit.cover,
                onError: (exception, stackTrace) {},
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
}
