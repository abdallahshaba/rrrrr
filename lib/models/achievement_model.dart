class AchievementModel {
  final int? id;
  final String title;
  final String description;
  final String icon;
  final int requiredPoints;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  AchievementModel({
    this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.requiredPoints,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'required_points': requiredPoints,
      'is_unlocked': isUnlocked ? 1 : 0,
      'unlocked_at': unlockedAt?.toIso8601String(),
    };
  }

  factory AchievementModel.fromMap(Map<String, dynamic> map) {
    return AchievementModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      icon: map['icon'],
      requiredPoints: map['required_points'],
      isUnlocked: map['is_unlocked'] == 1,
      unlockedAt: map['unlocked_at'] != null ? DateTime.parse(map['unlocked_at']) : null,
    );
  }
}