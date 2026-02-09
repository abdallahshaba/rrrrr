import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../config/app_config.dart';

class SOSScreen extends StatelessWidget {
  const SOSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مركز الطوارئ'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red, width: 2),
            ),
            child: Column(
              children: [
                const Icon(Icons.warning, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'إذا كنت في خطر فوري',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'اتصل بخدمات الطوارئ فوراً',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone),
                  label: Text('اتصل ${AppConfig.emergencyHotline}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'تقنيات سريعة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildQuickTechniqueCard(
            context,
            'تمارين التنفس',
            'تهدئة سريعة من خلال التنفس العميق',
            Icons.air,
            Colors.blue,
            RoutesConfig.breathingExercise,
          ),
          const SizedBox(height: 12),
          _buildQuickTechniqueCard(
            context,
            'تمارين التأريض',
            'تقنية 5-4-3-2-1 للعودة للحظة الحالية',
            Icons.nature,
            Colors.green,
            RoutesConfig.groundingExercise,
          ),
          const SizedBox(height: 12),
          _buildQuickTechniqueCard(
            context,
            'مهارات TIPP',
            'تقنيات للتعامل مع الأزمات الحادة',
            Icons.flash_on,
            Colors.orange,
            RoutesConfig.tippSkills,
          ),
          const SizedBox(height: 12),
          _buildQuickTechniqueCard(
            context,
            'دليل الأزمات',
            'خطة شاملة لإدارة الأزمات',
            Icons.book,
            Colors.purple,
            RoutesConfig.crisisGuide,
          ),
          const SizedBox(height: 24),
          const Text(
            'خطوط المساعدة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildHelplineCard(
            'الخط الساخن للانتحار',
            AppConfig.emergencyHotline,
            'متاح 24/7',
          ),
          const SizedBox(height: 12),
          _buildHelplineCard(
            'خط نصوص الأزمات',
            'أرسل HOME إلى ${AppConfig.crisisTextLine}',
            'متاح 24/7',
          ),
        ],
      ),
    );
  }

  Widget _buildQuickTechniqueCard(
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
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
    );
  }

  Widget _buildHelplineCard(String title, String number, String availability) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.phone, size: 20),
              const SizedBox(width: 8),
              Text(
                number,
                style: const TextStyle(fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            availability,
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}