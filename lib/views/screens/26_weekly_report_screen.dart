import 'package:dbt_mental_health_app/views/widgets/chart_widget.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/reports_controller.dart';


class WeeklyReportScreen extends StatelessWidget {
  const WeeklyReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ReportsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقرير الأسبوعي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: controller.exportReport,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ملخص الأسبوع',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildSummaryRow('إجمالي التسجيلات', '${controller.weeklyMoods.length}'),
                  _buildSummaryRow('متوسط المزاج', controller.averageMood.toStringAsFixed(1)),
                  _buildSummaryRow('أفضل يوم', _getBestDay(controller)),
                  _buildSummaryRow('أسوأ يوم', _getWorstDay(controller)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'مخطط المزاج',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  if (controller.weeklyMoods.isNotEmpty)
                    MoodChartWidget(moods: controller.weeklyMoods)
                  else
                    const Center(
                      child: Text('لا توجد بيانات كافية'),
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
                    'الأنشطة',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildActivityRow(Icons.book, 'يوميات', '12 مدخل'),
                  _buildActivityRow(Icons.school, 'مهارات', '8 تمارين'),
                  _buildActivityRow(Icons.fitness_center, 'تمارين', '5 جلسات'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الملاحظات',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'أظهرت هذا الأسبوع تحسناً عاماً في المزاج. استمر في ممارسة مهارات DBT والعناية بنفسك.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, color: Colors.grey[700])),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(label, style: const TextStyle(fontSize: 16)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _getBestDay(ReportsController controller) {
    if (controller.weeklyMoods.isEmpty) return '-';
    final best = controller.weeklyMoods.reduce((a, b) => a.moodLevel > b.moodLevel ? a : b);
    return '${best.timestamp.day}/${best.timestamp.month}';
  }

  String _getWorstDay(ReportsController controller) {
    if (controller.weeklyMoods.isEmpty) return '-';
    final worst = controller.weeklyMoods.reduce((a, b) => a.moodLevel < b.moodLevel ? a : b);
    return '${worst.timestamp.day}/${worst.timestamp.month}';
  }
}