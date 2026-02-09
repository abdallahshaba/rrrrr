import 'package:dbt_mental_health_app/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/reports_controller.dart';
import '../../../utils/helpers.dart';

class ExportPdfScreen extends StatefulWidget {
  const ExportPdfScreen({super.key});

  @override
  State<ExportPdfScreen> createState() => _ExportPdfScreenState();
}

class _ExportPdfScreenState extends State<ExportPdfScreen> {
  final controller = Get.find<ReportsController>();
  DateTime? startDate;
  DateTime? endDate;
  bool includeNotes = true;
  bool includeCharts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تصدير PDF'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الفترة الزمنية',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('تاريخ البداية'),
                    subtitle: Text(
                      startDate != null ? Helpers.formatDate(startDate!) : 'غير محدد',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          startDate = date;
                        });
                      }
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('تاريخ النهاية'),
                    subtitle: Text(
                      endDate != null ? Helpers.formatDate(endDate!) : 'غير محدد',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() {
                          endDate = date;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'المحتوى',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('تضمين الملاحظات'),
                    value: includeNotes,
                    onChanged: (value) {
                      setState(() {
                        includeNotes = value;
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('تضمين المخططات'),
                    value: includeCharts,
                    onChanged: (value) {
                      setState(() {
                        includeCharts = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          CustomButton(
            text: 'تصدير PDF',
            onPressed: _exportPdf,
            icon: Icons.download,
          ),
        ],
      ),
    );
  }

  void _exportPdf() async {
    if (startDate == null || endDate == null) {
      Helpers.showErrorSnackbar('الرجاء تحديد الفترة الزمنية');
      return;
    }

    await controller.exportReport();
    Helpers.showSuccessSnackbar('تم تصدير التقرير بنجاح');
  }
}