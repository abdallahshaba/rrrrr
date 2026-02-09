import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/views/widgets/skill_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/skills_controller.dart';


class InterpersonalScreen extends StatelessWidget {
  const InterpersonalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SkillsController>();
    final skills = controller.getSkillsByCategory('الفعالية الشخصية');

    return Scaffold(
      appBar: AppBar(
        title: const Text('الفعالية الشخصية'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: skills.length,
        itemBuilder: (context, index) {
          final skill = skills[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: SkillCard(
              skill: skill,
              onTap: () => Get.toNamed(RoutesConfig.skillDetail, arguments: skill),
            ),
          );
        },
      ),
    );
  }
}