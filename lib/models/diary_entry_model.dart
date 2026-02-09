class DiaryEntryModel {
  final int? id;
  final int userId;
  final String title;
  final String content;
  final int? moodLevel;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? tags;

  DiaryEntryModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.moodLevel,
    required this.createdAt,
    this.updatedAt,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'content': content,
      'mood_level': moodLevel,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'tags': tags?.join(','),
    };
  }

  factory DiaryEntryModel.fromMap(Map<String, dynamic> map) {
    return DiaryEntryModel(
      id: map['id'],
      userId: map['user_id'],
      title: map['title'],
      content: map['content'],
      moodLevel: map['mood_level'],
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: map['updated_at'] != null ? DateTime.parse(map['updated_at']) : null,
      tags: map['tags'] != null ? (map['tags'] as String).split(',') : null,
    );
  }
}