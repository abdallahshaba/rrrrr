class ExerciseModel {
  final int? id;
  final int userId;
  final String type;
  final int duration;
  final DateTime timestamp;
  final int? moodBefore;
  final int? moodAfter;
  final String? notes;

  ExerciseModel({
    this.id,
    required this.userId,
    required this.type,
    required this.duration,
    required this.timestamp,
    this.moodBefore,
    this.moodAfter,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'type': type,
      'duration': duration,
      'timestamp': timestamp.toIso8601String(),
      'mood_before': moodBefore,
      'mood_after': moodAfter,
      'notes': notes,
    };
  }

  factory ExerciseModel.fromMap(Map<String, dynamic> map) {
    return ExerciseModel(
      id: map['id'],
      userId: map['user_id'],
      type: map['type'],
      duration: map['duration'],
      timestamp: DateTime.parse(map['timestamp']),
      moodBefore: map['mood_before'],
      moodAfter: map['mood_after'],
      notes: map['notes'],
    );
  }
}