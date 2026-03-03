import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/health_provider.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/daily_exercise_model.dart';

class SessionOverviewScreen extends ConsumerWidget {
  final String sessionId;
  final GuidedSessionModel? predefinedSession;

  const SessionOverviewScreen({super.key, required this.sessionId, this.predefinedSession});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionAsync = predefinedSession != null 
        ? AsyncValue.data(predefinedSession) 
        : ref.watch(sessionDetailsProvider(sessionId));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Session Overview",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: sessionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFFA05E44))),
        error: (error, stackTrace) => Center(child: Text('Failed to load session details: $error')),
        data: (session) {
          if (session == null) {
            return const Center(child: Text("Session not found"));
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFFE0E0E0),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            _formatImageUrl(session.imageUrl, 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80'), // Yoga/Fitness fallback
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Title
                      Text(
                        session.title ?? "Guided Session",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF1E1E1E),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),

                      // Description
                      if (session.description != null) ...[
                        Text(
                          session.description!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF757575),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                      ],

                      // Stats Cards
                      _buildStatCard(
                        iconWidget: const Icon(Icons.schedule_outlined, color: Color(0xFFA05E44), size: 24),
                        label: "Duration",
                        value: "${session.duration ?? 0} minutes",
                      ),
                      if (session.purpose != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildStatCard(
                          iconWidget: SvgPicture.asset(
                            'assets/icons/icn_purpose.svg',
                            colorFilter: const ColorFilter.mode(Color(0xFFA05E44), BlendMode.srcIn),
                            height: 24,
                            width: 24,
                          ),
                          label: "Purpose",
                          value: session.purpose!,
                        ),
                      ],
                      if (session.intensity != null) ...[
                        const SizedBox(height: AppSpacing.md),
                        _buildStatCard(
                          iconWidget: SvgPicture.asset(
                            'assets/icons/icn_intensity.svg',
                            colorFilter: const ColorFilter.mode(Color(0xFFA05E44), BlendMode.srcIn),
                            height: 24,
                            width: 24,
                          ),
                          label: "Intensity",
                          value: session.intensity!,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // Bottom Button
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push('/health/guided-session', extra: {
                        'sessionId': sessionId,
                        'steps': session.steps,
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFA05E44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_circle_outline, color: Colors.white, size: 24),
                        SizedBox(width: 8),
                        Text(
                          "Begin Session",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

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

  Widget _buildStatCard({
    required Widget iconWidget,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F1F0), // Light beige/rose background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: iconWidget,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF8C8C8C), // Grey/Brown text
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1E1E1E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
