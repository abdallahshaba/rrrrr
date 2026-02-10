import 'package:dbt_mental_health_app/views/screens/pdf_viewer_screen.dart';
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
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    // تعيين قيم افتراضية
    endDate = DateTime.now();
    startDate = endDate!.subtract(const Duration(days: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FC),
        appBar: AppBar(
          backgroundColor: const Color(0xFF5E81AC),
          foregroundColor: Colors.white,
          title: const Text(
            'تصدير تقرير PDF',
            style: TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // معلومات عن التقرير
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF88C9A1), Color(0xFF5E81AC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.picture_as_pdf,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'تقرير المزاج الشامل',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'احصل على تقرير مفصل عن مزاجك',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // اختيار الفترة الزمنية
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'الفترة الزمنية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // تاريخ البداية
                    _buildDateSelector(
                      label: 'من تاريخ',
                      date: startDate,
                      icon: Icons.calendar_today,
                      onTap: () => _selectDate(context, true),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // تاريخ النهاية
                    _buildDateSelector(
                      label: 'إلى تاريخ',
                      date: endDate,
                      icon: Icons.event,
                      onTap: () => _selectDate(context, false),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // خيارات سريعة
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildQuickOption('آخر 7 أيام', 7),
                        _buildQuickOption('آخر 14 يوم', 14),
                        _buildQuickOption('آخر 30 يوم', 30),
                        _buildQuickOption('آخر 90 يوم', 90),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // محتويات التقرير
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'محتويات التقرير',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContentItem(Icons.mood, 'سجل المزاج اليومي'),
                    _buildContentItem(Icons.analytics, 'الإحصائيات والمتوسطات'),
                    _buildContentItem(Icons.show_chart, 'التحليلات والرسوم البيانية'),
                    _buildContentItem(Icons.lightbulb, 'التوصيات والملاحظات'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // أزرار التصدير والعرض
            if (isGenerating)
              const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(color: Color(0xFF5E81AC)),
                    SizedBox(height: 16),
                    Text(
                      'جاري إنشاء التقرير...',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 16),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  // زر معاينة PDF
                  CustomButton(
                    text: 'معاينة التقرير',
                    onPressed: _previewPdf,
                    icon: Icons.visibility,
                  ),
                  const SizedBox(height: 12),
                  
                  // زر تصدير PDF
                  OutlinedButton.icon(
                    onPressed: _exportPdf,
                    icon: const Icon(Icons.share),
                    label: const Text(
                      'مشاركة التقرير',
                      style: TextStyle(fontFamily: 'Cairo', fontSize: 14),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF5E81AC),
                      side: const BorderSide(color: Color(0xFF5E81AC), width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ],
              ),
            
            const SizedBox(height: 20),
            
            // ملاحظة
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFFD54F)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFFF57C00)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'سيتم إنشاء تقرير شامل يحتوي على جميع بياناتك في الفترة المحددة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? date,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF5E81AC)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date != null ? Helpers.formatDate(date) : 'غير محدد',
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickOption(String label, int days) {
    return InkWell(
      onTap: () {
        setState(() {
          endDate = DateTime.now();
          startDate = endDate!.subtract(Duration(days: days));
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF5E81AC).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF5E81AC).withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF5E81AC),
          ),
        ),
      ),
    );
  }

  Widget _buildContentItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF88C9A1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF88C9A1)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final date = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? DateTime.now()) : (endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF5E81AC),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (date != null) {
      setState(() {
        if (isStartDate) {
          startDate = date;
        } else {
          endDate = date;
        }
      });
    }
  }

  Future<void> _previewPdf() async {
    if (startDate == null || endDate == null) {
      Helpers.showErrorSnackbar('الرجاء تحديد الفترة الزمنية');
      return;
    }

    setState(() {
      isGenerating = true;
    });

    try {
      final file = await controller.generateReport();
      
      if (file == null) {
        Helpers.showErrorSnackbar('لا توجد بيانات كافية لإنشاء التقرير');
        return;
      }

      // الانتقال إلى شاشة عرض PDF
      Get.to(
        () => const PdfViewerScreen(),
        arguments: file,
        transition: Transition.rightToLeft,
      );
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ أثناء إنشاء التقرير');
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }

  Future<void> _exportPdf() async {
    if (startDate == null || endDate == null) {
      Helpers.showErrorSnackbar('الرجاء تحديد الفترة الزمنية');
      return;
    }

    setState(() {
      isGenerating = true;
    });

    try {
      await controller.exportReport();
      Helpers.showSuccessSnackbar('تم تصدير التقرير بنجاح');
    } catch (e) {
      Helpers.showErrorSnackbar('حدث خطأ أثناء تصدير التقرير');
    } finally {
      setState(() {
        isGenerating = false;
      });
    }
  }
}