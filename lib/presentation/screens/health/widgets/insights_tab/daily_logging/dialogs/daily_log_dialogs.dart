import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DailyLogDialogs {
  static void showHrMmDialog({
    required BuildContext context,
    required String title,
    required String currentValue,
    required Function(String) onSave,
  }) {
    final parts = currentValue.split(':');
    int initialHours = parts.isNotEmpty ? int.tryParse(parts[0]) ?? 0 : 0;
    int initialMinutes = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;

    int selectedHours = initialHours;
    int selectedMinutes = initialMinutes;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF42332D),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          onSave('${selectedHours.toString()}:${selectedMinutes.toString().padLeft(2, '0')}');
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Ok',
                          style: TextStyle(
                            color: Color(0xFFA05E44),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SizedBox(
                  height: 200,
                  child: CupertinoTimerPicker(
                    mode: CupertinoTimerPickerMode.hm,
                    initialTimerDuration: Duration(
                      hours: initialHours,
                      minutes: initialMinutes,
                    ),
                    onTimerDurationChanged: (Duration newDuration) {
                      selectedHours = newDuration.inHours;
                      selectedMinutes = newDuration.inMinutes % 60;
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static void showNumberDialog({
    required BuildContext context,
    required String title,
    required String currentValue,
    required String suffix,
    bool isDecimal = false,
    required Function(String) onSave,
  }) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Update $title',
            style: const TextStyle(color: Color(0xFF42332D)),
          ),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
            decoration: InputDecoration(
              suffixText: suffix,
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFA05E44)),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA05E44),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  static void showStressLevelDialog({
    required BuildContext context,
    required String title,
    required String currentValue,
    required Function(String) onSave,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF42332D),
                        ),
                      ),
                      const SizedBox(width: 60), // Space for balance
                    ],
                  ),
                ),
                const Divider(height: 1),
                _buildStressListOption(context, "Normal", currentValue, onSave),
                _buildStressListOption(context, "Medium", currentValue, onSave),
                _buildStressListOption(context, "High", currentValue, onSave),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildStressListOption(
      BuildContext context, String level, String currentValue, Function(String) onSave) {
    final isSelected = level == currentValue;
    return InkWell(
      onTap: () {
        onSave(level);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        width: double.infinity,
        color: isSelected ? const Color(0xFFFCF8F6) : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              level,
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? const Color(0xFFA05E44) : const Color(0xFF42332D),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isSelected)
              const Icon(Icons.check, color: Color(0xFFA05E44)),
          ],
        ),
      ),
    );
  }
}
