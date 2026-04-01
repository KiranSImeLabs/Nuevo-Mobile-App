import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../data/models/daily_exercise_model.dart';
import 'exercise_image_carousel.dart';
import '../../../../../core/constants/app_constants.dart';

class TodayExerciseCard extends StatelessWidget {
  final DailyExerciseModel exerciseData;

  const TodayExerciseCard({super.key, required this.exerciseData});

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
    final session = exerciseData.session!;
    
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
              height: 180, // Using fixed height instead of MediaQuery for stability
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
                      return ExerciseImageCarousel(imageUrls: stepImageUrls);
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
                                  Flexible(
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
                                width: 20, 
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
}
