import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/goals_controller.dart';
import '../../utils/helpers.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state_widget.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GoalsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('أهدافي'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.goals.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.flag,
            title: 'لا توجد أهداف',
            message: 'ابدأ بإضافة أول هدف لك',
            buttonText: 'إضافة هدف',
            onButtonPressed: () => _showAddGoalDialog(context, controller),
          );
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (controller.getActiveGoals().isNotEmpty) ...[
              const Text(
                'الأهداف النشطة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...controller.getActiveGoals().map((goal) => CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            goal.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () => _showGoalOptions(context, controller, goal),
                        ),
                      ],
                    ),
                    if (goal.description != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        goal.description!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value: goal.progress / 100,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${goal.progress}%'),
                        Text(
                          'الموعد: ${Helpers.formatDate(goal.targetDate)}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 24),
            ],
            if (controller.getCompletedGoals().isNotEmpty) ...[
              const Text(
                'الأهداف المكتملة',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...controller.getCompletedGoals().map((goal) => CustomCard(
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            goal.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'أُكمل في ${Helpers.formatDate(goal.completedAt!)}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, GoalsController controller) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String category = 'شخصي';
    DateTime targetDate = DateTime.now().add(const Duration(days: 30));

    Get.dialog(
      AlertDialog(
        title: const Text('هدف جديد'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'العنوان'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'الوصف (اختياري)'),
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
              if (titleController.text.isNotEmpty) {
                await controller.addGoal(
                  title: titleController.text,
                  description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  category: category,
                  targetDate: targetDate,
                );
                Get.back();
                Helpers.showSuccessSnackbar('تم إضافة الهدف');
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showGoalOptions(BuildContext context, GoalsController controller, goal) {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.check),
              title: const Text('تحديث التقدم'),
              onTap: () {
                Get.back();
                _showProgressDialog(context, controller, goal);
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle, color: Colors.green),
              title: const Text('تعليم كمكتمل'),
              onTap: () async {
                Get.back();
                await controller.completeGoal(goal.id!);
                Helpers.showSuccessSnackbar('تم إكمال الهدف!');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف', style: TextStyle(color: Colors.red)),
              onTap: () async {
                Get.back();
                final confirm = await Helpers.showConfirmDialog(
                  title: 'تأكيد الحذف',
                  message: 'هل أنت متأكد من حذف هذا الهدف؟',
                );
                if (confirm) {
                  await controller.deleteGoal(goal.id!);
                  Helpers.showSuccessSnackbar('تم حذف الهدف');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showProgressDialog(BuildContext context, GoalsController controller, goal) {
    int progress = goal.progress;

    Get.dialog(
      AlertDialog(
        title: const Text('تحديث التقدم'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('${progress}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                Slider(
                  value: progress.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 20,
                  label: '$progress%',
                  onChanged: (value) {
                    setState(() {
                      progress = value.toInt();
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.updateGoalProgress(goal.id!, progress);
              Get.back();
              Helpers.showSuccessSnackbar('تم تحديث التقدم');
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}