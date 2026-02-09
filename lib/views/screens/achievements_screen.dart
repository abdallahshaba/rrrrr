import 'package:flutter/material.dart';
import '../widgets/custom_card.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {'title': 'البداية', 'description': 'سجّل دخولك لأول مرة', 'icon': '🎉', 'unlocked': true},
      {'title': 'المبتدئ', 'description': 'سجّل 7 أيام متتالية', 'icon': '🌟', 'unlocked': true},
      {'title': 'ملتزم', 'description': 'سجّل 30 يوماً متتالياً', 'icon': '🔥', 'unlocked': false},
      {'title': 'كاتب', 'description': 'اكتب 10 يوميات', 'icon': '📝', 'unlocked': true},
      {'title': 'متعلم', 'description': 'مارس 5 مهارات DBT', 'icon': '🎓', 'unlocked': true},
      {'title': 'محقق الأهداف', 'description': 'أكمل 5 أهداف', 'icon': '🎯', 'unlocked': false},
      {'title': 'محارب', 'description': 'استخدم SOS 3 مرات', 'icon': '💪', 'unlocked': false},
      {'title': 'إيجابي', 'description': 'سجّل مزاج إيجابي 14 يوماً', 'icon': '😊', 'unlocked': false},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('الإنجازات'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          final achievement = achievements[index];
          final isUnlocked = achievement['unlocked'] as bool;

          return CustomCard(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  achievement['icon'] as String,
                  style: TextStyle(
                    fontSize: 64,
                    color: isUnlocked ? null : Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  achievement['title'] as String,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isUnlocked ? null : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  achievement['description'] as String,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                if (!isUnlocked) ...[
                  const SizedBox(height: 8),
                  Icon(Icons.lock, color: Colors.grey[400], size: 20),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}