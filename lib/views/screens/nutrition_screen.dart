import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/nutrition_controller.dart';
import '../../utils/helpers.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state_widget.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NutritionController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('التغذية'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.meals.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.restaurant,
            title: 'لا توجد وجبات',
            message: 'سجّل وجباتك لتتبع تغذيتك',
            buttonText: 'إضافة وجبة',
            onButtonPressed: () => _showAddMealDialog(context, controller),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.meals.length,
          itemBuilder: (context, index) {
            final meal = controller.meals[index];
            return CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_getMealIcon(meal.mealType), size: 32, color: Colors.orange),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              meal.mealType,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              Helpers.formatDateTime(meal.timestamp),
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(meal.description),
                  if (meal.moodBefore != null || meal.moodAfter != null) ...[
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (meal.moodBefore != null)
                          Column(
                            children: [
                              const Text('قبل', style: TextStyle(fontSize: 12)),
                              Text('${meal.moodBefore}/10', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        if (meal.moodAfter != null)
                          Column(
                            children: [
                              const Text('بعد', style: TextStyle(fontSize: 12)),
                              Text('${meal.moodAfter}/10', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealDialog(context, controller),
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType) {
      case 'إفطار':
        return Icons.free_breakfast;
      case 'غداء':
        return Icons.lunch_dining;
      case 'عشاء':
        return Icons.dinner_dining;
      default:
        return Icons.restaurant;
    }
  }

  void _showAddMealDialog(BuildContext context, NutritionController controller) {
    final descController = TextEditingController();
    String mealType = 'إفطار';

    Get.dialog(
      AlertDialog(
        title: const Text('إضافة وجبة'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: mealType,
                decoration: const InputDecoration(labelText: 'نوع الوجبة'),
                items: ['إفطار', 'غداء', 'عشاء', 'وجبة خفيفة'].map((type) {
                  return DropdownMenuItem(value: type, child: Text(type));
                }).toList(),
                onChanged: (value) {
                  mealType = value!;
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'الوصف'),
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
              if (descController.text.isNotEmpty) {
                await controller.addMeal(
                  mealType: mealType,
                  description: descController.text,
                );
                Get.back();
                Helpers.showSuccessSnackbar('تم إضافة الوجبة');
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}