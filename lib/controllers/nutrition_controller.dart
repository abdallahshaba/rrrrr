import 'package:get/get.dart';
import '../models/meal_model.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class NutritionController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.find<AuthController>();
  
  final RxList<MealModel> meals = <MealModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMeals();
  }

  Future<void> loadMeals() async {
    isLoading.value = true;
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final data = await _db.query(
      'meals',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );
    
    meals.value = data.map((m) => MealModel.fromMap(m)).toList();
    isLoading.value = false;
  }

  Future<void> addMeal({
    required String mealType,
    required String description,
    int? moodBefore,
    int? moodAfter,
  }) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final meal = MealModel(
      userId: userId,
      mealType: mealType,
      description: description,
      timestamp: DateTime.now(),
      moodBefore: moodBefore,
      moodAfter: moodAfter,
    );
    
    await _db.insert('meals', meal.toMap());
    await loadMeals();
  }

  Future<void> deleteMeal(int id) async {
    await _db.delete('meals', where: 'id = ?', whereArgs: [id]);
    await loadMeals();
  }
}