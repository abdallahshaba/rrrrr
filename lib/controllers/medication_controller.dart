import 'package:get/get.dart';
import '../models/medication_model.dart';
import '../services/database_service.dart';
import '../services/notification_service.dart';
import 'auth_controller.dart';

class MedicationController extends GetxController {
  final DatabaseService _db = Get.find<DatabaseService>();
  final AuthController _auth = Get.find<AuthController>();
  //final NotificationService _notifications = Get.find<NotificationService>();
  
  final RxList<MedicationModel> medications = <MedicationModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMedications();
  }

  Future<void> loadMedications() async {
    isLoading.value = true;
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final data = await _db.query(
      'medications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_date DESC',
    );
    
    medications.value = data.map((m) => MedicationModel.fromMap(m)).toList();
    isLoading.value = false;
  }

  Future<void> addMedication({
    required String name,
    String? dosage,
    required String frequency,
    required List<String> times,
    required DateTime startDate,
    DateTime? endDate,
    String? notes,
  }) async {
    final userId = _auth.currentUser.value?.id;
    if (userId == null) return;
    
    final medication = MedicationModel(
      userId: userId,
      name: name,
      dosage: dosage,
      frequency: frequency,
      times: times,
      startDate: startDate,
      endDate: endDate,
      notes: notes,
    );
    
    final medId = await _db.insert('medications', medication.toMap());
    
    // Schedule notifications
    await _scheduleMedicationNotifications(medId, medication);
    
    await loadMedications();
  }

  Future<void> _scheduleMedicationNotifications(int medId, MedicationModel med) async {
    for (var timeStr in med.times) {
      final timeParts = timeStr.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      final now = DateTime.now();
      var scheduledTime = DateTime(now.year, now.month, now.day, hour, minute);
      
      if (scheduledTime.isBefore(now)) {
        scheduledTime = scheduledTime.add(const Duration(days: 1));
      }
      
      // await _notifications.scheduleNotification(
      //   id: medId * 100 + med.times.indexOf(timeStr),
      //   title: 'تذكير بالدواء',
      //   body: 'حان وقت تناول ${med.name}',
      //   scheduledTime: scheduledTime,
      // );
    }
  }

  Future<void> deleteMedication(int id) async {
    await _db.delete('medications', where: 'id = ?', whereArgs: [id]);
    await loadMedications();
  }

  Future<void> toggleMedicationStatus(int id, bool isActive) async {
    await _db.update(
      'medications',
      {'is_active': isActive ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
    
    await loadMedications();
  }
}