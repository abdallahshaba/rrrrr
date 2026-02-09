import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:dbt_mental_health_app/views/widgets/mood_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../controllers/auth_controller.dart';
import '../../../config/routes_config.dart';
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
              _buildRecentDiaryEntries(context, homeController),
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
                    const SizedBox(height: 8),
                    Text(
                      AppConstants.moodLabels[controller.todayMood.value - 1],
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: () => _showMoodDialog(context, controller),
                      icon: const Icon(Icons.edit),
                      label: const Text('تحديث المزاج'),
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

    return CustomCard(
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
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: actions.map((action) {
              return InkWell(
                onTap: () => Get.toNamed(action['route'] as String),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
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
                    const SizedBox(height: 8),
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
    );
  }

  Widget _buildTodayStats(BuildContext context, HomeController controller) {
    return CustomCard(
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
                'متوسط المزاج',
                controller.averageMood.value > 0 
                    ? controller.averageMood.value.toStringAsFixed(1)
                    : '-',
                Icons.mood,
                Helpers.getMoodColor(controller.averageMood.value.toInt()),
              ),
              _buildStatBox(
                'اليوميات',
                controller.totalDiaryEntries.value.toString(),
                Icons.book,
                Colors.green,
              ),
              _buildStatBox(
                'الأهداف',
                '${controller.completedGoalsCount.value}/${controller.totalGoalsCount.value}',
                Icons.flag,
                Colors.orange,
              ),
            ],
          )),
          const SizedBox(height: 16),
          // Progress bar للأهداف
          Obx(() {
            if (controller.totalGoalsCount.value > 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'تقدم الأهداف',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '${controller.goalsCompletionPercentage.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: controller.goalsCompletionPercentage / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
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
          textAlign: TextAlign.center,
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
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.flag_outlined, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'لا توجد أهداف نشطة',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () => Get.toNamed(RoutesConfig.goals),
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة هدف'),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Column(
              children: controller.activeGoals.take(3).map((goal) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              goal.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Text(
                            '${goal.progress}%',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: goal.progress / 100,
                        backgroundColor: Colors.grey[200],
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRecentDiaryEntries(BuildContext context, HomeController controller) {
    return Obx(() {
      if (controller.recentDiaryEntries.isEmpty) {
        return const SizedBox.shrink();
      }

      return CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'آخر اليوميات',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.toNamed(RoutesConfig.diary),
                  child: const Text('عرض الكل'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...controller.recentDiaryEntries.map((entry) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.book, color: Colors.blue),
                title: Text(
                  entry.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  Helpers.formatDate(entry.createdAt),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Get.toNamed(
                  RoutesConfig.diaryDetail,
                  arguments: entry,
                ),
              );
            }),
          ],
        ),
      );
    });
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
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(Icons.mood, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 8),
                      Text(
                        'لم تسجل أي مزاج بعد',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
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
                          mood.moodLevel.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Helpers.formatDate(mood.timestamp),
                          style: const TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
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
    int selectedMood = controller.todayMood.value > 0 ? controller.todayMood.value : 5;
    final noteController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('كيف تشعر؟'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MoodSlider(
                initialValue: selectedMood,
                onChanged: (value) {
                  selectedMood = value;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'ملاحظة (اختياري)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.addMood(
                selectedMood,
                noteController.text.isEmpty ? null : noteController.text,
              );
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