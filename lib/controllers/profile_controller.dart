import 'package:get/get.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _auth = Get.find<AuthController>();
  
  final RxInt totalMoods = 0.obs;
  final RxInt totalDiaryEntries = 0.obs;
  final RxInt completedGoals = 0.obs;
  final RxInt activeStreak = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    // Load user statistics
    totalMoods.value = 45;
    totalDiaryEntries.value = 23;
    completedGoals.value = 7;
    activeStreak.value = 12;
  }

  String get userName => _auth.currentUser.value?.name ?? 'المستخدم';
  String get userEmail => _auth.currentUser.value?.email ?? '';
}