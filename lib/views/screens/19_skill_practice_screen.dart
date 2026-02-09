import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/skill_model.dart';
import '../../../utils/helpers.dart';

class SkillPracticeScreen extends StatefulWidget {
  const SkillPracticeScreen({super.key});

  @override
  State<SkillPracticeScreen> createState() => _SkillPracticeScreenState();
}

class _SkillPracticeScreenState extends State<SkillPracticeScreen> {
  late SkillModel skill;
  int currentStep = 0;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    skill = Get.arguments as SkillModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(skill.title),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (currentStep + 1) / skill.steps.length,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: isCompleted ? _buildCompletionView() : _buildStepView(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                if (currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      child: const Text('السابق'),
                    ),
                  ),
                if (currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: currentStep == skill.steps.length - 1 ? 'إنهاء' : 'التالي',
                    onPressed: _nextStep,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${currentStep + 1}',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Text(
          'الخطوة ${currentStep + 1} من ${skill.steps.length}',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          skill.steps[currentStep],
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Icon(
          Icons.self_improvement,
          size: 120,
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ],
    );
  }

  Widget _buildCompletionView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 120,
          color: Colors.green,
        ),
        const SizedBox(height: 32),
        const Text(
          'أحسنت!',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'لقد أكملت تمرين ${skill.title}',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),
        CustomButton(
          text: 'العودة للمهارات',
          onPressed: () => Get.back(),
          icon: Icons.arrow_back,
        ),
      ],
    );
  }

  void _nextStep() {
    if (currentStep < skill.steps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      setState(() {
        isCompleted = true;
      });
      Helpers.showSuccessSnackbar('تم إكمال التمرين بنجاح!');
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }
}