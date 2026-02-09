import 'package:dbt_mental_health_app/views/widgets/chart_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/reports_controller.dart';

class MoodChartScreen extends StatelessWidget {
  const MoodChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('مخطط المزاج'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'آخر 7 أيام',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      if (controller.weeklyMoods.isNotEmpty)
                        MoodChartWidget(moods: controller.weeklyMoods)
                      else
                        const Center(
                          child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('لا توجد بيانات للعرض'),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'الإحصائيات',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      _buildStatRow('المتوسط', controller.averageMood.toStringAsFixed(1)),
                      _buildStatRow('الأعلى', _getHighest(controller)),
                      _buildStatRow('الأدنى', _getLowest(controller)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getHighest(ReportsController controller) {
    if (controller.weeklyMoods.isEmpty) return '-';
    return controller.weeklyMoods.map((m) => m.moodLevel).reduce((a, b) => a > b ? a : b).toString();
  }

  String _getLowest(ReportsController controller) {
    if (controller.weeklyMoods.isEmpty) return '-';
    return controller.weeklyMoods.map((m) => m.moodLevel).reduce((a, b) => a < b ? a : b).toString();
  }
}