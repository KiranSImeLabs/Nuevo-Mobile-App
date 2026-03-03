import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:async';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/app_theme.dart';
import '../../widgets/health/session_completed_sheet.dart';
import '../../../data/models/daily_exercise_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/health_provider.dart';
import '../../../data/models/active_progress_model.dart';

class GuidedSessionScreen extends ConsumerStatefulWidget {
  final List<ExerciseStepModel>? steps;
  final String sessionId;

  const GuidedSessionScreen({super.key, required this.sessionId, this.steps});

  @override
  ConsumerState<GuidedSessionScreen> createState() =>
      _GuidedSessionScreenState();
}

class _GuidedSessionScreenState extends ConsumerState<GuidedSessionScreen> {
  bool _isPlaying = false;
  bool _isSessionStarted = false;
  bool _isCompletingSession = false;
  int _currentStep = 0;
  late PageController _pageController;

  late final List<Map<String, dynamic>> _sessionSteps;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _checkActiveProgress();

    if (widget.steps != null && widget.steps!.isNotEmpty) {
      _sessionSteps = widget.steps!
          .map(
            (step) => {
              'title': step.title ?? 'Exercise Step',
              'instruction': step.description ?? '',
              'image': step.videoUrl ?? '',
              'isVideo': (step.videoUrl != null && step.videoUrl!.isNotEmpty),
              'duration': step.duration ?? 30,
            },
          )
          .toList();
    } else {
      _sessionSteps = [];
    }

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
          
          // Clamp index so it doesn't crash on invalid backend states
          int idx = progress.currentStepIndex ?? 0;
          if (idx < 0) idx = 0;
          if (idx >= _sessionSteps.length) idx = _sessionSteps.length - 1;
          
          _currentStep = idx;
        });

        // Jump to correct page
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_pageController.hasClients) {
            _pageController.jumpToPage(_currentStep);
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
    
    // Fire and forget progress update
    final data = {
      "currentStepIndex": _currentStep,
      "currentTimeInStep": 0, // Assuming 0 as we removed the timer
      "heartRate": 120 // Static for now as requested or placeholder
    };
    
    ref.read(syncSessionProgressProvider({
      'id': widget.sessionId,
      'data': data,
    }).future).catchError((e) {
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
    } else {
      // Toggle play/pause
      setState(() {
        _isPlaying = !_isPlaying;
      });

      // Sync progress when pausing
      if (!_isPlaying) {
        _syncProgress();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _sessionSteps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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
      await ref.read(completeSessionProvider(widget.sessionId).future);
      
      if (!mounted) return;
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => const SessionCompletedSheet(),
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
      body: Column(
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

          const SizedBox(height: 8),

          // Main Visual / PageView
          Expanded(
            flex: 4,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onStepChanged,
              itemCount: _sessionSteps.length,
              itemBuilder: (context, index) {
                final step = _sessionSteps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
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
                            borderRadius: BorderRadius.circular(24),
                            child: _StepMediaWidget(
                              url: step['image'],
                              isVideo: step['isVideo'] ?? false,
                              isPlaying: _isPlaying && index == _currentStep,
                            ),
                          ),
                        ),

                        // Gradient Overlay
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
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
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        // "Tap Play to Start" Overlay
                        if (!_isSessionStarted)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: Colors.black.withOpacity(0.4),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.play_arrow_rounded,
                                        color: Colors.white,
                                        size: 48,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      'Tap Play below to Start',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF1ED),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Vertical colored bar
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFA35940),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStepData['title'],
                          style: const TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 1,
                          color: const Color(0xFFE0D6D1).withOpacity(0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          currentStepData['instruction'],
                          style: const TextStyle(
                            color: Color(0xFF5D4037),
                            fontSize: 15,
                            height: 1.5,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          // Playback Controls
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous
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
                  size: 56,
                  iconColor: const Color(0xFF5D4037),
                  backgroundColor: const Color(0xFFFAF1ED),
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
                _buildCircleButton(
                  icon: Icons.skip_next_rounded,
                  onTap: () {
                    _syncProgress();
                    _nextStep();
                  },
                  size: 56,
                  iconColor: const Color(0xFF5D4037),
                  backgroundColor: const Color(0xFFFAF1ED),
                ),
              ],
            ),
          ),

          const Spacer(),

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
  final bool isVideo;
  final bool isPlaying;

  const _StepMediaWidget({
    Key? key,
    required this.url,
    required this.isVideo,
    required this.isPlaying,
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

  void _initMedia() {
    if (widget.isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _updatePlaybackState();
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
      _updatePlaybackState();
    }
  }

  void _updatePlaybackState() {
    if (_videoController != null && _isInitialized) {
      if (widget.isPlaying) {
        _videoController!.play();
      } else {
        _videoController!.pause();
      }
    }
  }

  @override
  void dispose() {
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
        color: Colors.black,
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
