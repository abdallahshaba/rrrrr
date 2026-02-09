class SleepRecordModel {
  final int? id;
  final int userId;
  final DateTime sleepTime;
  final DateTime wakeTime;
  final int quality;
  final String? notes;
  final int duration;

  SleepRecordModel({
    this.id,
    required this.userId,
    required this.sleepTime,
    required this.wakeTime,
    required this.quality,
    this.notes,
    required this.duration,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'sleep_time': sleepTime.toIso8601String(),
      'wake_time': wakeTime.toIso8601String(),
      'quality': quality,
      'notes': notes,
      'duration': duration,
    };
  }

  factory SleepRecordModel.fromMap(Map<String, dynamic> map) {
    return SleepRecordModel(
      id: map['id'],
      userId: map['user_id'],
      sleepTime: DateTime.parse(map['sleep_time']),
      wakeTime: DateTime.parse(map['wake_time']),
      quality: map['quality'],
      notes: map['notes'],
      duration: map['duration'],
    );
  }
}