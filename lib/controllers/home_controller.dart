import 'package:get/get.dart';
import '../services/database_service.dart';
import '../models/mood_model.dart';
import '../models/goal_model.dart';
import 'auth_controller.dart';

class HomeController extends GetxController {
  late final DatabaseService _db;      // تغيير إلى late
  late final AuthController _auth;     // تغيير إلى late
  
  final RxList<MoodModel> recentMoods = <MoodModel>[].obs;
  final RxList<GoalModel> activeGoals = <GoalModel>[].obs;
  final RxInt todayMood = 0.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // تسجيل التبعيات هنا بعد التأكد من وجودها
    _db = Get.find<DatabaseService>();
    _auth = Get.put(AuthController());
    
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    await Future.wait([
      loadRecentMoods(),
      loadActiveGoals(),
      loadTodayMood(),
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
  }

  Future<void> loadActiveGoals() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final goals = await _db.query(
      'goals',
      where: 'user_id = ? AND is_completed = 0',
      whereArgs: [userId],
      orderBy: 'target_date ASC',
      limit: 5,
    );
    
    activeGoals.value = goals.map((g) => GoalModel.fromMap(g)).toList();
  }

  Future<void> loadTodayMood() async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    final moods = await _db.query(
      'moods',
      where: 'user_id = ? AND timestamp >= ?',
      whereArgs: [userId, startOfDay.toIso8601String()],
      orderBy: 'timestamp DESC',
      limit: 1,
    );
    
    if (moods.isNotEmpty) {
      todayMood.value = MoodModel.fromMap(moods.first).moodLevel;
    }
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
    await loadData();
  }
}