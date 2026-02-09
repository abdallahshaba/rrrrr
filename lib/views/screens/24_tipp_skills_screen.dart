import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:flutter/material.dart';

class TippSkillsScreen extends StatelessWidget {
  const TippSkillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مهارات TIPP'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                const Icon(Icons.info, color: Colors.blue, size: 32),
                const SizedBox(height: 8),
                Text(
                  'TIPP هي مهارات سريعة لتقليل الإثارة العاطفية الشديدة',
                  style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildTippCard(
            'T - Temperature (درجة الحرارة)',
            'غيّر درجة حرارة جسمك',
            [
              'ضع وجهك في ماء بارد لمدة 30 ثانية',
              'امسك مكعبات ثلج في يديك',
              'خذ دش بارد',
              'يساعد هذا على تنشيط رد فعل الغوص',
            ],
            Icons.ac_unit,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildTippCard(
            'I - Intense Exercise (تمرين مكثف)',
            'قم بتمرين قوي لمدة قصيرة',
            [
              'اركض في المكان لمدة دقيقة',
              'اصعد السلالم صعوداً ونزولاً',
              'اعمل تمارين الضغط أو القرفصاء',
              'يساعد على حرق الأدرينالين الزائد',
            ],
            Icons.directions_run,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildTippCard(
            'P - Paced Breathing (تنفس متناسق)',
            'تنفس ببطء وعمق',
            [
              'استنشق لمدة 4 ثواني',
              'احبس النفس لمدة 4 ثواني',
              'ازفر لمدة 6 ثواني',
              'كرر لعدة دقائق',
            ],
            Icons.air,
            Colors.green,
          ),
          const SizedBox(height: 16),
          _buildTippCard(
            'P - Paired Muscle Relaxation (استرخاء العضلات)',
            'شد ثم استرخِ عضلاتك',
            [
              'شد مجموعة عضلية لمدة 5 ثواني',
              'ثم استرخِ تماماً',
              'لاحظ الفرق بين التوتر والاسترخاء',
              'انتقل عبر مجموعات العضلات المختلفة',
            ],
            Icons.self_improvement,
            Colors.purple,
          ),
          const SizedBox(height: 24),
          CustomCard(
            color: Colors.amber.shade50,
            child: Column(
              children: [
                const Icon(Icons.lightbulb, color: Colors.amber, size: 32),
                const SizedBox(height: 8),
                const Text(
                  'نصيحة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'استخدم مهارات TIPP عندما تكون عواطفك شديدة جداً لاستخدام مهارات أخرى',
                  style: TextStyle(color: Colors.grey[800]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTippCard(
    String title,
    String description,
    List<String> steps,
    IconData icon,
    Color color,
  ) {
    return CustomCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
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
                    Text(
                      description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.map((step) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Text(step)),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}