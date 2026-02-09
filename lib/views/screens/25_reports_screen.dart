import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/reports_controller.dart';


class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والتحليلات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'نظرة عامة',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatBox(
                      'متوسط المزاج',
                      controller.averageMood.toStringAsFixed(1),
                      Icons.mood,
                      Colors.blue,
                    ),
                    _buildStatBox(
                      'اليوميات',
                      '23',
                      Icons.book,
                      Colors.green,
                    ),
                    _buildStatBox(
                      'الأهداف',
                      '7/10',
                      Icons.flag,
                      Colors.orange,
                    ),
                  ],
                )),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildReportCard(
            context,
            'تقرير أسبوعي',
            'مراجعة نشاطك خلال الأسبوع الماضي',
            Icons.calendar_view_week,
            Colors.purple,
            RoutesConfig.weeklyReport,
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'مخطط المزاج',
            'تصور تقلبات مزاجك بمرور الوقت',
            Icons.show_chart,
            Colors.blue,
            RoutesConfig.moodChart,
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'التقدم والإنجازات',
            'تتبع تقدمك نحو أهدافك',
            Icons.trending_up,
            Colors.green,
            RoutesConfig.progress,
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            context,
            'تصدير PDF',
            'احفظ تقاريرك بصيغة PDF',
            Icons.picture_as_pdf,
            Colors.red,
            RoutesConfig.exportPdf,
          ),
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
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildReportCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
    String route,
  ) {
    return CustomCard(
      onTap: () => Get.toNamed(route),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }
}