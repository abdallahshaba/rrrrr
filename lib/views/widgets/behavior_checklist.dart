import 'package:flutter/material.dart';

class BehaviorChecklistWidget extends StatefulWidget {
  final List<String> behaviors;
  final ValueChanged<Map<String, bool>> onChanged;

  const BehaviorChecklistWidget({
    super.key,
    required this.behaviors,
    required this.onChanged,
  });

  @override
  State<BehaviorChecklistWidget> createState() => _BehaviorChecklistWidgetState();
}

class _BehaviorChecklistWidgetState extends State<BehaviorChecklistWidget> {
  late Map<String, bool> _checkedBehaviors;

  @override
  void initState() {
    super.initState();
    _checkedBehaviors = {for (var b in widget.behaviors) b: false};
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.behaviors.map((behavior) {
        return CheckboxListTile(
          title: Text(behavior),
          value: _checkedBehaviors[behavior],
          onChanged: (value) {
            setState(() {
              _checkedBehaviors[behavior] = value ?? false;
            });
            widget.onChanged(_checkedBehaviors);
          },
        );
      }).toList(),
    );
  }
}