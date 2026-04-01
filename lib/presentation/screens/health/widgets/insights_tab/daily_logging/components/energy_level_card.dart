import 'package:flutter/material.dart';

class EnergyLevelCard extends StatelessWidget {
  final String currentEnergy;
  final Function(String) onEnergyChanged;

  const EnergyLevelCard({
    super.key,
    required this.currentEnergy,
    required this.onEnergyChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> energyLevels = ["Exhausted", "Low", "Balanced", "Good", "Radiant"];
    int currentIndex = energyLevels.indexOf(currentEnergy);
    if (currentIndex == -1) currentIndex = 2; // Default to 'Balanced'

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF42332D).withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF2EAE5), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFFFCF8F6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bolt_outlined, color: Color(0xFFA05E44), size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Energy Level",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF42332D),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "How do you feel today?",
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFA0A0A0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: const Color(0xFFFDFBFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF2EAE5), width: 1),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("EXHAUSTED",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: currentIndex <= 1
                                ? const Color(0xFFA05E44)
                                : const Color(0xFFAFA49F))),
                    Text("BALANCED",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: currentIndex == 2
                                ? const Color(0xFFA05E44)
                                : const Color(0xFFAFA49F))),
                    Text("RADIANT",
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: currentIndex >= 3
                                ? const Color(0xFFA05E44)
                                : const Color(0xFFAFA49F))),
                  ],
                ),
                const SizedBox(height: 16),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 4,
                    activeTrackColor: const Color(0xFFF2EAE5),
                    inactiveTrackColor: const Color(0xFFF2EAE5),
                    thumbColor: const Color(0xFFA05E44),
                    overlayColor: const Color(0xFFA05E44).withValues(alpha: 0.1),
                    tickMarkShape: SliderTickMarkShape.noTickMark,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10, elevation: 4),
                  ),
                  child: Slider(
                    value: currentIndex.toDouble(),
                    min: 0,
                    max: 4,
                    divisions: 4,
                    onChanged: (val) {
                      onEnergyChanged(energyLevels[val.toInt()]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      bool isSelected = index == currentIndex;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? 12 : 6,
                        height: isSelected ? 12 : 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? const Color(0xFFA05E44)
                              : const Color(0xFFDCCDC6),
                          border: isSelected
                              ? Border.all(color: Colors.white, width: 2)
                              : null,
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: const Color(0xFFA05E44).withValues(alpha: 0.2),
                                    spreadRadius: 2,
                                    blurRadius: 6,
                                  )
                                ]
                              : [],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
