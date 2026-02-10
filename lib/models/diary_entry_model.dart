class DiaryEntryModel {
  final int? id;
  final int userId;
  final String title;
  final String content;
  final int? moodLevel;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? tags;
  
  // Emotions (المشاعر)
  final int? sadnessLevel;      // الحزن
  final int? anxietyLevel;      // القلق
  final int? angerLevel;        // الغضب
  final int? shameLevel;        // الجدل/الخجل
  
  // Urges (الدوافع)
  final int? selfHarmUrge;      // إيذاء النفس
  final int? suicidalUrge;      // الانتحار
  final int? calmnessLevel;     // الهدوء
  
  // Behaviors (السلوكيات)
  final List<String>? negativeBehaviors;  // السلوكيات السلبية
  final List<String>? positiveBehaviors;  // السلوكيات الإيجابية
  
  // Skills Used (المهارات المستخدمة)
  final List<String>? skillsUsed;
  
  // Sleep (النوم)
  final int? sleepHours;
  
  // Notes (ملاحظات)
  final String? notes;

  DiaryEntryModel({
    this.id,
    required this.userId,
    required this.title,
    required this.content,
    this.moodLevel,
    required this.createdAt,
    this.updatedAt,
    this.tags,
    this.sadnessLevel,
    this.anxietyLevel,
    this.angerLevel,
    this.shameLevel,
    this.selfHarmUrge,
    this.suicidalUrge,
    this.calmnessLevel,
    this.negativeBehaviors,
    this.positiveBehaviors,
    this.skillsUsed,
    this.sleepHours,
    this.notes,
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
      'sadness_level': sadnessLevel,
      'anxiety_level': anxietyLevel,
      'anger_level': angerLevel,
      'shame_level': shameLevel,
      'self_harm_urge': selfHarmUrge,
      'suicidal_urge': suicidalUrge,
      'calmness_level': calmnessLevel,
      'negative_behaviors': negativeBehaviors?.join(','),
      'positive_behaviors': positiveBehaviors?.join(','),
      'skills_used': skillsUsed?.join(','),
      'sleep_hours': sleepHours,
      'notes': notes,
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
      sadnessLevel: map['sadness_level'],
      anxietyLevel: map['anxiety_level'],
      angerLevel: map['anger_level'],
      shameLevel: map['shame_level'],
      selfHarmUrge: map['self_harm_urge'],
      suicidalUrge: map['suicidal_urge'],
      calmnessLevel: map['calmness_level'],
      negativeBehaviors: map['negative_behaviors'] != null && (map['negative_behaviors'] as String).isNotEmpty
          ? (map['negative_behaviors'] as String).split(',')
          : null,
      positiveBehaviors: map['positive_behaviors'] != null && (map['positive_behaviors'] as String).isNotEmpty
          ? (map['positive_behaviors'] as String).split(',')
          : null,
      skillsUsed: map['skills_used'] != null && (map['skills_used'] as String).isNotEmpty
          ? (map['skills_used'] as String).split(',')
          : null,
      sleepHours: map['sleep_hours'],
      notes: map['notes'],
    );
  }
}