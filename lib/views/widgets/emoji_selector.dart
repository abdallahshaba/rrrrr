import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class EmojiSelector extends StatelessWidget {
  final int selectedMood;
  final ValueChanged<int> onMoodSelected;

  const EmojiSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(10, (index) {
        final mood = index + 1;
        final isSelected = mood == selectedMood;
        
        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
              border: Border.all(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                AppConstants.moodEmojis[index],
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
        );
      }),
    );
  }
}