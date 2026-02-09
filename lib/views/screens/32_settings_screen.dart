import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/settings_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإعدادات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الصوت والاهتزاز',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Obx(() => SwitchListTile(
                  title: const Text('الصوت'),
                  value: controller.soundEnabled.value,
                  onChanged: controller.toggleSound,
                )),
                Obx(() => SwitchListTile(
                  title: const Text('الاهتزاز'),
                  value: controller.vibrationEnabled.value,
                  onChanged: controller.toggleVibration,
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اللغة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  title: const Text('العربية'),
                  trailing: const Icon(Icons.check, color: Colors.green),
                  onTap: () {},
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
                  'البيانات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: const Text('نسخ احتياطي'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('استعادة'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: const Text('حذف جميع البيانات', style: TextStyle(color: Colors.red)),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}