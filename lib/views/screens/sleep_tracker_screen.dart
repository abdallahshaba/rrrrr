import 'package:dbt_mental_health_app/views/widgets/custom_card.dart';
import 'package:dbt_mental_health_app/views/widgets/empty_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/sleep_controller.dart';
import '../../../utils/helpers.dart';


class SleepTrackerScreen extends StatelessWidget {
  const SleepTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SleepController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('متابعة النوم'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الإحصائيات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatBox(
                        'المتوسط',
                        '${controller.getAverageSleepDuration().toStringAsFixed(1)} ساعة',
                        Icons.bedtime,
                        Colors.blue,
                      ),
                      _buildStatBox(
                        'الجودة',
                        '${controller.getAverageSleepQuality().toStringAsFixed(1)}/10',
                        Icons.star,
                        Colors.orange,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'سجل النوم',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showAddSleepDialog(context, controller),
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (controller.records.isEmpty)
              const EmptyStateWidget(
                icon: Icons.bedtime,
                title: 'لا توجد سجلات',
                message: 'ابدأ بتسجيل نومك',
              )
            else
              ...controller.records.map((record) => CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bedtime, color: Colors.blue, size: 32),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Helpers.formatDate(record.sleepTime),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${Helpers.formatTime(record.sleepTime)} - ${Helpers.formatTime(record.wakeTime)}',
                                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text('المدة', style: TextStyle(fontSize: 12)),
                            Text(
                              '${(record.duration / 60).toStringAsFixed(1)} ساعة',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('الجودة', style: TextStyle(fontSize: 12)),
                            Row(
                              children: [
                                Text(
                                  '${record.quality}/10',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.star,
                                  size: 16,
                                  color: Colors.orange,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (record.notes != null) ...[
                      const SizedBox(height: 12),
                      const Divider(),
                      const SizedBox(height: 12),
                      Text(record.notes!),
                    ],
                  ],
                ),
              )),
          ],
        );
      }),
    );
  }

  Widget _buildStatBox(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 32, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  void _showAddSleepDialog(BuildContext context, SleepController controller) {
    DateTime sleepTime = DateTime.now().subtract(const Duration(hours: 8));
    DateTime wakeTime = DateTime.now();
    int quality = 5;
    final notesController = TextEditingController();

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('تسجيل النوم'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.bedtime),
                    title: const Text('وقت النوم'),
                    subtitle: Text(Helpers.formatDateTime(sleepTime)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: sleepTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 7)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(sleepTime),
                        );
                        if (time != null) {
                          setState(() {
                            sleepTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.wb_sunny),
                    title: const Text('وقت الاستيقاظ'),
                    subtitle: Text(Helpers.formatDateTime(wakeTime)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: wakeTime,
                        firstDate: DateTime.now().subtract(const Duration(days: 7)),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(wakeTime),
                        );
                        if (time != null) {
                          setState(() {
                            wakeTime = DateTime(
                              date.year,
                              date.month,
                              date.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('جودة النوم'),
                  Slider(
                    value: quality.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    label: quality.toString(),
                    onChanged: (value) {
                      setState(() {
                        quality = value.toInt();
                      });
                    },
                  ),
                  TextField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      labelText: 'ملاحظات (اختياري)',
                    ),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.addRecord(
                    sleepTime: sleepTime,
                    wakeTime: wakeTime,
                    quality: quality,
                    notes: notesController.text.isEmpty ? null : notesController.text,
                  );
                  Get.back();
                  Helpers.showSuccessSnackbar('تم تسجيل النوم');
                },
                child: const Text('حفظ'),
              ),
            ],
          );
        },
      ),
    );
  }
}