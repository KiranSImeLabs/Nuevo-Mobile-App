import 'package:flutter/material.dart';

class SessionPausedSheet extends StatefulWidget {
  final String timeString;
  final int heartRate;
  final VoidCallback onResume;
  final VoidCallback onEnd;

  const SessionPausedSheet({
    super.key,
    required this.timeString,
    required this.heartRate,
    required this.onResume,
    required this.onEnd,
  });

  @override
  State<SessionPausedSheet> createState() => _SessionPausedSheetState();
}

class _SessionPausedSheetState extends State<SessionPausedSheet> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;
    
    return Container(
      height: size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.only(top: isSmallScreen ? 16.0 : 24.0, left: 16.0, right: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF5D4037)),
                  onPressed: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Text(
                    'Paused',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5D4037),
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Balance for centering
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: isSmallScreen ? 8.0 : 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),
                  
                  // Animated Giant Pause Icon
                  AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return SizedBox(
                        width: isSmallScreen ? 140 : 180,
                        height: isSmallScreen ? 140 : 180,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Outer pulsing ring
                            Transform.scale(
                              scale: _scaleAnimation.value,
                              child: Container(
                                width: isSmallScreen ? 140 : 180,
                                height: isSmallScreen ? 140 : 180,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFA05E44).withOpacity(0.1),
                                ),
                              ),
                            ),
                            // Inner pulsing ring
                            Transform.scale(
                              scale: 1.0 + (_scaleAnimation.value - 1.0) * 0.6,
                              child: Container(
                                width: isSmallScreen ? 110 : 140,
                                height: isSmallScreen ? 110 : 140,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xFFA05E44).withOpacity(0.2),
                                ),
                              ),
                            ),
                            // Core circle
                            Container(
                              width: isSmallScreen ? 80 : 100,
                              height: isSmallScreen ? 80 : 100,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFA05E44),
                              ),
                              child: Icon(
                                Icons.pause_rounded,
                                color: Colors.white,
                                size: isSmallScreen ? 36 : 48,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  const Spacer(flex: 3),
                  
                  // Text
                  const Text(
                    'Session Paused',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF2B1B18),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Take a breath. Resume when ready.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF757575),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  
                  const Spacer(flex: 3),
                  
                  // Stats Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 16.0 : 24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9F1F0),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Time',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.timeString,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 22 : 26,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2B1B18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 48,
                          width: 1,
                          color: const Color(0xFFE0D6D1),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              const Text(
                                'Heart Rate',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                widget.heartRate.toString(),
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 22 : 26,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2B1B18),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(flex: 2), // Padding before end
                ],
              ),
            ),
          ),
          
          // Action Buttons Bottom anchored
          Padding(
            padding: EdgeInsets.fromLTRB(24.0, 0, 24.0, isSmallScreen ? 24.0 : 32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: widget.onResume,
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
                          'Resume Session',
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
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: widget.onEnd,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFA05E44), width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.white, // Setting to clear white for better contrast
                    ),
                    child: const Text(
                      'End Session',
                      style: TextStyle(
                        color: Color(0xFFA05E44),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
