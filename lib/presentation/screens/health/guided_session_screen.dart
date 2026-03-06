import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_theme.dart';
import '../../widgets/health/session_completed_sheet.dart';
import '../../widgets/health/session_paused_sheet.dart';
import '../../../data/models/daily_exercise_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/health_provider.dart';
import '../../../data/models/active_progress_model.dart';

class GuidedSessionScreen extends ConsumerStatefulWidget {
  final List<ExerciseStepModel>? steps;
  final String sessionId;
  final int? initialStepIndex;

  const GuidedSessionScreen({super.key, required this.sessionId, this.steps, this.initialStepIndex});

  @override
  ConsumerState<GuidedSessionScreen> createState() =>
      _GuidedSessionScreenState();
}

class _GuidedSessionScreenState extends ConsumerState<GuidedSessionScreen> {
  bool _isPlaying = false;
  bool _isSessionStarted = false;
  bool _isCompletingSession = false;
  bool _isMuted = false;
  int _currentStep = 0;
  Timer? _timer;
  
  final ValueNotifier<int> _elapsedTimeNotifier = ValueNotifier<int>(0);
  final ValueNotifier<int> _videoPositionNotifier = ValueNotifier<int>(0);
  int _currentStepDuration = 0;
  int _replayCount = 0;
  
  void _replayCurrentStep() {
    setState(() {
      _replayCount++;
      _isPlaying = true;
    });
    _resetTimerForCurrentStep();
  }
  
  late PageController _pageController;

  late final List<Map<String, dynamic>> _sessionSteps;

  @override
  void initState() {
    super.initState();
    int initialPage = widget.initialStepIndex ?? 0;
    _pageController = PageController(initialPage: initialPage);
    _currentStep = initialPage;

    if (widget.steps != null && widget.steps!.isNotEmpty) {
      _sessionSteps = widget.steps!
          .map(
            (step) => {
              'title': step.title ?? 'Exercise Step',
              'instruction': step.description ?? '',
              'image': (step.videoUrl != null && step.videoUrl!.isNotEmpty)
                  ? step.videoUrl!
                  : (step.imageUrl ?? ''),
              'poster': step.imageUrl ?? '',
              'isVideo': (step.videoUrl != null && step.videoUrl!.isNotEmpty),
              'duration': step.duration ?? 30,
              'subtitles': step.subtitles ?? [],
              'order': step.order ?? 0,
            },
          )
          .toList();
    } else {
      _sessionSteps = [];
    }
    
    _resetTimerForCurrentStep();
    _checkActiveProgress();
  }

