import 'package:get/get.dart';
import '../models/sleep_record_model.dart';
import '../services/database_service.dart';
import 'auth_controller.dart';

class SleepController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.find<AuthController>();
  
  final RxList<SleepRecordModel> records = <SleepRecordModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRecords();
  }

  Future<void> loadRecords() async {
    isLoading.value = true;
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final data = await _db.query(
      'sleep_records',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'sleep_time DESC',
    );
    
    records.value = data.map((r) => SleepRecordModel.fromMap(r)).toList();
    isLoading.value = false;
  }

  Future<void> addRecord({
    required DateTime sleepTime,
    required DateTime wakeTime,
    required int quality,
    String? notes,
  }) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final duration = wakeTime.difference(sleepTime).inMinutes;
    
    final record = SleepRecordModel(
      userId: userId,
      sleepTime: sleepTime,
      wakeTime: wakeTime,
      quality: quality,
      notes: notes,
      duration: duration,
    );
    
    await _db.insert('sleep_records', record.toMap());
    await loadRecords();
  }

  double getAverageSleepDuration() {
    if (records.isEmpty) return 0;
    
    final total = records.fold<int>(0, (sum, record) => sum + record.duration);
    return total / records.length / 60;
  }

  double getAverageSleepQuality() {
    if (records.isEmpty) return 0;
    
    final total = records.fold<int>(0, (sum, record) => sum + record.quality);
    return total / records.length;
  }
}