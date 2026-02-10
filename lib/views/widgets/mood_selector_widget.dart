import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MoodSelectorWidget extends StatelessWidget {
  final int selectedMood; // 1-10
  final Function(int) onMoodSelected;

  const MoodSelectorWidget({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(AppConstants.moodEmojis.length, (index) {
        final moodLevel = index + 1;
        final isSelected = selectedMood == moodLevel;
        
        return GestureDetector(
          onTap: () => onMoodSelected(moodLevel),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? Colors.blue[50] : Colors.transparent,
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.transparent,
                width: 2.5,
              ),
            ),
            child: Center(
              child: Text(
                AppConstants.moodEmojis[index],
                style: TextStyle(
                  fontSize: 32,
                  color: isSelected ? Colors.blue : Colors.grey[600],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}