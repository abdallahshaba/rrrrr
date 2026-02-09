import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class GroundingExerciseScreen extends StatefulWidget {
  const GroundingExerciseScreen({super.key});

  @override
  State<GroundingExerciseScreen> createState() => _GroundingExerciseScreenState();
}

class _GroundingExerciseScreenState extends State<GroundingExerciseScreen> {
  int currentStep = 0;
  bool isCompleted = false;

  final List<Map<String, dynamic>> steps = [
    {
      'number': 5,
      'sense': 'أشياء يمكنك رؤيتها',
      'icon': Icons.visibility,
      'color': Colors.blue,
    },
    {
      'number': 4,
      'sense': 'أشياء يمكنك لمسها',
      'icon': Icons.touch_app,
      'color': Colors.purple,
    },
    {
      'number': 3,
      'sense': 'أشياء يمكنك سماعها',
      'icon': Icons.hearing,
      'color': Colors.green,
    },
    {
      'number': 2,
      'sense': 'أشياء يمكنك شمّها',
      'icon': Icons.air,
      'color': Colors.orange,
    },
    {
      'number': 1,
      'sense': 'شيء يمكنك تذوقه',
      'icon': Icons.restaurant,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تمرين التأريض 5-4-3-2-1'),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: isCompleted ? 1.0 : (currentStep + 1) / steps.length,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: isCompleted ? _buildCompletionView() : _buildStepView(),
            ),
          ),
          if (!isCompleted)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  if (currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            currentStep--;
                          });
                        },
                        child: const Text('السابق'),
                      ),
                    ),
                  if (currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: currentStep == steps.length - 1 ? 'إنهاء' : 'التالي',
                      onPressed: () {
                        if (currentStep < steps.length - 1) {
                          setState(() {
                            currentStep++;
                          });
                        } else {
                          setState(() {
                            isCompleted = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStepView() {
    final step = steps[currentStep];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: (step['color'] as Color).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            step['icon'] as IconData,
            size: 80,
            color: step['color'] as Color,
          ),
        ),
        const SizedBox(height: 48),
        Text(
          'حدد ${step['number']}',
          style: TextStyle(
            fontSize: 24,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          step['sense'] as String,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'خذ وقتك في تحديد كل شيء ببطء وعناية. ركز على التفاصيل.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.check_circle,
          size: 120,
          color: Colors.green,
        ),
        const SizedBox(height: 32),
        const Text(
          'رائع!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'لقد أكملت تمرين التأريض\nهل تشعر بتحسن؟',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        CustomButton(
          text: 'إعادة التمرين',
          onPressed: () {
            setState(() {
              currentStep = 0;
              isCompleted = false;
            });
          },
          icon: Icons.refresh,
        ),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('العودة'),
        ),
      ],
    );
  }
}