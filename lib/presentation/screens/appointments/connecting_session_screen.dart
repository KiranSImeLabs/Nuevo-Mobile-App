import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ConnectingSessionScreen extends StatefulWidget {
  const ConnectingSessionScreen({super.key});

  @override
  State<ConnectingSessionScreen> createState() => _ConnectingSessionScreenState();
}

class _ConnectingSessionScreenState extends State<ConnectingSessionScreen> with TickerProviderStateMixin {
  late AnimationController _rippleController;
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Simulating connection time
    )..forward();
  }

  @override
  void dispose() {
    _rippleController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Connecting',
          style: AppTextStyles.h3.copyWith(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
             icon: const Icon(Icons.close),
             onPressed: () => Navigator.of(context).pop(), // Or close logic
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            
            // Central Ripple Animation
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                 _buildRipple(200, 0.0),
                 _buildRipple(260, 0.4), // Staggered
                 _buildRipple(320, 0.8), // Staggered slightly more? Or use same controller with delay logic.
                 // Actually simpler: One controller, multiple AnimatedBuilders with different phases? 
                 // Let's use simpler explicit circles for now or a custom painter if needed. 
                 // Expanding circles opacity fade.
                 
                 // Let's try 3 constant rings in design, maybe they are static? 
                 // Design says "Calling..." implies movement.
                 // Implementation: 
                 // 3 Containers with large border radius.
                 
                // Avatar
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))
                    ],
                  ),
                   child: const Icon(Icons.person, size: 50, color: AppColors.primaryColor), // Placeholder
                ),
                
                // Calling status badge
                Positioned(
                  bottom: -12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(20),
                       boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
                       ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8, height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFFA65C4B), // Brown/Red dot
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Calling...',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            const Spacer(),
            
            // Bottom Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Container(
                height: 56,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EAE8), // Pinkish background of bar
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Stack(
                  children: [
                    // Progress Fill
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return FractionallySizedBox(
                          widthFactor: _progressController.value,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Color(0xFFE8D5D1), // Slightly darker fill? Or maybe mimicking design
                              // Design looks like the whole bar is pink, maybe distinct fill isn't obvious 
                              // OR the "Connecting..." text is the main thing.
                              // Let's assume a subtle fill or just the container.
                              // Actually screenshot shows "Connecting..." text in center, 
                              // and maybe a spinner icon? No, looks like just text.
                              // Wait, bottom of screenshot has a bar "Connecting...".
                              // It looks like a button that is disabled/loading.
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(30), right: Radius.circular(30)),
                            ),
                          ),
                        );
                      },
                    ),
                    
                    // Content
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Spinner or hourglass? Screenshot has hourglass icon.
                          const Icon(Icons.hourglass_empty, size: 20, color: Color(0xFF8D6E63)),
                          const SizedBox(width: 8),
                          Text(
                            'Connecting...',
                            style: AppTextStyles.button.copyWith(
                              color: const Color(0xFF8D6E63),
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRipple(double size, double delay) {
    return AnimatedBuilder(
      animation: _rippleController,
      builder: (context, child) {
        // Simple breathing or expanding effect
        final value = (_rippleController.value + delay) % 1.0;
        final scale = 1.0 + (value * 0.2); // Expand slightly?
        // Or actually opacity fade.
        
        // Let's try static circles first as per simple design interpretation then animate if needed.
        // Screenshot shows concentric circles. Usually they pulse.
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFFAE3E0).withOpacity(0.5 * (1 - value)), // Fade out
          ),
        );
      },
    );
  }
}
