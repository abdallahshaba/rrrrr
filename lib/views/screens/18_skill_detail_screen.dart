import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/skill_model.dart';
import '../../../utils/constants.dart';

class SkillDetailScreen extends StatelessWidget {
  const SkillDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final skill = Get.arguments as SkillModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(skill.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    AppConstants.skillIcons[skill.category] ?? Icons.stars,
                    size: 80,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    skill.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      skill.category,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'الوصف',
                    skill.description,
                    Icons.description,
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    'التفاصيل',
                    skill.content,
                    Icons.article,
                  ),
                  const SizedBox(height: 24),
                  _buildStepsSection(skill.steps),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'ابدأ التمرين',
                    onPressed: () => Get.toNamed(
                      RoutesConfig.skillPractice,
                      arguments: skill,
                    ),
                    icon: Icons.play_arrow,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 16,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildStepsSection(List<String> steps) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.list, size: 24),
            SizedBox(width: 8),
            Text(
              'الخطوات',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...steps.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      entry.value,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}