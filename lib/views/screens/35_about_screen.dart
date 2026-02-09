import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';
import '../../../config/app_config.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حول التطبيق'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              children: [
                Icon(
                  Icons.favorite,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(height: 16),
                Text(
                  AppConfig.appName,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'الإصدار ${AppConfig.appVersion}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 16),
                Text(
                  AppConfig.appDescription,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
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
                  'حول DBT',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'العلاج السلوكي الجدلي (Dialectical Behavior Therapy) هو نوع من العلاج المعرفي السلوكي طورته الدكتورة مارشا لينهان. يركز على تعليم المهارات في أربع مجالات رئيسية:',
                  style: TextStyle(height: 1.6),
                ),
                const SizedBox(height: 12),
                _buildDBTModule('اليقظة الذهنية', 'التركيز على اللحظة الحالية'),
                _buildDBTModule('تحمل الضيق', 'التعامل مع الأزمات'),
                _buildDBTModule('تنظيم العواطف', 'إدارة المشاعر الصعبة'),
                _buildDBTModule('الفعالية الشخصية', 'بناء علاقات صحية'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'التواصل',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.email),
                  title: const Text('support@dbtwellness.com'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.web),
                  title: const Text('www.dbtwellness.com'),
                  onTap: () {},
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
                  'قانوني',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ListTile(
                  title: const Text('سياسة الخصوصية'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('شروط الاستخدام'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text('التراخيص'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              '© 2024 DBT Wellness. جميع الحقوق محفوظة.',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDBTModule(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}