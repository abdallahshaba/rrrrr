class MoodModel {
  final int? id;
  final int userId;
  final int moodLevel;
  final String? note;
  final DateTime timestamp;
  final List<String>? triggers;
  final List<String>? activities;

  MoodModel({
    this.id,
    required this.userId,
    required this.moodLevel,
    this.note,
    required this.timestamp,
    this.triggers,
    this.activities,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'mood_level': moodLevel,
      'note': note,
      'timestamp': timestamp.toIso8601String(),
      'triggers': triggers?.join(','),
      'activities': activities?.join(','),
    };
  }

  factory MoodModel.fromMap(Map<String, dynamic> map) {
    return MoodModel(
      id: map['id'],
      userId: map['user_id'],
      moodLevel: map['mood_level'],
      note: map['note'],
      timestamp: DateTime.parse(map['timestamp']),
      triggers: map['triggers'] != null ? (map['triggers'] as String).split(',') : null,
      activities: map['activities'] != null ? (map['activities'] as String).split(',') : null,
    );
  }
}