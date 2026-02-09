import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class MoodSlider extends StatefulWidget {
  final int initialValue;
  final ValueChanged<int> onChanged;

  const MoodSlider({
    super.key,
    this.initialValue = 5,
    required this.onChanged,
  });

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppConstants.moodEmojis[_value - 1],
          style: const TextStyle(fontSize: 64),
        ),
        const SizedBox(height: 8),
        Text(
          AppConstants.moodLabels[_value - 1],
          style: const TextStyle(
            fontSize: AppConstants.fontLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Slider(
          value: _value.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: _value.toString(),
          onChanged: (value) {
            setState(() {
              _value = value.toInt();
            });
            widget.onChanged(_value);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('1', style: TextStyle(color: Colors.grey[600])),
              Text('10', style: TextStyle(color: Colors.grey[600])),
            ],
          ),
        ),
      ],
    );
  }
}