import 'package:get/get.dart';
import '../models/diary_entry_model.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class DiaryController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.find<AuthController>();
  
  final RxList<DiaryEntryModel> entries = <DiaryEntryModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadEntries();
  }

  Future<void> loadEntries() async {
    isLoading.value = true;
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final data = await _db.query(
      'diary_entries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    
    entries.value = data.map((e) => DiaryEntryModel.fromMap(e)).toList();
    isLoading.value = false;
  }

  Future<void> addEntry({
    required String title,
    required String content,
    int? moodLevel,
    List<String>? tags,
  }) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final entry = DiaryEntryModel(
      userId: userId,
      title: title,
      content: content,
      moodLevel: moodLevel,
      createdAt: DateTime.now(),
      tags: tags,
    );
    
    await _db.insert('diary_entries', entry.toMap());
    await loadEntries();
  }

  Future<void> updateEntry({
    required int id,
    required String title,
    required String content,
    int? moodLevel,
    List<String>? tags,
  }) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final entry = DiaryEntryModel(
      id: id,
      userId: userId,
      title: title,
      content: content,
      moodLevel: moodLevel,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: tags,
    );
    
    await _db.update(
      'diary_entries',
      entry.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
    
    await loadEntries();
  }

  Future<void> deleteEntry(int id) async {
    await _db.delete('diary_entries', where: 'id = ?', whereArgs: [id]);
    await loadEntries();
  }

  Future<void> addDiaryEntry({
  required String title,
  required String content,
  int? moodLevel,
  List<String>? tags,
  int? sadnessLevel,
  int? anxietyLevel,
  int? angerLevel,
  int? shameLevel,
  int? selfHarmUrge,
  int? suicidalUrge,
  int? calmnessLevel,
  List<String>? negativeBehaviors,
  List<String>? positiveBehaviors,
  List<String>? skillsUsed,
  int? sleepHours,
  String? notes,
}) async {
  final userId = _auth.currentUser.value?.id;
  if (userId == null) return;
  
  final entry = DiaryEntryModel(
    userId: userId,
    title: title,
    content: content,
    moodLevel: moodLevel,
    createdAt: DateTime.now(),
    tags: tags,
    sadnessLevel: sadnessLevel,
    anxietyLevel: anxietyLevel,
    angerLevel: angerLevel,
    shameLevel: shameLevel,
    selfHarmUrge: selfHarmUrge,
    suicidalUrge: suicidalUrge,
    calmnessLevel: calmnessLevel,
    negativeBehaviors: negativeBehaviors,
    positiveBehaviors: positiveBehaviors,
    skillsUsed: skillsUsed,
    sleepHours: sleepHours,
    notes: notes,
  );
  
  await _db.insert('diary_entries', entry.toMap());
  await loadEntries();
}

  List<DiaryEntryModel> searchEntries(String query) {
    if (query.isEmpty) return entries;
    
    return entries.where((entry) {
      return entry.title.toLowerCase().contains(query.toLowerCase()) ||
          entry.content.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}