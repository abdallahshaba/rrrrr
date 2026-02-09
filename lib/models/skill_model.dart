class SkillModel {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String content;
  final List<String> steps;
  final String? imageUrl;
  final int difficulty;

  SkillModel({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.content,
    required this.steps,
    this.imageUrl,
    this.difficulty = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'content': content,
      'steps': steps.join('|'),
      'image_url': imageUrl,
      'difficulty': difficulty,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      content: map['content'],
      steps: (map['steps'] as String).split('|'),
      imageUrl: map['image_url'],
      difficulty: map['difficulty'] ?? 1,
    );
  }
}