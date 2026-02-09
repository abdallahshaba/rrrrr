import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class CrisisGuideScreen extends StatelessWidget {
  const CrisisGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دليل إدارة الأزمات'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '1. التعرف على الأزمة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'الأزمة هي حالة شعور بالضيق الشديد حيث تكون مهارات التأقلم العادية غير كافية.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '2. علامات التحذير',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildWarningSign('أفكار انتحارية أو إيذاء النفس'),
                _buildWarningSign('قلق أو خوف شديد'),
                _buildWarningSign('عدم القدرة على العمل أو التفكير بوضوح'),
                _buildWarningSign('تغيرات مفاجئة في السلوك'),
                _buildWarningSign('انسحاب من الآخرين'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '3. خطوات فورية',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildStep('1', 'توقف - خذ نفساً عميقاً'),
                _buildStep('2', 'قيّم مستوى الخطر الفوري'),
                _buildStep('3', 'استخدم مهارات TIPP'),
                _buildStep('4', 'اتصل بشخص من شبكة الدعم'),
                _buildStep('5', 'اطلب مساعدة مهنية إذا لزم الأمر'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '4. مهارات البقاء',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  '• استخدم تقنيات الإلهاء\n'
                  '• مارس تمارين التأريض\n'
                  '• ابتعد عن الأماكن أو الأشخاص الخطرين\n'
                  '• اطلب الدعم الفوري\n'
                  '• تذكر أن الأزمة مؤقتة',
                  style: TextStyle(fontSize: 16, height: 1.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '5. بعد الأزمة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  '• راجع ما حدث\n'
                  '• حدد المحفزات\n'
                  '• حدّث خطة الأزمة\n'
                  '• اعتنِ بنفسك\n'
                  '• تابع مع المعالج',
                  style: TextStyle(fontSize: 16, height: 1.8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarningSign(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.orange, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: const TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}