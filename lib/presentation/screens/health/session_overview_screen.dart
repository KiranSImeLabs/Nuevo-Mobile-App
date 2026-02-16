import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class SessionOverviewScreen extends StatelessWidget {
  const SessionOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Column(
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
                        'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Title
                  const Text(
                    "Lower body strength",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF1E1E1E),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Description
                  const Text(
                    "Focus on building power and stability in your legs and glutes. This routine helps improve your overall mobility.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF757575),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Stats Cards
                  _buildStatCard(
                    icon: Icons.access_time,
                    label: "Duration",
                    value: "20 minutes",
                    iconColor: const Color(0xFFA05E44),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildStatCard(
                    icon: Icons.track_changes_outlined,
                    label: "Purpose",
                    value: "Current phase",
                    iconColor: const Color(0xFFA05E44),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _buildStatCard(
                    icon: Icons.bar_chart,
                    label: "Intensity",
                    value: "Medium",
                    iconColor: const Color(0xFFA05E44),
                  ),
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
                  context.push('/health/guided-session');
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
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
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
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
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
