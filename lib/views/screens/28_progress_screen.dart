import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/goals_controller.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GoalsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقدم والإنجازات'),
      ),
      body: Obx(() => ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الأهداف المكتملة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (controller.getCompletedGoals().isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('لم تكمل أي أهداف بعد'),
                    ),
                  )
                else
                  ...controller.getCompletedGoals().map((goal) => ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(goal.title),
                    subtitle: Text('أُكمل في ${goal.completedAt?.day}/${goal.completedAt?.month}'),
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
                  'الأهداف الجارية',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (controller.getActiveGoals().isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('لا توجد أهداف نشطة'),
                    ),
                  )
                else
                  ...controller.getActiveGoals().map((goal) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
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
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: goal.progress / 100,
                        ),
                        const SizedBox(height: 4),
                        Text('${goal.progress}%'),
                      ],
                    ),
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
                  'الإحصائيات',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox(
                      'الإجمالي',
                      controller.goals.length.toString(),
                      Colors.blue,
                    ),
                    _buildStatBox(
                      'مكتمل',
                      controller.getCompletedGoals().length.toString(),
                      Colors.green,
                    ),
                    _buildStatBox(
                      'نشط',
                      controller.getActiveGoals().length.toString(),
                      Colors.orange,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildStatBox(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }
}