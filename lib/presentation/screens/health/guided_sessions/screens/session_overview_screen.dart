import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../providers/health_provider.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../data/models/daily_exercise_model.dart';
import '../../../../../data/models/active_progress_model.dart';
import '../../../../../core/constants/app_strings.dart';

class SessionOverviewScreen extends ConsumerStatefulWidget {
  final String sessionId;
  final GuidedSessionModel? predefinedSession;

  const SessionOverviewScreen({super.key, required this.sessionId, this.predefinedSession});

  @override
  ConsumerState<SessionOverviewScreen> createState() => _SessionOverviewScreenState();
}

class _SessionOverviewScreenState extends ConsumerState<SessionOverviewScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _hasManuallySelectedStep = false;

  @override
  void initState() {
    super.initState();
    // viewportFraction < 1 allows a peek of the adjacent cards, indicating a swipable carousel
    _pageController = PageController(viewportFraction: 0.92);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger active progress fetch on load
    ref.watch(activeProgressProvider);
    
    // Listen to active progress to update the starting page if there is a saved session
    ref.listen<AsyncValue<ActiveProgressModel?>>(
      activeProgressProvider,
      (previous, next) {
        if (!next.isLoading && next.hasValue && next.value != null) {
          final progress = next.value!;
          if (progress.sessionId == widget.sessionId && !_hasManuallySelectedStep) {
            // Find 0-based index
            int savedIndex = (progress.currentStepIndex ?? 1) - 1;
            if (savedIndex < 0) savedIndex = 0;
            
            // Only jump if we have clients and the index has changed
            if (_pageController.hasClients && _currentPage != savedIndex) {
               // We don't know the exact length here synchronously without reading session details,
               // but jumping to a non-existent page will just clamp or throw, usually PageController handles it or we 
               // can just animate to it.
               setState(() {
                 _currentPage = savedIndex;
               });
               // Use addPostFrameCallback to ensure the list is built before jumping
               WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_pageController.hasClients) {
                    _pageController.jumpToPage(savedIndex);
                  }
               });
            }
          }
        }
      },
    );

    final sessionAsync = widget.predefinedSession != null 
        ? AsyncValue.data(widget.predefinedSession) 
        : ref.watch(sessionDetailsProvider(widget.sessionId));

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
          AppStrings.sessionOverview,
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
        error: (error, stackTrace) => Center(child: Text('${AppStrings.failedToLoadSession}$error')),
        data: (session) {
          if (session == null) {
            return const Center(child: Text(AppStrings.sessionNotFound));
          }

          final steps = session.steps ?? [];

          return Column(
            children: [
              Expanded(
                child: steps.isEmpty 
                    ? _buildSingleView(
                        title: session.title ?? AppStrings.guidedSession,
                        description: session.description,
                        duration: session.duration,
                        imageUrl: session.imageUrl,
                        purpose: session.purpose,
                        intensity: session.intensity,
                      )
                    : PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                            _hasManuallySelectedStep = true;
                          });
                        },
                        itemCount: steps.length,
                        itemBuilder: (context, index) {
                          final step = steps[index];
                          return _buildSingleView(
                            title: step.title ?? "${AppStrings.stepPrefix}${index + 1}",
                            description: step.description,
                            duration: step.duration,
                            // Step image if available and not empty, else session image
                            imageUrl: (step.imageUrl != null && step.imageUrl!.trim().isNotEmpty)
                                ? step.imageUrl
                                : session.imageUrl,
                            // Stats inherit purpose and intensity from session
                            purpose: session.purpose,
                            intensity: session.intensity,
                            stepIndex: index + 1,
                            totalSteps: steps.length,
                          );
                        },
                      ),
              ),

              // Carousel Page Indicators
              if (steps.length > 1)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      steps.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index 
                              ? const Color(0xFFA05E44) 
                              : const Color(0xFFE0E0E0),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
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
                    onPressed: () async {
                      try {
                        // Read active progress to get currentTimeInStep
                        ActiveProgressModel? activeProgress;
                        try {
                          activeProgress = await ref.read(activeProgressProvider.future);
                        } catch (e) {
                          debugPrint('Error fetching active progress: $e');
                          // If activeProgress throws (e.g. 404 not found or server data null error),
                          // treat it as null and default to starting at 0.
                          activeProgress = null;
                        }
                        
                        int currentTimeInStep = 0;
                        int stepIndexToSend = _currentPage + 1;
                        
                        // If active data exists and matches current step, use its time
                        if (activeProgress != null && 
                            activeProgress.sessionId == widget.sessionId &&
                            activeProgress.currentStepIndex == stepIndexToSend) {
                          currentTimeInStep = activeProgress.currentTimeInStep ?? 0;
                        } else if (activeProgress == null) {
                          // Explicitly set to zero if active session data is null
                          currentTimeInStep = 0;
                          stepIndexToSend = _currentPage + 1; // currentStepIndex as selected step
                        }

                        if (activeProgress != null) {
                          final progressData = {
                            "currentStepIndex": stepIndexToSend,
                            "currentTimeInStep": currentTimeInStep,
                            "heartRate": 120,
                          };

                          await ref.read(syncSessionProgressProvider({
                            'id': widget.sessionId,
                            'data': progressData,
                          }).future);
                        }

                        int? initialStep;
                        if (_hasManuallySelectedStep) {
                          initialStep = _currentPage;
                        }
                        
                        if (context.mounted) {
                          await context.push('/health/guided-session', extra: {
                            'sessionId': widget.sessionId,
                            'steps': session.steps,
                            'initialStepIndex': initialStep,
                          });
                          
                          // Refresh active progress when returning from guided session
                          ref.invalidate(activeProgressProvider);
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${AppStrings.failedToSyncProgress}$e')),
                          );
                        }
                      }
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
                          AppStrings.beginSession,
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

  Widget _buildSingleView({
    required String title,
    String? description,
    int? duration,
    String? imageUrl,
    String? purpose,
    String? intensity,
    int? stepIndex,
    int? totalSteps,
  }) {
    final bool isCarousel = totalSteps != null && totalSteps > 1;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: isCarousel ? 8.0 : AppSpacing.lg, // Less padding if in a carousel to account for viewport fraction
        vertical: AppSpacing.lg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              Container(
                height: 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFFE0E0E0),
                  boxShadow: isCarousel ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ] : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    _formatImageUrl(imageUrl, 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80'), // Yoga/Fitness fallback
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey));
                    },
                  ),
                ),
              ),
              if (isCarousel)
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      AppStrings.stepOf.replaceFirst('%s', '$stepIndex').replaceFirst('%s', '$totalSteps'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),

          // Title
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1E1E1E),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Description
          if (description != null && description.isNotEmpty) ...[
            Text(
              description,
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
            label: AppStrings.duration,
            value: "${duration != null ? (duration / 60).ceil() : 0} ${AppStrings.min}",
          ),
          if (purpose != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildStatCard(
              iconWidget: SvgPicture.asset(
                'assets/icons/icn_purpose.svg',
                colorFilter: const ColorFilter.mode(Color(0xFFA05E44), BlendMode.srcIn),
                height: 24,
                width: 24,
              ),
              label: AppStrings.purpose,
              value: purpose,
            ),
          ],
          if (intensity != null) ...[
            const SizedBox(height: AppSpacing.md),
            _buildStatCard(
              iconWidget: SvgPicture.asset(
                'assets/icons/icn_intensity.svg',
                colorFilter: const ColorFilter.mode(Color(0xFFA05E44), BlendMode.srcIn),
                height: 24,
                width: 24,
              ),
              label: AppStrings.intensity,
              value: intensity,
            ),
          ],
        ],
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
