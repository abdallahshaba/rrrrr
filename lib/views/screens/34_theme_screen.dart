import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/theme_controller.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('المظهر'),
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اختر المظهر',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                RadioListTile<ThemeMode>(
                  title: const Text('فاتح'),
                  value: ThemeMode.light,
                  groupValue: controller.themeMode.value,
                  onChanged: (value) {
                    if (value != null) controller.setThemeMode(value);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('داكن'),
                  value: ThemeMode.dark,
                  groupValue: controller.themeMode.value,
                  onChanged: (value) {
                    if (value != null) controller.setThemeMode(value);
                  },
                ),
                RadioListTile<ThemeMode>(
                  title: const Text('تلقائي (حسب النظام)'),
                  value: ThemeMode.system,
                  groupValue: controller.themeMode.value,
                  onChanged: (value) {
                    if (value != null) controller.setThemeMode(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'معاينة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'DBT Wellness',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'رحلتك نحو الصحة النفسية',
                        style: TextStyle(color: Colors.white.withOpacity(0.9)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}