// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:get/get.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest.dart' as tz;

// class NotificationService extends GetxService {
//   final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

//   Future<NotificationService> init() async {
//     tz.initializeTimeZones();
    
//     const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const iosSettings = DarwinInitializationSettings(
//       requestAlertPermission: true,
//       requestBadgePermission: true,
//       requestSoundPermission: true,
//     );
    
//     const initSettings = InitializationSettings(
//       android: androidSettings,
//       iOS: iosSettings,
//     );
    
//     await _notifications.initialize(
//       initSettings,
//       onDidReceiveNotificationResponse: _onNotificationTap,
//     );
    
//     await _requestPermissions();
    
//     return this;
//   }

//   Future<void> _requestPermissions() async {
//     await _notifications
//         .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
        
//     await _notifications
//         .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(alert: true, badge: true, sound: true);
//   }

//   void _onNotificationTap(NotificationResponse response) {
//     // Handle notification tap
//   }

//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'default_channel',
//       'Default',
//       channelDescription: 'Default notification channel',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
    
//     const iosDetails = DarwinNotificationDetails();
    
//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
    
//     await _notifications.show(id, title, body, details, payload: payload);
//   }

//   Future<void> scheduleNotification({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     String? payload,
//   }) async {
//     const androidDetails = AndroidNotificationDetails(
//       'scheduled_channel',
//       'Scheduled',
//       channelDescription: 'Scheduled notifications',
//       importance: Importance.high,
//       priority: Priority.high,
//     );
    
//     const iosDetails = DarwinNotificationDetails();
    
//     const details = NotificationDetails(
//       android: androidDetails,
//       iOS: iosDetails,
//     );
    
//     await _notifications.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(scheduledTime, tz.local),
//       details,
//       uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
//       payload: payload,
//     );
//   }

//   Future<void> cancelNotification(int id) async {
//     await _notifications.cancel(id);
//   }

//   Future<void> cancelAllNotifications() async {
//     await _notifications.cancelAll();
//   }
// }