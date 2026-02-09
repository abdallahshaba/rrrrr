import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:dbt_mental_health_app/views/widgets/mood_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../utils/constants.dart';
import '../../../utils/helpers.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('مرحباً، ${authController.currentUser.value?.name ?? "المستخدم"}')),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Get.toNamed(RoutesConfig.notifications),
          ),
        ],
      ),
      body: Obx(() {
        if (homeController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: homeController.loadData,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildQuickMoodCard(context, homeController),
              const SizedBox(height: 16),
              _buildQuickActions(context),
              const SizedBox(height: 16),
              _buildTodayStats(context, homeController),
              const SizedBox(height: 16),
              _buildActiveGoals(context, homeController),
              const SizedBox(height: 16),
              _buildRecentMoods(context, homeController),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQuickMoodCard(BuildContext context, HomeController controller) {
    return CustomCard(
      child: Column(
        children: [
          const Text(
            'كيف تشعر اليوم؟',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => controller.todayMood.value > 0
              ? Column(
                  children: [
                    Text(
                      AppConstants.moodEmojis[controller.todayMood.value - 1],
                      style: const TextStyle(fontSize: 64),
                    ),
                    Text(
                      AppConstants.moodLabels[controller.todayMood.value - 1],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                )
              : ElevatedButton.icon(
                  onPressed: () => _showMoodDialog(context, controller),
                  icon: const Icon(Icons.add),
                  label: const Text('سجّل مزاجك'),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.psychology, 'label': 'مساعد AI', 'route': RoutesConfig.aiAssistant, 'color': Colors.purple},
      {'icon': Icons.warning, 'label': 'SOS', 'route': RoutesConfig.sos, 'color': Colors.red},
      {'icon': Icons.medication, 'label': 'الأدوية', 'route': RoutesConfig.medication, 'color': Colors.blue},
      {'icon': Icons.flag, 'label': 'الأهداف', 'route': RoutesConfig.goals, 'color': Colors.green},
    ];

    return SizedBox(
      height: 170,
      child: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إجراءات سريعة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: actions.map((action) {
                return InkWell(
                  onTap: () => Get.toNamed(action['route'] as String),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (action['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          action['icon'] as IconData,
                          color: action['color'] as Color,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        action['label'] as String,
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats(BuildContext context, HomeController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'إحصائيات اليوم',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.mood, 'المزاج', controller.todayMood.value.toString()),
              _buildStatItem(Icons.book, 'اليوميات', '2'),
              _buildStatItem(Icons.check, 'المهارات', '3'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.blue),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildActiveGoals(BuildContext context, HomeController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الأهداف النشطة',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(RoutesConfig.goals),
                child: const Text('عرض الكل'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            if (controller.activeGoals.isEmpty) {
              return const Text('لا توجد أهداف نشطة');
            }

            return Column(
              children: controller.activeGoals.take(3).map((goal) {
                return ListTile(
                  leading: const Icon(Icons.flag),
                  title: Text(goal.title),
                  subtitle: LinearProgressIndicator(
                    value: goal.progress / 100,
                  ),
                  trailing: Text('${goal.progress}%'),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentMoods(BuildContext context, HomeController controller) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'مزاجك الأخير',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed(RoutesConfig.moodChart),
                child: const Text('عرض المخطط'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.recentMoods.isEmpty) {
              return const Text('لم تسجل أي مزاج بعد');
            }

            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.recentMoods.length,
                itemBuilder: (context, index) {
                  final mood = controller.recentMoods[index];
                  return Container(
                    width: 80,
                    margin: const EdgeInsets.only(left: 8),
                    child: Column(
                      children: [
                        Text(
                          AppConstants.moodEmojis[mood.moodLevel - 1],
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Helpers.formatDate(mood.timestamp),
                          style: const TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showMoodDialog(BuildContext context, HomeController controller) {
    int selectedMood = 5;

    Get.dialog(
      AlertDialog(
        title: const Text('كيف تشعر؟'),
        content: MoodSlider(
          initialValue: selectedMood,
          onChanged: (value) {
            selectedMood = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.addMood(selectedMood, null);
              Get.back();
              Helpers.showSuccessSnackbar('تم تسجيل مزاجك');
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}