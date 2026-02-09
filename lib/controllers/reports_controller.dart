import 'package:get/get.dart';
import '../models/mood_model.dart';
import '../services/database_service.dart';
import '../services/pdf_service.dart';
import 'auth_controller.dart';

class ReportsController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.find<AuthController>();
  final PdfService _pdfService = PdfService();
  
  final RxList<MoodModel> weeklyMoods = <MoodModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWeeklyData();
  }

  Future<void> loadWeeklyData() async {
    isLoading.value = true;
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final weekAgo = DateTime.now().subtract(const Duration(days: 7));
    
    final moods = await _db.query(
      'moods',
      where: 'user_id = ? AND timestamp >= ?',
      whereArgs: [userId, weekAgo.toIso8601String()],
      orderBy: 'timestamp ASC',
    );
    
    weeklyMoods.value = moods.map((m) => MoodModel.fromMap(m)).toList();
    isLoading.value = false;
  }

  Future<void> exportReport() async {
    final userName = _auth.currentUser.value?.name ?? 'User';
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));
    
    final moodData = weeklyMoods.map((mood) => {
      'date': mood.timestamp.toString().split(' ')[0],
      'level': mood.moodLevel,
      'note': mood.note,
    }).toList();
    
    final pdfFile = await _pdfService.generateMoodReport(
      userName: userName,
      startDate: startDate,
      endDate: endDate,
      moodData: moodData,
    );
    
    await _pdfService.sharePdf(pdfFile);
  }

  double get averageMood {
    if (weeklyMoods.isEmpty) return 0;
    final total = weeklyMoods.fold<int>(0, (sum, mood) => sum + mood.moodLevel);
    return total / weeklyMoods.length;
  }
}