import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/medication_controller.dart';
import '../../utils/validators.dart';
import '../../utils/helpers.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class AddMedicationScreen extends StatefulWidget {
  const AddMedicationScreen({super.key});

  @override
  State<AddMedicationScreen> createState() => _AddMedicationScreenState();
}

class _AddMedicationScreenState extends State<AddMedicationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();
  final controller = Get.find<MedicationController>();
  
  String frequency = 'يومياً';
  List<TimeOfDay> times = [const TimeOfDay(hour: 9, minute: 0)];
  DateTime? endDate;

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة دواء'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CustomTextField(
              label: 'اسم الدواء',
              controller: _nameController,
              validator: (value) => Validators.validateRequired(value, 'اسم الدواء'),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'الجرعة',
              controller: _dosageController,
              hint: 'مثال: 50mg',
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: frequency,
              decoration: const InputDecoration(
                labelText: 'التكرار',
                border: OutlineInputBorder(),
              ),
              items: ['يومياً', 'كل يومين', 'أسبوعياً'].map((f) {
                return DropdownMenuItem(value: f, child: Text(f));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  frequency = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'أوقات تناول الدواء',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTime,
                        ),
                      ],
                    ),
                    ...times.asMap().entries.map((entry) {
                      return ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text(entry.value.format(context)),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            if (times.length > 1) {
                              setState(() {
                                times.removeAt(entry.key);
                              });
                            }
                          },
                        ),
                        onTap: () => _editTime(entry.key),
                      );
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'ملاحظات',
              controller: _notesController,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'حفظ',
              onPressed: _saveMedication,
              icon: Icons.save,
            ),
          ],
        ),
      ),
    );
  }

  void _addTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        times.add(time);
      });
    }
  }

  void _editTime(int index) async {
    final time = await showTimePicker(
      context: context,
      initialTime: times[index],
    );
    if (time != null) {
      setState(() {
        times[index] = time;
      });
    }
  }

  void _saveMedication() async {
    if (_formKey.currentState!.validate() && times.isNotEmpty) {
      await controller.addMedication(
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: frequency,
        times: times.map((t) => '${t.hour}:${t.minute}').toList(),
        startDate: DateTime.now(),
        endDate: endDate,
        notes: _notesController.text.isEmpty ? null : _notesController.text.trim(),
      );
      
      Helpers.showSuccessSnackbar('تم إضافة الدواء');
      Get.back();
    }
  }
}