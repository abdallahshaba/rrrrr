import 'package:dbt_mental_health_app/config/routes_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/medication_controller.dart';
import '../../utils/helpers.dart';
import '../widgets/custom_card.dart';
import '../widgets/empty_state_widget.dart';

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('الأدوية'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.medications.isEmpty) {
          return EmptyStateWidget(
            icon: Icons.medication,
            title: 'لا توجد أدوية',
            message: 'أضف الأدوية التي تتناولها لتتبعها',
            buttonText: 'إضافة دواء',
            onButtonPressed: () => Get.toNamed(RoutesConfig.addMedication),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.medications.length,
          itemBuilder: (context, index) {
            final med = controller.medications[index];
            return CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: med.isActive ? Colors.blue.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.medication,
                          color: med.isActive ? Colors.blue : Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              med.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (med.dosage != null)
                              Text(
                                med.dosage!,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                          ],
                        ),
                      ),
                      Switch(
                        value: med.isActive,
                        onChanged: (value) => controller.toggleMedicationStatus(med.id!, value),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 16),
                      const SizedBox(width: 8),
                      Text('${med.frequency} - ${med.times.join(", ")}'),
                    ],
                  ),
                  if (med.notes != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.note, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(med.notes!)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          final confirm = await Helpers.showConfirmDialog(
                            title: 'تأكيد الحذف',
                            message: 'هل تريد حذف هذا الدواء؟',
                          );
                          if (confirm) {
                            await controller.deleteMedication(med.id!);
                            Helpers.showSuccessSnackbar('تم حذف الدواء');
                          }
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text('حذف', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(RoutesConfig.addMedication),
        child: const Icon(Icons.add),
      ),
    );
  }
}