// import 'package:get/get.dart';
// import '../services/storage_service.dart';
// import '../services/notification_service.dart';
// import '../config/app_config.dart';

// class NotificationsController extends GetxController {
//   final StorageService _storage = Get.find<StorageService>();
//   //final NotificationService _notifications = Get.find<NotificationService>();
  
//   final RxBool notificationsEnabled = true.obs;
//   final RxBool dailyReminder = true.obs;
//   final RxBool medicationReminders = true.obs;
//   final RxBool goalReminders = true.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     loadSettings();
//   }

//   void loadSettings() {
//     notificationsEnabled.value = _storage.getBool(AppConfig.keyNotificationsEnabled) ?? true;
//     dailyReminder.value = _storage.getBool('daily_reminder') ?? true;
//     medicationReminders.value = _storage.getBool('medication_reminders') ?? true;
//     goalReminders.value = _storage.getBool('goal_reminders') ?? true;
//   }

//   Future<void> toggleNotifications(bool value) async {
//     notificationsEnabled.value = value;
//     await _storage.setBool(AppConfig.keyNotificationsEnabled, value);
    
//     if (!value) {
//       await _notifications.cancelAllNotifications();
//     }
//   }

//   Future<void> toggleDailyReminder(bool value) async {
//     dailyReminder.value = value;
//     await _storage.setBool('daily_reminder', value);
    
//     if (value) {
//       await _scheduleDailyReminder();
//     }
//   }

//   Future<void> _scheduleDailyReminder() async {
//     final now = DateTime.now();
//     var scheduledTime = DateTime(
//       now.year,
//       now.month,
//       now.day,
//       AppConfig.dailyReminderHour,
//       AppConfig.dailyReminderMinute,
//     );
    
//     if (scheduledTime.isBefore(now)) {
//       scheduledTime = scheduledTime.add(const Duration(days: 1));
//     }
    
//     await _notifications.scheduleNotification(
//       id: 1,
//       title: 'تذكير يومي',
//       body: 'لا تنسى تسجيل مزاجك اليوم',
//       scheduledTime: scheduledTime,
//     );
//   }

//   Future<void> toggleMedicationReminders(bool value) async {
//     medicationReminders.value = value;
//     await _storage.setBool('medication_reminders', value);
//   }

//   Future<void> toggleGoalReminders(bool value) async {
//     goalReminders.value = value;
//     await _storage.setBool('goal_reminders', value);
//   }
// }