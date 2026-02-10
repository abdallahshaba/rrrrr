import 'package:get/get.dart';
import '../models/mood_model.dart';
import '../services/database_service.dart';
import '../services/pdf_service.dart';
import 'auth_controller.dart';
import 'dart:io';

class ReportsController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.find<AuthController>();
  final PdfService _pdfService = PdfService();
  
  final RxList<MoodModel> weeklyMoods = <MoodModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rx<File?> generatedPdfFile = Rx<File?>(null);

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

  Future<File?> generateReport() async {
    final userName = _auth.currentUser.value?.name ?? 'المستخدم';
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));
    
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return null;
    
    final moods = await _db.query(
      'moods',
      where: 'user_id = ? AND timestamp >= ? AND timestamp <= ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'timestamp DESC',
    );
    
    final moodList = moods.map((m) => MoodModel.fromMap(m)).toList();
    
    if (moodList.isEmpty) return null;
    
    final averageMood = moodList.fold<int>(0, (sum, mood) => sum + mood.moodLevel) / moodList.length;
    
    final pdfFile = await _pdfService.generateMoodReport(
      userName: userName,
      startDate: startDate,
      endDate: endDate,
      moodDataa: moodList,
      averageMood: averageMood,
      totalEntries: moodList.length, moodData: [],
    );
    
    generatedPdfFile.value = pdfFile;
    return pdfFile;
  }

  Future<void> exportReport() async {
    final file = await generateReport();
    if (file != null) {
      await _pdfService.sharePdf(file);
    }
  }

  double get averageMood {
    if (weeklyMoods.isEmpty) return 0;
    final total = weeklyMoods.fold<int>(0, (sum, mood) => sum + mood.moodLevel);
    return total / weeklyMoods.length;
  }
}