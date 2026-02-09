class MealModel {
  final int? id;
  final int userId;
  final String mealType;
  final String description;
  final DateTime timestamp;
  final int? moodBefore;
  final int? moodAfter;

  MealModel({
    this.id,
    required this.userId,
    required this.mealType,
    required this.description,
    required this.timestamp,
    this.moodBefore,
    this.moodAfter,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'meal_type': mealType,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'mood_before': moodBefore,
      'mood_after': moodAfter,
    };
  }

  factory MealModel.fromMap(Map<String, dynamic> map) {
    return MealModel(
      id: map['id'],
      userId: map['user_id'],
      mealType: map['meal_type'],
      description: map['description'],
      timestamp: DateTime.parse(map['timestamp']),
      moodBefore: map['mood_before'],
      moodAfter: map['mood_after'],
    );
  }
}