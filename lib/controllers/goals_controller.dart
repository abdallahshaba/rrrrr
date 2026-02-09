import 'package:get/get.dart';
import '../models/goal_model.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class GoalsController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.find<AuthController>();
  
  final RxList<GoalModel> goals = <GoalModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadGoals();
  }

  Future<void> loadGoals() async {
    isLoading.value = true;
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final data = await _db.query(
      'goals',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    
    goals.value = data.map((g) => GoalModel.fromMap(g)).toList();
    isLoading.value = false;
  }

  Future<void> addGoal({
    required String title,
    String? description,
    required String category,
    required DateTime targetDate,
  }) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final goal = GoalModel(
      userId: userId,
      title: title,
      description: description,
      category: category,
      targetDate: targetDate,
      createdAt: DateTime.now(),
    );
    
    await _db.insert('goals', goal.toMap());
    await loadGoals();
  }

  Future<void> updateGoalProgress(int goalId, int progress) async {
    await _db.update(
      'goals',
      {'progress': progress},
      where: 'id = ?',
      whereArgs: [goalId],
    );
    
    await loadGoals();
  }

  Future<void> completeGoal(int goalId) async {
    await _db.update(
      'goals',
      {
        'is_completed': 1,
        'completed_at': DateTime.now().toIso8601String(),
        'progress': 100,
      },
      where: 'id = ?',
      whereArgs: [goalId],
    );
    
    await loadGoals();
  }

  Future<void> deleteGoal(int goalId) async {
    await _db.delete('goals', where: 'id = ?', whereArgs: [goalId]);
    await loadGoals();
  }

  List<GoalModel> getActiveGoals() {
    return goals.where((g) => !g.isCompleted).toList();
  }

  List<GoalModel> getCompletedGoals() {
    return goals.where((g) => g.isCompleted).toList();
  }
}