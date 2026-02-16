import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';

class GuidedSessionScreen extends StatefulWidget {
  const GuidedSessionScreen({super.key});

  @override
  State<GuidedSessionScreen> createState() => _GuidedSessionScreenState();
}


class _GuidedSessionScreenState extends State<GuidedSessionScreen> {
  bool _isPlaying = true;
  int _currentStep = 0;
  late PageController _pageController;

  final List<Map<String, dynamic>> _sessionSteps = [
    {
      'title': 'Gently tilt right',
      'instruction': 'Keep your shoulders down and relaxed. Feel the stretch along the left side.',
      'image': 'https://images.unsplash.com/photo-1571019615243-308fb4344b80?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
      'duration': 45,
    },
    {
        'title': 'Gently tilt left',
        'instruction': 'Repeat on the other side. Breathe deeply.',
        'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
        'duration': 45,
    },
    {
        'title': 'Forward stretch',
        'instruction': 'Reach forward and hold. Keep your back straight.',
        'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80', // detailed image needed
        'duration': 60,
    },
    {
        'title': 'Shoulder rolls',
        'instruction': 'Roll your shoulders backwards in slow circles.',
        'image': 'https://images.unsplash.com/photo-1571019615243-308fb4344b80?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
        'duration': 30,
    },
    {
        'title': 'Deep breathing',
        'instruction': 'Inhale deeply through your nose, exhale slowly through your mouth.',
        'image': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1740&q=80',
        'duration': 30,
    },
  ];

  late int _remainingSeconds;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _remainingSeconds = _sessionSteps[0]['duration'];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepChanged(int index) {
    setState(() {
      _currentStep = index;
      _remainingSeconds = _sessionSteps[index]['duration'];
    });
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
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
                      image: DecorationImage(
                        image: NetworkImage(step['image']),
                        fit: BoxFit.cover,
                      ),
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
                        
                        // Timer Overlay
                        Positioned(
                          bottom: 32,
                          left: 0,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'TIME REMAINING',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '00:${(index == _currentStep ? _remainingSeconds : step['duration']).toString().padLeft(2, '0')}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 56,
                                  fontWeight: FontWeight.w300,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
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
                  icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  onTap: () {
                    setState(() {
                      _isPlaying = !_isPlaying;
                    });
                  },
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
                    if (_currentStep < _sessionSteps.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300), 
                        curve: Curves.easeInOut,
                      );
                    }
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
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 32.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFA35940)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFFFAF1ED),
                ),
                child: const Text(
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
                  )
                ]
              : [],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: size * 0.4,
        ),
      ),
    );
  }
}
