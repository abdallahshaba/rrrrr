class BehaviorModel {
  final int? id;
  final int userId;
  final String behavior;
  final bool isPositive;
  final DateTime timestamp;
  final String? notes;

  BehaviorModel({
    this.id,
    required this.userId,
    required this.behavior,
    required this.isPositive,
    required this.timestamp,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'behavior': behavior,
      'is_positive': isPositive ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
      'notes': notes,
    };
  }

  factory BehaviorModel.fromMap(Map<String, dynamic> map) {
    return BehaviorModel(
      id: map['id'],
      userId: map['user_id'],
      behavior: map['behavior'],
      isPositive: map['is_positive'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
      notes: map['notes'],
    );
  }
}