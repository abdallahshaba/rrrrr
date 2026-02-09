import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/mood_model.dart';
import '../models/goal_model.dart';
import '../models/diary_entry_model.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.put(AuthController());
  
  final RxList<MoodModel> recentMoods = <MoodModel>[].obs;
  final RxList<GoalModel> activeGoals = <GoalModel>[].obs;
  final RxList<DiaryEntryModel> recentDiaryEntries = <DiaryEntryModel>[].obs;
  
  final RxInt todayMood = 0.obs;
  final RxDouble averageMood = 0.0.obs;
  final RxInt totalDiaryEntries = 0.obs;
  final RxInt completedGoalsCount = 0.obs;
  final RxInt totalGoalsCount = 0.obs;
  final RxInt todaySkillsPracticed = 0.obs;
  
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await Future.wait([
      loadRecentMoods(),
      loadActiveGoals(),
      loadTodayMood(),
      loadDiaryEntries(),
      loadStatistics(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadRecentMoods() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final moods = await _db.query(
      'moods',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: 7,
    );
    
    recentMoods.value = moods.map((m) => MoodModel.fromMap(m)).toList();
    
    // حساب متوسط المزاج
    if (recentMoods.isNotEmpty) {
      final sum = recentMoods.fold<int>(0, (sum, mood) => sum + mood.moodLevel);
      averageMood.value = sum / recentMoods.length;
    } else {
      averageMood.value = 0.0;
    }
  }

  Future<void> loadActiveGoals() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    // تحميل الأهداف النشطة
    final activeGoalsData = await _db.query(
      'goals',
      where: 'user_id = ? AND is_completed = 0',
      whereArgs: [userId],
      orderBy: 'target_date ASC',
      limit: 5,
    );
    
    activeGoals.value = activeGoalsData.map((g) => GoalModel.fromMap(g)).toList();
    
    // حساب عدد الأهداف الكلي
    final totalGoals = await _db.query(
      'goals',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    totalGoalsCount.value = totalGoals.length;
    
    // حساب عدد الأهداف المكتملة
    final completedGoals = await _db.query(
      'goals',
      where: 'user_id = ? AND is_completed = 1',
      whereArgs: [userId],
    );
    completedGoalsCount.value = completedGoals.length;
  }

  Future<void> loadTodayMood() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final moods = await _db.query(
      'moods',
      where: 'user_id = ? AND timestamp >= ? AND timestamp < ?',
      whereArgs: [userId, startOfDay.toIso8601String(), endOfDay.toIso8601String()],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    
    if (moods.isNotEmpty) {
      todayMood.value = MoodModel.fromMap(moods.first).moodLevel;
    } else {
      todayMood.value = 0;
    }
  }

  Future<void> loadDiaryEntries() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    // تحميل آخر اليوميات
    final entries = await _db.query(
      'diary_entries',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
      limit: 3,
    );
    
    recentDiaryEntries.value = entries.map((e) => DiaryEntryModel.fromMap(e)).toList();
    
    // حساب إجمالي اليوميات
    final allEntries = await _db.query(
      'diary_entries',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    totalDiaryEntries.value = allEntries.length;
  }

  Future<void> loadStatistics() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    // يمكن إضافة المزيد من الإحصائيات هنا
    // مثل عدد المهارات المطبقة اليوم، التمارين، إلخ
    
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    // مثال: عدد المهارات المطبقة (يمكن تعديله حسب الحاجة)
    todaySkillsPracticed.value = 0; // سيتم تحديثه عند إضافة جدول للمهارات المطبقة
  }

  Future<void> addMood(int moodLevel, String? note) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final mood = MoodModel(
      userId: userId,
      moodLevel: moodLevel,
      note: note,
      timestamp: DateTime.now(),
    );
    
    await _db.insert('moods', mood.toMap());
    await loadData(); // إعادة تحميل جميع البيانات
  }

  // دالة للحصول على نسبة إكمال الأهداف
  double get goalsCompletionPercentage {
    if (totalGoalsCount.value == 0) return 0.0;
    return (completedGoalsCount.value / totalGoalsCount.value) * 100;
  }

  // دالة للحصول على عدد الأهداف النشطة
  int get activeGoalsCount {
    return totalGoalsCount.value - completedGoalsCount.value;
  }
}