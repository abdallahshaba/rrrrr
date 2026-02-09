class GoalModel {
  final int? id;
  final int userId;
  final String title;
  final String? description;
  final String category;
  final DateTime targetDate;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? completedAt;
  final int progress;

  GoalModel({
    this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.category,
    required this.targetDate,
    this.isCompleted = false,
    required this.createdAt,
    this.completedAt,
    this.progress = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'target_date': targetDate.toIso8601String(),
      'is_completed': isCompleted ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'progress': progress,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      targetDate: DateTime.parse(map['target_date']),
      isCompleted: map['is_completed'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      completedAt: map['completed_at'] != null ? DateTime.parse(map['completed_at']) : null,
      progress: map['progress'] ?? 0,
    );
  }
}