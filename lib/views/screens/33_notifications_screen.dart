// import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../../controllers/notifications_controller.dart';

// class NotificationsScreen extends StatelessWidget {
//   const NotificationsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(NotificationsController());

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الإشعارات'),
//       ),
//       body: Obx(() => ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           CustomCard(
//             child: SwitchListTile(
//               title: const Text('تفعيل الإشعارات'),
//               subtitle: const Text('تلقي جميع الإشعارات'),
//               value: controller.notificationsEnabled.value,
//               onChanged: controller.toggleNotifications,
//             ),
//           ),
//           if (controller.notificationsEnabled.value) ...[
//             const SizedBox(height: 16),
//             CustomCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     'أنواع الإشعارات',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 8),
//                   Obx(() => SwitchListTile(
//                     title: const Text('التذكير اليومي'),
//                     subtitle: const Text('تذكير بتسجيل مزاجك'),
//                     value: controller.dailyReminder.value,
//                     onChanged: controller.toggleDailyReminder,
//                   )),
//                   Obx(() => SwitchListTile(
//                     title: const Text('تذكير الأدوية'),
//                     subtitle: const Text('تذكير بمواعيد الأدوية'),
//                     value: controller.medicationReminders.value,
//                     onChanged: controller.toggleMedicationReminders,
//                   )),
//                   Obx(() => SwitchListTile(
//                     title: const Text('تذكير الأهداف'),
//                     subtitle: const Text('تذكير بالأهداف القادمة'),
//                     value: controller.goalReminders.value,
//                     onChanged: controller.toggleGoalReminders,
//                   )),
//                 ],
//               ),
//             ),
//           ],
//         ],
//       )),
//     );
//   }
// }