import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/profile_controller.dart';
import '../../../controllers/auth_controller.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).primaryColor,
                  child: const Icon(Icons.person, size: 50, color: Colors.white),
                ),
                const SizedBox(height: 16),
                Text(
                  controller.userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  controller.userEmail,
                  style: TextStyle(color: Colors.grey[600]),
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
                  'الإحصائيات',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox(
                      'المزاج',
                      controller.totalMoods.value.toString(),
                      Icons.mood,
                    ),
                    _buildStatBox(
                      'اليوميات',
                      controller.totalDiaryEntries.value.toString(),
                      Icons.book,
                    ),
                    _buildStatBox(
                      'الأهداف',
                      controller.completedGoals.value.toString(),
                      Icons.flag,
                    ),
                    _buildStatBox(
                      'الأيام',
                      controller.activeStreak.value.toString(),
                      Icons.local_fire_department,
                    ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            context,
            'تعديل الملف الشخصي',
            Icons.edit,
            () => Get.toNamed(RoutesConfig.editProfile),
          ),
          _buildMenuItem(
            context,
            'الإعدادات',
            Icons.settings,
            () => Get.toNamed(RoutesConfig.settings),
          ),
          _buildMenuItem(
            context,
            'الإشعارات',
            Icons.notifications,
            () => Get.toNamed(RoutesConfig.notifications),
          ),
          _buildMenuItem(
            context,
            'المظهر',
            Icons.palette,
            () => Get.toNamed(RoutesConfig.theme),
          ),
          _buildMenuItem(
            context,
            'حول التطبيق',
            Icons.info,
            () => Get.toNamed(RoutesConfig.about),
          ),
          const SizedBox(height: 16),
          CustomCard(
            onTap: () => authController.logout(),
            child: Row(
              children: [
                const Icon(Icons.logout, color: Colors.red),
                const SizedBox(width: 16),
                const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    return CustomCard(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}