import 'package:dbt_mental_health_app/config/app_config.dart';
import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/views/widgets/loading_widget.dart';
import 'package:dbt_mental_health_app/views/widgets/skill_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/skills_controller.dart';


class SkillsLibraryScreen extends StatelessWidget {
  const SkillsLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SkillsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('مكتبة مهارات DBT'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const LoadingWidget(message: 'جاري تحميل المهارات...');
        }

        return Column(
          children: [
            _buildCategoryTabs(context, controller),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredSkills.length,
                itemBuilder: (context, index) {
                  final skill = controller.filteredSkills[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: SkillCard(
                      skill: skill,
                      onTap: () => Get.toNamed(
                        RoutesConfig.skillDetail,
                        arguments: skill,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCategoryTabs(BuildContext context, SkillsController controller) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildCategoryChip(
            context,
            controller,
            'الكل',
            '',
          ),
          ...AppConfig.skillsCategories.map((category) {
            return _buildCategoryChip(
              context,
              controller,
              category,
              category,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(
    BuildContext context,
    SkillsController controller,
    String label,
    String value,
  ) {
    return Obx(() {
      final isSelected = controller.selectedCategory.value == value;
      
      return Padding(
        padding: const EdgeInsets.only(left: 8),
        child: FilterChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => controller.setCategory(value),
          backgroundColor: Colors.transparent,
          selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
          checkmarkColor: Theme.of(context).primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? Theme.of(context).primaryColor : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );
    });
  }
}