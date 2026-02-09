import 'package:flutter/material.dart';
import '../../data/exercises_data.dart';
import '../widgets/custom_card.dart';

class ExerciseScreen extends StatelessWidget {
  const ExerciseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exercises = ExercisesData.getExercises();

    return Scaffold(
      appBar: AppBar(
        title: const Text('التمارين الرياضية'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'لماذا التمارين الرياضية؟',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  'التمارين الرياضية تساعد على:\n'
                  '• تحسين المزاج\n'
                  '• تقليل القلق والاكتئاب\n'
                  '• زيادة الطاقة\n'
                  '• تحسين جودة النوم\n'
                  '• تعزيز احترام الذات',
                  style: TextStyle(color: Colors.grey[700], height: 1.6),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'تمارين مقترحة',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...exercises.map((exercise) => CustomCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(exercise['difficulty']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getExerciseIcon(exercise['name']),
                    color: _getDifficultyColor(exercise['difficulty']),
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise['name'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${exercise['duration']} دقيقة',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.local_fire_department, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(
                            '${exercise['calories']} سعرة',
                            style: TextStyle(color: Colors.grey[600], fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor(exercise['difficulty']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    exercise['difficulty'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: _getDifficultyColor(exercise['difficulty']),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  IconData _getExerciseIcon(String name) {
    if (name.contains('المشي')) return Icons.directions_walk;
    if (name.contains('الجري')) return Icons.directions_run;
    if (name.contains('اليوغا')) return Icons.self_improvement;
    if (name.contains('القوة')) return Icons.fitness_center;
    if (name.contains('السباحة')) return Icons.pool;
    return Icons.sports;
  }

  Color _getDifficultyColor(String difficulty) {
    if (difficulty == 'سهل') return Colors.green;
    if (difficulty == 'متوسط') return Colors.orange;
    return Colors.red;
  }
}