  Future<void> _checkActiveProgress() async {
    try {
      final progress = await ref.read(activeProgressProvider.future);
      if (progress != null &&
          progress.status == 'STARTED' &&
          progress.sessionId == widget.sessionId) {
        // We have an active session for THIS specific session ID
        setState(() {
          _isSessionStarted = true;
          _isPlaying = false;
          
          if (widget.initialStepIndex == null) {
            // 1. Find the correct step index by mapping 1-based API index to 0-based list
            int savedOrder = progress.currentStepIndex ?? 1;
            
            // Map directly 1-based API index to 0-based array index
            int foundIndex = savedOrder - 1;
            
            if (foundIndex < 0) foundIndex = 0;
            if (foundIndex >= _sessionSteps.length) foundIndex = _sessionSteps.length - 1;
            
            _currentStep = foundIndex;
            _resetTimerForCurrentStep();
            
            // 2. Set the elapsed time to the saved paused time
            int savedTime = progress.currentTimeInStep ?? 0;
            if (savedTime < 0) savedTime = 0;
            if (savedTime > _currentStepDuration) savedTime = _currentStepDuration;
            
            _elapsedTimeNotifier.value = savedTime;
            
            // Pass the exact time to the video player as well
            _videoPositionNotifier.value = savedTime;

            // Jump to correct page
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (_pageController.hasClients) {
                _pageController.jumpToPage(_currentStep);
              }
            });
          }
        });
      }
    } catch (e) {
      debugPrint('Failed to load active progress: $e');
    }
  }

  Future<void> _startSessionOnBackend() async {
    try {
      // Call the API to start the session immediately when the screen loads
      await ref.read(startSessionProvider(widget.sessionId).future);
      debugPrint('Session started successfully on backend');
    } catch (e) {
      debugPrint('Failed to start session on backend: $e');
      // We don't block the UI if this fails, we just log it
    }
  }

  void _syncProgress() {
    if (!_isSessionStarted) return;
    
    // Note: API expects 'currentStepIndex' 
    // We strictly map 0-based array index to 1-based API index
    final int stepOrder = _currentStep + 1;

    final data = {
      "currentStepIndex": stepOrder,
      "currentTimeInStep": _elapsedTimeNotifier.value,
      "heartRate": 120 // Static for now as requested or placeholder
    };
    
    ref.read(syncSessionProgressProvider({
      'id': widget.sessionId,
      'data': data,
    }).future).then((_) {
      debugPrint('Progress synced successfully for step $stepOrder');
    }).catchError((e) {
      if (e.toString().contains('404')) {
        // Suppress 404 if the backend route isn't deployed yet
        return;
      }
      debugPrint('Failed to sync progress: $e');
    });
  }

  void _onPlayPauseTapped() {
    if (!_isSessionStarted) {
      // First time play is tapped -> Start the session
      setState(() {
        _isSessionStarted = true;
        _isPlaying = true;
      });
      _startSessionOnBackend();
      _startTimer();
    } else {
      // Toggle play/pause
      setState(() {
        _isPlaying = !_isPlaying;
      });

      // Sync progress when pausing
      if (!_isPlaying) {
        _timer?.cancel();
        _syncProgress();
        _showPausedSheet();
      } else {
        _startTimer();
      }
    }
  }

  void _showPausedSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => SessionPausedSheet(
        timeString: _formatDuration(_elapsedTimeNotifier.value),
        heartRate: 128, // Static matching the design requirement
        onResume: () {
          Navigator.pop(context);
          setState(() {
            _isPlaying = true;
          });
          _startTimer();
        },
        onEnd: () {
          Navigator.pop(context);
          _endSession();
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _elapsedTimeNotifier.dispose();
    _videoPositionNotifier.dispose();
    super.dispose();
  }

  bool _isTransitioning = false;

  void _nextStep() {
    if (_isTransitioning) return;
    
    if (_currentStep < _sessionSteps.length - 1) {
      _isTransitioning = true;
      _resetTimerForCurrentStep();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      ).then((_) {
        if (mounted) {
          setState(() {
            _isTransitioning = false;
          });
        }
      });
    } else {
      _endSession();
    }
  }

  Future<void> _endSession() async {
    setState(() {
      _isPlaying = false;
      _isCompletingSession = true;
    });

    try {
      final response = await ref.read(completeSessionProvider(widget.sessionId).future);
      
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => SessionCompletedSheet(message: response?.message),
      );
    } catch (e) {
      if (!mounted) return;
      // If it fails, we fall back to popping the screen since the user wanted to end it anyway
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete session: $e')),
      );
      context.pop();
    } finally {
      if (mounted) {
        _timer?.cancel();
        setState(() {
          _isCompletingSession = false;
        });
      }
    }
  }

  void _onStepChanged(int index) {
    if (_isSessionStarted && index != _currentStep) {
      _syncProgress(); // Sync progress when changing steps manually
    }
    setState(() {
      _currentStep = index;
    });
    _resetTimerForCurrentStep();
  }

  void _resetTimerForCurrentStep() {
    _timer?.cancel();
    
    // Safety check just in case
    if (_sessionSteps.isEmpty || _currentStep >= _sessionSteps.length) {
      return;
    }
    
    _currentStepDuration = _sessionSteps[_currentStep]['duration'] ?? 30;
    _elapsedTimeNotifier.value = 0; // Reset progress tracker
    _videoPositionNotifier.value = 0; // Reset video position to match progress tracker and avoid mis-syncs
    
    if (_isPlaying) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_elapsedTimeNotifier.value < _currentStepDuration) {
        _elapsedTimeNotifier.value++;
      } else {
        // Auto-advance to next step when timer reaches duration
        timer.cancel();
        _nextStep();
      }
    });
  }

  String _formatDuration(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Map<String, String> _getCurrentSubtitleData(Map<String, dynamic> stepData, int currentElapsed) {
    final List<dynamic>? subtitles = stepData['subtitles'];
    final defaultTitle = stepData['title'] as String;
    final defaultDesc = stepData['instruction'] as String? ?? stepData['description'] as String? ?? '';

    if (subtitles == null || subtitles.isEmpty) {
      return {'title': defaultTitle, 'description': defaultDesc};
    }

    List<Map<String, dynamic>> parsedSubs = [];
    for (var sub in subtitles) {
      try {
        if (sub is Map) {
          parsedSubs.add({
            'startTime': sub['startTime'] as int? ?? 0,
            'endTime': sub['endTime'] as int?,
            'title': sub['subtitle'] as String? ?? defaultTitle,
            'description': sub['description'] as String? ?? defaultDesc,
          });
        } else {
          // SubtitleModel
          parsedSubs.add({
            'startTime': sub.startTime as int? ?? 0,
            'endTime': sub.endTime as int?,
            'title': sub.subtitle as String? ?? defaultTitle,
            'description': sub.description as String? ?? defaultDesc,
          });
        }
      } catch (e) {
        debugPrint('Error parsing subtitle type: $e');
      }
    }

    // Sort by chronological order
    parsedSubs.sort((a, b) => (a['startTime'] as int).compareTo(b['startTime'] as int));

    Map<String, dynamic>? activeSub;
    
    // Find matching subtitle by interval checks
    for (int i = 0; i < parsedSubs.length; i++) {
        final sub = parsedSubs[i];
        final start = sub['startTime'] as int;
        final end = sub['endTime'] as int?;
        
        if (end != null) {
            // Explicit end time dictates limits
            if (currentElapsed >= start && currentElapsed <= end) {
                activeSub = sub;
            }
        } else {
            // Infer end time from the subsequent subtitle (or infinity if it's the last one)
            final nextStart = (i + 1 < parsedSubs.length) ? parsedSubs[i+1]['startTime'] as int : double.maxFinite.toInt();
            if (currentElapsed >= start && currentElapsed < nextStart) {
                activeSub = sub;
            }
        }
    }

    if (activeSub != null) {
        return {
          'title': activeSub['title'] as String,
          'description': activeSub['description'] as String,
        };
    }

    // Default if out of bounds entirely
    return {'title': defaultTitle, 'description': defaultDesc};
  }

  @override
  Widget build(BuildContext context) {
    if (_sessionSteps.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF5D4037)),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Guided Session',
            style: TextStyle(
              color: Color(0xFF5D4037),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'No session steps available.',
            style: TextStyle(
              color: Color(0xFF5D4037),
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final currentStepData = _sessionSteps[_currentStep];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF5D4037)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Guided Session',
          style: TextStyle(
            color: Color(0xFF5D4037),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Segmented Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 12.0,
            ),
            child: Row(
              children: List.generate(
                _sessionSteps.length,
                (index) => Expanded(
                  child: Container(
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      color: index <= _currentStep
                          ? const Color(0xFFA35940) // Active color
                          : const Color(0xFFEEEAE7), // Inactive color
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10), // gap: 10px

          // Main Visual / PageView
          AspectRatio(
            aspectRatio: 337 / 335,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onStepChanged,
              itemCount: _sessionSteps.length,
              itemBuilder: (context, index) {
                final step = _sessionSteps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Media Background
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: _StepMediaWidget(
                                  url: step['image'],
                                  posterUrl: step['poster'],
                                  isVideo: step['isVideo'] ?? false,
                                  isPlaying: _isPlaying && index == _currentStep,
                                  isMuted: _isMuted,
                                  positionNotifier: index == _currentStep ? _videoPositionNotifier : null,
                                  replayCount: index == _currentStep ? _replayCount : 0,
                                  initialPosition: index == _currentStep && _isSessionStarted && !_isPlaying 
                                      ? _elapsedTimeNotifier.value 
                                      : 0,
                                ),
                              ),
                            ),

                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),

                        // Sound Toggle
                        Positioned(
                          top: 16,
                          right: 16,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isMuted = !_isMuted;
                              });
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                _isMuted ? Icons.volume_off : Icons.volume_up,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),

                        // Timer / Pause Overlay
                        if (_isSessionStarted && index == _currentStep)
                          if (!_isPlaying)
                            Positioned.fill(
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          _buildCircleButton(
                                            icon: Icons.skip_previous_rounded,
                                            onTap: () {
                                              if (_currentStep > 0) {
                                                _syncProgress();
                                                _pageController.previousPage(
                                                  duration: const Duration(milliseconds: 300),
                                                  curve: Curves.easeInOut,
                                                );
                                              }
                                            },
                                            size: 64,
                                            iconColor: Colors.white,
                                            backgroundColor: Colors.white.withOpacity(0.3),
                                          ),
                                          const SizedBox(width: 32),
                                          _buildCircleButton(
                                            icon: Icons.replay_rounded,
                                            onTap: _replayCurrentStep,
                                            size: 64,
                                            iconColor: Colors.white,
                                            backgroundColor: Colors.white.withOpacity(0.3),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 32),
                                      ValueListenableBuilder<int>(
                                        valueListenable: _elapsedTimeNotifier,
                                        builder: (context, elapsed, child) {
                                          final remaining = (_currentStepDuration - elapsed).clamp(0, _currentStepDuration);
                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                'TIME REMAINING',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 1.0,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                _formatDuration(remaining),
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 48,
                                                  fontWeight: FontWeight.w300,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          else
                            Positioned(
                              bottom: 24, // Align closer to bottom
                              left: 0,
                              right: 0,
                              child: ValueListenableBuilder<int>(
                                valueListenable: _elapsedTimeNotifier,
                                builder: (context, elapsed, child) {
                                  final remaining = (_currentStepDuration - elapsed).clamp(0, _currentStepDuration);
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'TIME REMAINING',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _formatDuration(remaining),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 48,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Instruction Card
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 20.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF1ED),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vertical colored bar
                  Container(
                    width: 6,
                    color: const Color(0xFFA35940),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ValueListenableBuilder<int>(
                        valueListenable: currentStepData['isVideo'] ? _videoPositionNotifier : _elapsedTimeNotifier,
                        builder: (context, elapsed, child) {
                          final activeSubtitle = _getCurrentSubtitleData(currentStepData, elapsed);
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                activeSubtitle['title']!,
                                style: const TextStyle(
                                  color: Color(0xFF5D4037),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              if (activeSubtitle['description']!.isNotEmpty) ...[
                                const SizedBox(height: 12),
                                Container(
                                  height: 1,
                                  color: const Color(0xFFE0D6D1),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  activeSubtitle['description']!,
                                  style: const TextStyle(
                                    color: Color(0xFF5D4037),
                                    fontSize: 16,
                                    height: 1.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ],
                          );
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Playback Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous
                Visibility(
                  visible: _currentStep > 0,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: _buildCircleButton(
                    icon: Icons.skip_previous_rounded,
                    onTap: () {
                      if (_currentStep > 0) {
                        _syncProgress();
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    size: 56,
                    iconColor: const Color(0xFF5D4037),
                    backgroundColor: const Color(0xFFFAF1ED),
                  ),
                ),

                // Play/Pause
                _buildCircleButton(
                  icon: _isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  onTap: _onPlayPauseTapped,
                  size: 88,
                  iconColor: Colors.white,
                  backgroundColor: const Color(0xFFA35940),
                  hasShadow: true,
                  border: Border.all(color: const Color(0xFFFAF1ED), width: 4),
                ),

                // Next
                Visibility(
                  visible: _currentStep < _sessionSteps.length - 1,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: _buildCircleButton(
                    icon: Icons.skip_next_rounded,
                    onTap: () {
                      _syncProgress();
                      _nextStep();
                    },
                    size: 56,
                    iconColor: const Color(0xFF5D4037),
                    backgroundColor: const Color(0xFFFAF1ED),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // End Session Button
          if (_isSessionStarted)
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 32.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: _isCompletingSession ? null : _endSession,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                        color: _isCompletingSession
                            ? Colors.grey
                            : const Color(0xFFA35940)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor: const Color(0xFFFAF1ED),
                  ),
                  child: _isCompletingSession
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Color(0xFFA35940),
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'End Session',
                          style: TextStyle(
                            color: Color(0xFFA35940),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          if (!_isSessionStarted)
            const SizedBox(
              height: 88,
            ), // Placeholder for when the button is hidden to avoid UI jumping
        ],
      ),
    ),
  ),
);
  }

  Widget _buildCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    required double size,
    required Color iconColor,
    required Color backgroundColor,
    bool hasShadow = false,
    BoxBorder? border,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: border,
          boxShadow: hasShadow
              ? [
                  BoxShadow(
                    color: const Color(0xFFA35940).withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Icon(icon, color: iconColor, size: size * 0.4),
      ),
    );
  }
}

class _StepMediaWidget extends StatefulWidget {
  final String url;
  final String? posterUrl;
  final bool isVideo;
  final bool isPlaying;
  final bool isMuted;
  final ValueNotifier<int>? positionNotifier;
  final int replayCount;
  final int initialPosition;

  const _StepMediaWidget({
    Key? key,
    required this.url,
    this.posterUrl,
    required this.isVideo,
    required this.isPlaying,
    required this.isMuted,
    this.positionNotifier,
    this.replayCount = 0,
    this.initialPosition = 0,
  }) : super(key: key);

  @override
  State<_StepMediaWidget> createState() => _StepMediaWidgetState();
}

class _StepMediaWidgetState extends State<_StepMediaWidget> {
  VideoPlayerController? _videoController;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initMedia();
  }

  void _videoListener() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      final position = _videoController!.value.position.inSeconds;
      if (widget.positionNotifier != null && widget.positionNotifier!.value != position) {
        // Safe update
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && widget.positionNotifier != null && widget.isPlaying) {
            widget.positionNotifier!.value = position;
          }
        });
      }
    }
  }

  void _initMedia() {
    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..addListener(_videoListener)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            
            // If we have an initial saved position, seek to it immediately
            if (widget.initialPosition > 0) {
               _videoController!.seekTo(Duration(seconds: widget.initialPosition)).then((_) {
                 if (mounted && widget.isPlaying) {
                   _updatePlaybackState();
                 }
               });
            } else {
               _updatePlaybackState();
            }
          }
        }).catchError((error) {
          debugPrint('Video Player error: $error URL: ${widget.url}');
        });
      _videoController?.setLooping(true);
    }
  }

  @override
  void didUpdateWidget(_StepMediaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url || oldWidget.isVideo != widget.isVideo) {
      _videoController?.dispose();
      _videoController = null;
      _isInitialized = false;
      _initMedia();
    } else {
      if (oldWidget.replayCount != widget.replayCount && _videoController != null) {
        _videoController!.seekTo(Duration.zero);
      }

      _updatePlaybackState();
      
      if (oldWidget.isMuted != widget.isMuted && _videoController != null) {
        _videoController!.setVolume(widget.isMuted ? 0.0 : 1.0);
      }
    }
  }

  void _updatePlaybackState() {
    if (_videoController != null && _isInitialized) {
      _videoController!.setVolume(widget.isMuted ? 0.0 : 1.0);
      if (widget.isPlaying) {
        _videoController!.play();
      } else {
        _videoController!.pause();
      }
    }
  }

  @override
  void dispose() {
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVideo) {
      return Image.network(
        widget.url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: Colors.grey[300],
          child: const Center(
            child: Icon(Icons.error_outline, color: Colors.grey),
          ),
        ),
      );
    }

    if (_videoController == null || !_isInitialized) {
      return Container(
        decoration: widget.posterUrl != null && widget.posterUrl!.isNotEmpty
            ? BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(widget.posterUrl!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                ),
              )
            : const BoxDecoration(color: Colors.black),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return SizedBox.expand(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: _videoController!.value.size.width,
          height: _videoController!.value.size.height,
          child: VideoPlayer(_videoController!),
        ),
      ),
    );
  }
}
